package com.wenxin.service.impl;

import com.wenxin.mapper.WBrandMapper;
import com.wenxin.pojo.WBrand;
import com.wenxin.pojo.WBrandExample;
import com.wenxin.service.BrandService;
import com.wenxin.utils.Pagnation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @ClassName BrandServiceImpl
 * @Author Spring
 * @DateTime 2019/2/4 10:17
 */
@Service
public class BrandServiceImpl implements BrandService {
    @Autowired
    private WBrandMapper brandMapper;
    @Override
    public Pagnation getBrandPage(Integer page, Integer limit, String keyword) {
        WBrandExample example = new WBrandExample();
        WBrandExample.Criteria criteria = example.createCriteria();
        criteria.andNameLike("%"+keyword+"%");
        int totalCount = brandMapper.countByExample(example);
        Pagnation<WBrand> pagnation = new Pagnation<WBrand>(page,limit,totalCount);
        List<WBrand> list = brandMapper.selectPage(pagnation.getBegin(), pagnation.getPageSize(), keyword);
        pagnation.setData(list);
        return pagnation;
    }

    @Override
    public void deleteByIds(List<Integer> toIntegerList) {
        WBrandExample example = new WBrandExample();
        WBrandExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(toIntegerList);
        brandMapper.deleteByExample(example);
    }

    @Override
    public void updateBrandForm(WBrand brand) {
        brand.setUpdateTime(new Date());
        brandMapper.updateByPrimaryKeySelective(brand);
    }

    @Override
    public void saveBrandForm(WBrand brand) {
        brand.setUpdateTime(new Date());
        brand.setCreateTime(new Date());
        brandMapper.insert(brand);
    }
}
