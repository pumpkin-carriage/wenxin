package com.wenxin.service;

import com.wenxin.pojo.WProductType;
import com.wenxin.utils.SimpleZtree;
import com.wenxin.utils.ZTree;

import java.util.List;

public interface ProductTypeService {
    List<WProductType> getProductTypeList();

    List<ZTree> getZtreeList();

    void deleteById(Integer id);

    void addProductType(WProductType productType);

    void updateProductType(WProductType productType);

    List<SimpleZtree> getSimpleZtreeList();

    boolean checkName(String name);
}
