package com.wenxin.service;

import com.wenxin.pojo.WBrand;
import com.wenxin.utils.Pagnation;

import java.util.List;

public interface BrandService {
    Pagnation getBrandPage(Integer page, Integer limit, String keyword);

    void deleteByIds(List<Integer> toIntegerList);

    void updateBrandForm(WBrand brand);

    void saveBrandForm(WBrand brand);
}
