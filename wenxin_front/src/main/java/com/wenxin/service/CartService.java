package com.wenxin.service;

import com.wenxin.pojo.WCart;

import java.util.List;

public interface CartService {
    List<WCart> getListByUserId(Integer userId);

    void addCart(Integer userId, Integer proId, Integer count);

    Long updateSubCount(Integer id);

    Long updateAddCount(Integer id);

    void deleteCart(List<Integer> toIntegerList);
}
