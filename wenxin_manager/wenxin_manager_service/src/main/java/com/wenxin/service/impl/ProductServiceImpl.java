package com.wenxin.service.impl;

import com.wenxin.mapper.*;
import com.wenxin.pojo.*;
import com.wenxin.service.ProductService;
import com.wenxin.utils.Pagnation;
import org.elasticsearch.action.bulk.BulkRequestBuilder;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.common.transport.TransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.*;

/**
 * @ClassName ProductServiceImpl
 * @Author Spring
 * @DateTime 2019/2/6 11:09
 */
@Service
public class ProductServiceImpl implements ProductService {
    @Autowired
    private WProductMapper productMapper;
    @Autowired
    private WProductExtMapper productExtMapper;
    @Autowired
    private WProductImageMapper productImageMapper;
    @Autowired
    private WBrandMapper brandMapper;
    @Autowired
    private WProductTypeMapper productTypeMapper;
    @Autowired
    private WUserProductMapper userProductMapper;
    @Autowired
    private WUserMapper userMapper;
    @Value("${es_ip}")
    private String es_ip;
    @Value("${es_port}")
    private Integer es_port;
    @Value("${es_index}")
    private String es_index;
    @Value("${es_doc}")
    private String es_doc;
    @Override
    public Pagnation<WProduct> producPage(Integer page,Integer limit) {
        WProductExample example = new WProductExample();
        int totalCount = productMapper.countByExample(example);
        Pagnation<WProduct> pagnation = new Pagnation<>(page, limit, totalCount);
        List<WProduct> list = productMapper.selectPage(pagnation.getBegin(), pagnation.getPageSize());
        list.forEach(p->{
            WProductExtExample example1 = new WProductExtExample();
            WProductExtExample.Criteria criteria = example1.createCriteria();
            criteria.andProductIdEqualTo(p.getId());
            List<WProductExt> exts = productExtMapper.selectByExample(example1);
            p.setDescription(exts.get(0).getDescription());
            WProductImageExample example2 = new WProductImageExample();
            WProductImageExample.Criteria criteria1 = example2.createCriteria();
            criteria1.andProductIdEqualTo(p.getId());
            List<WProductImage> images = productImageMapper.selectByExample(example2);
            p.setImage(images.get(0).getImage());
            WUserProductExample example3 = new WUserProductExample();
            WUserProductExample.Criteria criteria2 = example3.createCriteria();
            criteria2.andProductIdEqualTo(p.getId());
            List<WUserProduct> userProducts = userProductMapper.selectByExample(example3);
            p.setUserId(userProducts.get(0).getUserId());
        });
        pagnation.setData(list);
        return pagnation;
    }

    @Override
    public void deleteByIds(List<Integer> toIntegerList) {
        WProductExample example = new WProductExample();
        WProductExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(toIntegerList);
        productMapper.deleteByExample(example);

        WProductExtExample extExample = new WProductExtExample();
        WProductExtExample.Criteria criteria1 = extExample.createCriteria();
        criteria1.andProductIdIn(toIntegerList);
        productExtMapper.deleteByExample(extExample);

        WProductImageExample imageExample = new WProductImageExample();
        WProductImageExample.Criteria criteria2 = imageExample.createCriteria();
        criteria2.andProductIdIn(toIntegerList);
        productImageMapper.deleteByExample(imageExample);
        WUserProductExample productExample = new WUserProductExample();
        WUserProductExample.Criteria criteria3 = productExample.createCriteria();
        criteria3.andProductIdIn(toIntegerList);
        userProductMapper.deleteByExample(productExample);

    }

    @Override
    public void addProduct(WProduct product) {
        product.setBadCommentCount(0);
        product.setCommentCount(0);
        product.setCommonCommentCount(0);
        product.setCreateTime(new Date());
        product.setUpdateTime(new Date());
        product.setGoodCommentCount(0);
        product.setOffSaleTime(new Date());
        product.setSaleCount(0);
        product.setState(0);
        productMapper.insert(product);

        WProductExt ext = new WProductExt();
        ext.setCreateTime(new Date());
        ext.setUpdateTime(new Date());
        ext.setDescription(product.getDescription());
        ext.setProductId(product.getId());
        ext.setRichContent(product.getRichContent());
        productExtMapper.insert(ext);

        WProductImage image = new WProductImage();
        image.setCreateTime(new Date());
        image.setProductId(product.getId());
        image.setUpdateTime(new Date());
        image.setImage(product.getImage());
        productImageMapper.insert(image);

        WUserProduct userProduct = new WUserProduct();
        userProduct.setProductId(product.getId());
        userProduct.setUserId(product.getUserId());
        userProduct.setCreateTime(new Date());
        userProduct.setUpdateTime(new Date());
        userProductMapper.insert(userProduct);
    }

