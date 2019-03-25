package com.wenxin.service.impl;

import com.wenxin.mapper.*;
import com.wenxin.pojo.*;
import com.wenxin.service.WOrderService;
import com.wenxin.util.MailUtil;
import com.wenxin.utils.StrUtils;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.*;
import java.util.concurrent.ExecutionException;

/**
 * @ClassName WOrderServiceImpl
 * @Author Spring
 * @DateTime 2019/2/13 9:30
 */
@Service
public class WOrderServiceImpl implements WOrderService {
    @Value("${es_ip}")
    private String es_ip;
    @Value("${es_port}")
    private Integer es_port;
    @Value("${es_index}")
    private String es_index;
    @Value("${es_doc}")
    private String es_doc;
    @Autowired
    private WOrderMapper orderMapper;
    @Autowired
    private WOrderExtMapper orderExtMapper;
    @Autowired
    WCartMapper cartMapper;
    @Autowired
    private WOrderInfoMapper orderInfoMapper;
    @Autowired
    private WProductMapper productMapper;
    @Autowired
    private WProductImageMapper productImageMapper;
    @Autowired
    private WCommentMapper commentMapper;
    @Autowired
    private MailUtil mailUtil;
    @Autowired
    private WUserProductMapper userProductMapper;
    @Autowired
    private WUserMapper userMapper;

