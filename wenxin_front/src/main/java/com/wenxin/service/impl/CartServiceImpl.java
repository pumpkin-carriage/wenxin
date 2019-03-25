package com.wenxin.service.impl;

import com.sun.org.apache.regexp.internal.RE;
import com.wenxin.mapper.WCartMapper;
import com.wenxin.mapper.WProductImageMapper;
import com.wenxin.mapper.WProductMapper;
import com.wenxin.pojo.*;
import com.wenxin.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @ClassName CartServiceImpl
 * @Author Spring
 * @DateTime 2019/2/10 13:29
 */
@Service
public class CartServiceImpl implements CartService {
    @Autowired
    private WCartMapper cartMapper;
    @Autowired
    private WProductMapper productMapper;
    @Autowired
    private WProductImageMapper productImageMapper;
    @Override
    public List<WCart> getListByUserId(Integer userId) {
        WCartExample example = new WCartExample();
        WCartExample.Criteria criteria = example.createCriteria();
        criteria.andUserIdEqualTo(userId);
        List<WCart> list = cartMapper.selectByExample(example);
        for (WCart wCart : list) {
            WProduct product = productMapper.selectByPrimaryKey(wCart.getProductId());
            wCart.setProductName(product.getName());
        }
        return list;
    }

    @Override
    public void addCart(Integer userId, Integer proId, Integer count) {
        WCartExample example = new WCartExample();
        WCartExample.Criteria criteria = example.createCriteria();
        criteria.andProductIdEqualTo(proId);
        criteria.andUserIdEqualTo(userId);
        List<WCart> carts = cartMapper.selectByExample(example);
        if (carts.size()==0){
            WCart cart = new WCart();
            cart.setUserId(userId);
            cart.setProductId(proId);
            cart.setCount(count);
            cart.setType(1);
            WProduct product = productMapper.selectByPrimaryKey(proId);
            cart.setAmount(count*product.getPrice());
            WProductImageExample example1 = new WProductImageExample();
            WProductImageExample.Criteria criteria1 = example1.createCriteria();
            criteria1.andProductIdEqualTo(proId);
            List<WProductImage> images = productImageMapper.selectByExample(example1);
            cart.setPic(images.get(0).getImage());
            cart.setCreateTime(new Date());
            cart.setUpdateTime(new Date());
            cartMapper.insert(cart);
        }
        else{
            WCart cart = carts.get(0);
            cart.setCount(cart.getCount()+count);
            WProduct product = productMapper.selectByPrimaryKey(proId);
            cart.setAmount(cart.getCount()*product.getPrice());
            cart.setUpdateTime(new Date());
            cartMapper.updateByPrimaryKeySelective(cart);
        }
    }

    @Override
    public Long updateSubCount(Integer id) {
        WCart cart = cartMapper.selectByPrimaryKey(id);
        Integer count = cart.getCount();
        if (count>1){
            cart.setCount(count-1);
            WProduct product = productMapper.selectByPrimaryKey(cart.getProductId());
            cart.setAmount(cart.getCount()*product.getPrice());
            cart.setUpdateTime(new Date());
            cartMapper.updateByPrimaryKeySelective(cart);
        }
        return cart.getAmount();
    }

    @Override
    public Long updateAddCount(Integer id) {
        WCart cart = cartMapper.selectByPrimaryKey(id);
        Integer count = cart.getCount();
        cart.setCount(count+1);
        WProduct product = productMapper.selectByPrimaryKey(cart.getProductId());
        cart.setAmount(cart.getCount()*product.getPrice());
        cart.setUpdateTime(new Date());
        cartMapper.updateByPrimaryKeySelective(cart);
        return cart.getAmount();
    }

    @Override
    public void deleteCart(List<Integer> toIntegerList) {
        WCartExample example = new WCartExample();
        WCartExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(toIntegerList);
        cartMapper.deleteByExample(example);
    }
}
