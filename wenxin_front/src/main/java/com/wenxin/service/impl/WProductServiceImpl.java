package com.wenxin.service.impl;

import com.wenxin.mapper.*;
import com.wenxin.pojo.*;
import com.wenxin.service.WProductService;
import com.wenxin.utils.CookieUtils;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.get.MultiGetItemResponse;
import org.elasticsearch.action.get.MultiGetResponse;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.sort.SortOrder;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sound.midi.Soundbank;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.*;

/**
 * @ClassName WProductServiceImpl
 * @Author Spring
 * @DateTime 2019/2/11 22:12
 */
@Service
public class WProductServiceImpl implements WProductService {
    @Value("${es_ip}")
    private String es_ip;
    @Value("${es_port}")
    private Integer es_port;
    @Value("${es_index}")
    private String es_index;
    @Value("${es_doc}")
    private String es_doc;
    @Autowired
    private WProductMapper productMapper;
    @Autowired
    private WProductTypeMapper productTypeMapper;
    @Autowired
    private WProductImageMapper productImageMapper;
    @Autowired
    private WProductExtMapper productExtMapper;
    @Autowired
    private WUserProductMapper userProductMapper;
    public TransportClient getClient(){
        try {
            return new PreBuiltTransportClient(Settings.EMPTY)
                    .addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(es_ip),es_port));
        } catch (UnknownHostException e) {
            return null;
        }
    }
    @Override
    public List<WProduct> getListById(Integer id) {

        WProductTypeExample example1 = new WProductTypeExample();
        List<WProductType> list = productTypeMapper.selectByExample(example1);
        Set<Integer> ids=new HashSet<>();
        ids.add(id);
        for (WProductType type : list) {
            int index=-1;
            String[] split = type.getPath().split("-");
            for (int i=0;i<split.length;i++){
                if ((id+"").equals(split[i])){
                    index=i;
                    break;
                }
            }
            if (index!=-1){
                for (int i=index;i<split.length;i++){
                    ids.add(Integer.valueOf(split[i]));
                }
            }

        }
      /*  Object[] objects = ids.toArray();
        String[] strs = new String[objects.length];
        for (int i = 0; i < objects.length; i++) {
            strs[i]=objects[i]+"";
        }*/
        TransportClient client = getClient();
        if (client==null){
            return new ArrayList<>();
        }
        List<WProduct> products=new ArrayList<>();

        SearchRequestBuilder scroll = client.prepareSearch(es_index).setSize(100).setScroll(TimeValue.timeValueMinutes(1));
        SearchResponse searchResponse = scroll.get();
        do{
            SearchHit[] hits = searchResponse.getHits().getHits();
            for (SearchHit hit : hits) {
                Map<String, Object> map = hit.getSourceAsMap();
                if (ids.contains(Integer.valueOf(map.get("productTypeId")+""))){
                    WProduct product = new WProduct();
                    product.setId(Integer.valueOf(map.get("id")+""));
                    product.setImage(map.get("image")+"");
                    product.setName(map.get("name")+"");
                    product.setCount(Integer.valueOf(map.get("count")+""));
                    product.setPrice(Long.valueOf(map.get("price")+""));
                    products.add(product);
                }
            }
            searchResponse=client.prepareSearchScroll(searchResponse.getScrollId()).setScroll(TimeValue.timeValueMinutes(1)).execute().actionGet();
        }while (searchResponse.getHits().getHits().length!=0); //当searchHits的数组为空的时候结束循环，至此数据全部读取完毕
        return products;
    }
    @Override
    public WProduct getById(Integer id, HttpServletResponse response, HttpServletRequest request, Model model) {
        WProduct product = productMapper.selectByPrimaryKey(id);
        WProductImageExample example = new WProductImageExample();
        WProductImageExample.Criteria criteria = example.createCriteria();
        criteria.andProductIdEqualTo(id);
        List<WProductImage> images = productImageMapper.selectByExample(example);
        product.setImage(images.get(0).getImage());
        WProductExtExample extExample = new WProductExtExample();
        WProductExtExample.Criteria criteria3 = extExample.createCriteria();
        criteria3.andProductIdEqualTo(id);
        List<WProductExt> exts = productExtMapper.selectByExampleWithBLOBs(extExample);
        product.setDescription(exts.get(0).getDescription());
        product.setRichContent(exts.get(0).getRichContent());
        model.addAttribute("product",product);
        Cookie cookie = CookieUtils.getCookieByName("history", request.getCookies());
        if (cookie==null){
            cookie=new Cookie("history",null);
        }
        List<Integer> integers = new LinkedList<>();
        String string = cookie.getValue();
        if (string==null){
            integers.add(id);
            cookie.setValue(id+"-");
        }
        else{
            /*1-4-*/
            String substring = string.substring(0, string.length() - 1);
            /*1-4*/
            String[] split = substring.split("-");/*1,4*/
            List<String> strings = Arrays.asList(split);
            LinkedList<String> linkedList = new LinkedList<>();
            for (String s : strings) {
                linkedList.add(s);
            }
            if (linkedList.contains(id+"")){
                linkedList.remove(id+"");
            }
            else{
                if (linkedList.size()>=5){
                    linkedList.removeLast();
                }
            }
            linkedList.addFirst(id+"");
            cookie.setValue("");
            for (int i=0;i<linkedList.size();i++){
                ((LinkedList<Integer>) integers).addLast(Integer.valueOf(linkedList.get(i)));
                cookie.setValue(cookie.getValue()+linkedList.get(i)+"-");
            }
        }
        cookie.setMaxAge(60*60*24*30);
        response.addCookie(cookie);
        WProductExample example1 = new WProductExample();
        WProductExample.Criteria criteria1 = example1.createCriteria();
        criteria1.andIdIn(integers);
        List<WProduct> products = productMapper.selectByExample(example1);
        LinkedList<WProduct> wProducts = new LinkedList<>();
        for (int i=0;i<integers.size();i++){
            for (WProduct wProduct : products) {
                if (wProduct.getId()==integers.get(i)){
                    wProducts.addLast(wProduct);
                    break;
                }
            }
        }
        products.forEach(p->{
            WProductImageExample example2 = new WProductImageExample();
            WProductImageExample.Criteria criteria2 = example2.createCriteria();
            criteria2.andProductIdEqualTo(p.getId());
            List<WProductImage> images1 = productImageMapper.selectByExample(example2);
            p.setImage(images1.get(0).getImage());
        });
        model.addAttribute("history",wProducts);
        return product;
    }

    @Override
    public List<WProduct> getListByKeyword(String keyword) {
        TransportClient client = getClient();
        List<WProduct> products = new ArrayList<>();
        if (client!=null){
            SearchRequestBuilder search = client.prepareSearch();
            BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
            search.setQuery(boolQueryBuilder);
            List<QueryBuilder> must = boolQueryBuilder.must();
            must.add(QueryBuilders.matchQuery("productAll",keyword));
            SearchResponse response = search.get();
            SearchHit[] hits = response.getHits().getHits();
            for (SearchHit hit : hits) {
                Map<String, Object> map = hit.getSourceAsMap();
                WProduct product = new WProduct();
                product.setId(Integer.valueOf(map.get("id")+""));
                product.setImage(map.get("image")+"");
                product.setName(map.get("name")+"");
                product.setCount(Integer.valueOf(map.get("count")+""));
                product.setPrice(Long.valueOf(map.get("price")+""));
                products.add(product);
            }
        }
        return products;
    }

    @Override
    public List<WProduct> getMyProduct(Integer id) {
        WUserProductExample userProductExample = new WUserProductExample();
        WUserProductExample.Criteria criteria = userProductExample.createCriteria();
        criteria.andUserIdEqualTo(id);
        List<WUserProduct> select = userProductMapper.selectByExample(userProductExample);
        List<Integer> list = new ArrayList<>();
        for (WUserProduct userProduct : select) {
            list.add(userProduct.getProductId());
        }
        WProductExample example = new WProductExample();
        WProductExample.Criteria criteria1 = example.createCriteria();
        criteria1.andIdIn(list);
        List<WProduct> products = productMapper.selectByExample(example);
        products.forEach(p->{
            WProductImageExample productImageExample = new WProductImageExample();
            WProductImageExample.Criteria criteria2 = productImageExample.createCriteria();
            criteria2.andProductIdEqualTo(p.getId());
            List<WProductImage> images = productImageMapper.selectByExample(productImageExample);
            p.setImage(images.get(0).getImage());
        });
        List<WProduct> wProducts = new ArrayList<>();
        products.forEach(p->{
            if (p.getState()!=3)
                wProducts.add(p);
        });
        return wProducts;
    }

    @Override
    public void updateOff(Integer id) {
        getClient().prepareDelete(es_index,es_doc,id+"").get();
        WProduct product = productMapper.selectByPrimaryKey(id);
        product.setState(2);
        product.setUpdateTime(new Date());
        productMapper.updateByPrimaryKeySelective(product);
    }

    @Override
    public void updateDel(Integer id) {
        WProduct product = productMapper.selectByPrimaryKey(id);
        product.setState(3);
        product.setUpdateTime(new Date());
        productMapper.updateByPrimaryKeySelective(product);
    }

    @Override
    public void add(WProduct product, HttpSession session) {
        product.setUpdateTime(new Date());
        product.setCreateTime(new Date());
        product.setState(0);
        product.setSaleCount(0);
        productMapper.insert(product);

        WProductExt ext = new WProductExt();
        ext.setDescription(product.getDescription());
        ext.setUpdateTime(new Date());
        ext.setCreateTime(new Date());
        ext.setProductId(product.getId());
        productExtMapper.insert(ext);

        WProductImage image = new WProductImage();
        image.setImage(product.getImage());
        image.setUpdateTime(new Date());
        image.setCreateTime(new Date());
        image.setProductId(product.getId());
        productImageMapper.insert(image);

        WUser user = (WUser) session.getAttribute("user");
        WUserProduct userProduct = new WUserProduct();
        userProduct.setUserId(user.getId());
        userProduct.setUpdateTime(new Date());
        userProduct.setCreateTime(new Date());
        userProduct.setProductId(product.getId());
        userProductMapper.insert(userProduct);
    }
}