    @Override
    public Integer addOrder(Integer id, String[] ids) {
        WOrder order = new WOrder();
        order.setUserId(id);
        order.setNo(id + "" + System.currentTimeMillis());
        List<Integer> integers = StrUtils.toIntegerList(ids);
        Long totalMoney = 0L;
        WCartExample example = new WCartExample();
        WCartExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(integers);
        List<WCart> carts = cartMapper.selectByExample(example);
        for (WCart cart : carts) {
            totalMoney += cart.getAmount();
        }
        order.setTotalMoney(totalMoney);
        order.setState(5);
        order.setCreateTime(new Date());
        order.setUpdateTime(new Date());
        orderMapper.insert(order);
        for (WCart cart : carts) {
            WOrderInfo orderInfo = new WOrderInfo();
            orderInfo.setCreateTime(new Date());
            orderInfo.setUpdateTime(new Date());
            orderInfo.setOrderId(order.getId());
            orderInfo.setOrderNo(order.getNo());
            orderInfo.setProductId(cart.getProductId());
            orderInfo.setCount(cart.getCount());
            orderInfo.setAmount(cart.getAmount());
            WProduct product = productMapper.selectByPrimaryKey(cart.getProductId());
            orderInfo.setPrice(product.getPrice());
            orderInfoMapper.insert(orderInfo);
        }
        return order.getId();
    }
    public TransportClient getClient(){
        try {
            return new PreBuiltTransportClient(Settings.EMPTY)
                    .addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(es_ip),es_port));
        } catch (UnknownHostException e) {
            return null;
        }
    }
    @Override
    public WOrder getOrder(Integer id) {
        WOrder order = orderMapper.selectByPrimaryKey(id);
        WOrderInfoExample infoExample = new WOrderInfoExample();
        WOrderInfoExample.Criteria criteria = infoExample.createCriteria();
        criteria.andOrderIdEqualTo(id);
        List<WOrderInfo> infos = orderInfoMapper.selectByExample(infoExample);
        infos.forEach(info -> {
            WProduct product = productMapper.selectByPrimaryKey(info.getProductId());
            info.setProductName(product.getName());
        });
        order.setOrderInfoList(infos);
        return order;
    }

    @Override
    public List<String> addExt(WOrderExt orderExt, HttpSession session) {
        WUser user = (WUser) session.getAttribute("user");
        WOrder order = orderMapper.selectByPrimaryKey(orderExt.getOrderId());
        WOrderInfoExample infoExample = new WOrderInfoExample();
        WOrderInfoExample.Criteria criteria1 = infoExample.createCriteria();
        criteria1.andOrderIdEqualTo(order.getId());
        List<WOrderInfo> infos = orderInfoMapper.selectByExample(infoExample);
        boolean flag = true;
        List<String> arrayList = new ArrayList<>();
        WOrderInfo info = infos.get(0);
        WProduct product = productMapper.selectByPrimaryKey(info.getProductId());
        if (product.getCount() < info.getCount()) {
            arrayList.add("商品 ( " + product.getName() + " ) 库存量不足");
            flag = false;
        }
        if (flag) {
            WOrderExtExample extExample = new WOrderExtExample();
            WOrderExtExample.Criteria criteria = extExample.createCriteria();
            criteria.andOrderIdEqualTo(orderExt.getOrderId());
            List<WOrderExt> exts = orderExtMapper.selectByExample(extExample);
            if (exts.size() == 0) {
                orderExt.setUpdateTime(new Date());
                orderExt.setCreateTime(new Date());
                orderExtMapper.insert(orderExt);
            } else {
                WOrderExt ext = exts.get(0);
                ext.setUpdateTime(new Date());
                ext.setAddress(orderExt.getAddress());
                ext.setPhone(orderExt.getPhone());
                ext.setReceiver(orderExt.getReceiver());
                orderExtMapper.updateByPrimaryKeySelective(ext);
            }
            product.setCount(product.getCount() - info.getCount());
            product.setUpdateTime(new Date());
            product.setSaleCount(product.getSaleCount() + info.getCount());
            productMapper.updateByPrimaryKeySelective(product);
            WCartExample example = new WCartExample();
            WCartExample.Criteria criteria2 = example.createCriteria();
            criteria2.andUserIdEqualTo(user.getId());
            criteria2.andProductIdEqualTo(product.getId());
            List<WCart> list = cartMapper.selectByExample(example);
            WCart cart = list.get(0);
            cartMapper.deleteByPrimaryKey(cart.getId());
            order.setPayTime(new Date());
            order.setState(0);
            order.setUpdateTime(new Date());
            orderMapper.updateByPrimaryKeySelective(order);

            WUserProductExample wUserProductExample = new WUserProductExample();
            WUserProductExample.Criteria criteria3 = wUserProductExample.createCriteria();
            criteria3.andProductIdEqualTo(product.getId());
            List<WUserProduct> products = userProductMapper.selectByExample(wUserProductExample);
            Integer userId = products.get(0).getUserId();
            WUser wUser = userMapper.selectByPrimaryKey(userId);
            //给卖家发送邮件提醒
            mailUtil.sendMail(wUser.getEmail(),"商品预约提醒","你有新的订单:"+order.getNo()+"，买家姓名:"+orderExt.getReceiver()+"；买家联系电话："+orderExt.getPhone()+"；买家意向联系地址:"+orderExt.getAddress()+"，请尽快处理和联系");
            //如果库存为0，从es删除，否则，从es中减库存
            if(product.getCount()-info.getCount()==0){
                getClient().prepareDelete(es_index,es_doc,product.getId()+"").get();
                product.setState(2);
                product.setUpdateTime(new Date());
                productMapper.updateByPrimaryKeySelective(product);
            }else{
                GetResponse response = getClient().prepareGet(es_index, es_doc, product.getId() + "").get();
                Map<String, Object> map = response.getSourceAsMap();
                map.put("count",product.getCount()-info.getCount());
                UpdateRequest updateRequest = new UpdateRequest();
                updateRequest
                        .index(es_index)
                        .type(es_doc)
                        .id(product.getId()+"")
                        .doc(map);
                try {
                    getClient().update(updateRequest).get();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (ExecutionException e) {
                    e.printStackTrace();
                }
            }
        } else {
            order.setState(3);
            order.setUpdateTime(new Date());
            orderMapper.updateByPrimaryKeySelective(order);
        }
        return arrayList;
    }

    @Override
    public List<WOrder> selectMyOrder(Integer id) {
        WOrderExample example = new WOrderExample();
        WOrderExample.Criteria criteria = example.createCriteria();
        criteria.andStateNotEqualTo(4);
        criteria.andUserIdEqualTo(id);
        List<WOrder> orders = orderMapper.selectByExample(example);
        Collections.sort(orders, new Comparator<WOrder>() {
            @Override
            public int compare(WOrder o1, WOrder o2) {
                return (int) (o2.getPayTime().getTime() - o1.getPayTime().getTime());
            }
        });
        orders.forEach(order -> {
            WOrderInfoExample infoExample = new WOrderInfoExample();
            WOrderInfoExample.Criteria criteria1 = infoExample.createCriteria();
            criteria1.andOrderIdEqualTo(order.getId());
            List<WOrderInfo> infos = orderInfoMapper.selectByExample(infoExample);
            for (WOrderInfo info : infos) {
                WProduct product = productMapper.selectByPrimaryKey(info.getProductId());
                info.setProductName(product.getName());
                WProductImageExample imageExample = new WProductImageExample();
                WProductImageExample.Criteria criteria2 = imageExample.createCriteria();
                criteria2.andProductIdEqualTo(product.getId());
                List<WProductImage> images = productImageMapper.selectByExample(imageExample);
                info.setImage(images.get(0).getImage());
            }
            order.setOrderInfoList(infos);
        });
        return orders;
    }

    @Override
    public void updateState(Integer id, Integer state) {
        WOrder order = orderMapper.selectByPrimaryKey(id);
        order.setState(state);
        order.setUpdateTime(new Date());
        orderMapper.updateByPrimaryKeySelective(order);
    }

    @Override
    public void DeleteById(Integer id) {
        WOrder order = orderMapper.selectByPrimaryKey(id);
        order.setState(4);
        orderMapper.updateByPrimaryKeySelective(order);
    }

    @Override
    public void addComment(WComment comment) {
        comment.setCreateTime(new Date());
        Integer orderId = comment.getOrderId();
        WOrderInfoExample example = new WOrderInfoExample();
        WOrderInfoExample.Criteria criteria = example.createCriteria();
        criteria.andOrderIdEqualTo(orderId);
        List<WOrderInfo> infos = orderInfoMapper.selectByExample(example);
        comment.setProductId(infos.get(0).getProductId());
        commentMapper.insert(comment);
        WOrder wOrder = orderMapper.selectByPrimaryKey(orderId);
        wOrder.setUpdateTime(new Date());
        wOrder.setState(2);
        orderMapper.updateByPrimaryKeySelective(wOrder);
    }
}
