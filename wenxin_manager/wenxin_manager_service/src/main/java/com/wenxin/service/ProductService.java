package com.wenxin.service;

import com.wenxin.pojo.WProduct;
import com.wenxin.pojo.WUser;
import com.wenxin.utils.Pagnation;

import java.net.UnknownHostException;
import java.util.List;

public interface ProductService {
    Pagnation<WProduct> producPage(Integer page,Integer limit);

    void deleteByIds(List<Integer> toIntegerList);

    void addProduct(WProduct product);

    void updateProduct(WProduct product);

    boolean updateProductOnSale(List<Integer> toIntegerList) throws UnknownHostException;

    void updateProductOffSale(List<Integer> toIntegerList) throws UnknownHostException;

    WUser getUser(Integer valueOf);
}