    @Override
    public void updateProduct(WProduct product) {
        product.setUpdateTime(new Date());
        productMapper.updateByPrimaryKeySelective(product);
        WProductExtExample example = new WProductExtExample();
        WProductExtExample.Criteria criteria = example.createCriteria();
        criteria.andProductIdEqualTo(product.getId());
        List<WProductExt> exts = productExtMapper.selectByExample(example);
        WProductExt ext = exts.get(0);
        if (!"<p><br></p>".equals(product.getRichContent())){
            ext.setRichContent(product.getRichContent());
        }
        ext.setDescription(product.getDescription());
        ext.setUpdateTime(new Date());
        productExtMapper.updateByPrimaryKeySelective(ext);
        WProductImageExample example1 = new WProductImageExample();
        WProductImageExample.Criteria criteria1 = example1.createCriteria();
        criteria1.andProductIdEqualTo(product.getId());
        List<WProductImage> images = productImageMapper.selectByExample(example1);
        WProductImage image = images.get(0);
        image.setImage(product.getImage());
        image.setUpdateTime(new Date());
        productImageMapper.updateByPrimaryKeySelective(image);

        WUserProductExample userProductExample = new WUserProductExample();
        WUserProductExample.Criteria exampleCriteria = userProductExample.createCriteria();
        exampleCriteria.andProductIdEqualTo(product.getId());
        List<WUserProduct> products = userProductMapper.selectByExample(userProductExample);
        WUserProduct userProduct = products.get(0);
        userProduct.setUserId(product.getUserId());
        userProduct.setUpdateTime(new Date());
        userProductMapper.updateByPrimaryKey(userProduct);
    }

    public TransportClient getEsClient() throws UnknownHostException {
        return new PreBuiltTransportClient(Settings.EMPTY)
                .addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(es_ip),es_port));
    }
    @Override
    public boolean updateProductOnSale(List<Integer> toIntegerList) throws UnknownHostException {
        List<WProduct> products=new ArrayList<>();
        TransportClient client = getEsClient();
        BulkRequestBuilder bulk = client.prepareBulk();
        for (Integer productId : toIntegerList) {
            WProduct product = productMapper.selectByPrimaryKey(productId);
           if(product.getProductTypeId()==null){
               return false;
           }
            product.setState(1);
            product.setOnSaleTime(new Date());
            product.setOffSaleTime(null);
            products.add(product);
            WProductImageExample example = new WProductImageExample();
            WProductImageExample.Criteria criteria = example.createCriteria();
            criteria.andProductIdEqualTo(productId);
            List<WProductImage> images = productImageMapper.selectByExample(example);

            WProductExtExample example1 = new WProductExtExample();
            WProductExtExample.Criteria criteria1 = example1.createCriteria();
            criteria1.andProductIdEqualTo(productId);
            List<WProductExt> exts = productExtMapper.selectByExample(example1);

            Map<String,Object> esMap=new HashMap<>();
            esMap.put("id",productId);
            esMap.put("name",product.getName());
            esMap.put("onSaleTime",product.getOnSaleTime());
            esMap.put("offSaleTime",product.getOffSaleTime());
            esMap.put("productTypeId",product.getProductTypeId());
            esMap.put("image",images.get(0).getImage());
            esMap.put("count",product.getCount());
            esMap.put("saleCount",product.getSaleCount());
            esMap.put("description",exts.get(0).getDescription());
            esMap.put("price",product.getPrice());
            bulk.add(client.prepareIndex(es_index,es_doc,productId+"").setSource(esMap));
        }
        bulk.get();
        productMapper.updateStateBatch(products);
        return true;

    }
/*  ES数据结构
    private Integer id;
    private String name;
    private Integer brandId;
    private String brandName;
    private Integer productTypeId;
    private String productTypeName;
    private String onSaleTime;
    private String offSaleTime;
    private String image;
    private Integer commentCount;
    private Long price;
    private Integer saleCount;
    private String description;
 */
    @Override
    public void updateProductOffSale(List<Integer> toIntegerList) throws UnknownHostException {
        List<WProduct> products=new ArrayList<>();
        TransportClient client = getEsClient();
        for (Integer productId : toIntegerList) {
            WProduct product = productMapper.selectByPrimaryKey(productId);
            product.setState(0);
            product.setOffSaleTime(new Date());
            product.setOnSaleTime(null);
            products.add(product);
            client.prepareDelete(es_index,es_doc,productId+"").get();
        }
        productMapper.updateStateBatch(products);
    }

    @Override
    public WUser getUser(Integer valueOf) {
        WUserProductExample userProductExample = new WUserProductExample();
        WUserProductExample.Criteria criteria = userProductExample.createCriteria();
        criteria.andProductIdEqualTo(valueOf);
        List<WUserProduct> userProducts = userProductMapper.selectByExample(userProductExample);
        WUserProduct userProduct = userProducts.get(0);
        Integer userId = userProduct.getUserId();
        WUser user = userMapper.selectByPrimaryKey(userId);
        user.setPassword(null);
        user.setSalt(null);
        return user;
    }
}
