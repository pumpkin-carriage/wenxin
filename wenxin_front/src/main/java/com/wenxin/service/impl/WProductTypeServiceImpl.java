package com.wenxin.service.impl;

import com.wenxin.mapper.WProductTypeMapper;
import com.wenxin.pojo.WProduct;
import com.wenxin.pojo.WProductType;
import com.wenxin.pojo.WProductTypeExample;
import com.wenxin.service.WProductTypeService;
import com.wenxin.utils.Result;
import org.elasticsearch.common.metrics.EWMA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @ClassName ProductTypeServiceImpl
 * @Author Spring
 * @DateTime 2019/2/11 18:56
 */
@Service
public class WProductTypeServiceImpl implements WProductTypeService {
    @Autowired
    private WProductTypeMapper productTypeMapper;
    @Override
    public List<WProductType> getList() {
        WProductTypeExample example = new WProductTypeExample();
        WProductTypeExample.Criteria criteria = example.createCriteria();
        List<WProductType> types = productTypeMapper.selectByExample(example);
        Map<Integer, WProductType> hashMap = new HashMap<>();
        types.forEach(t->{
            hashMap.put(t.getId(),t);
        });
       return list(hashMap);
    }
    List<WProductType> list(Map<Integer,WProductType> hashMap){
        List<WProductType> types=new ArrayList<>();
        hashMap.forEach((k,v)->{
            if (v.getPid()==0){
                if (v.getChildren()==null){
                    List<WProductType> list = new ArrayList<>();
                    v.setChildren(list);
                }
                types.add(v);
            }
            else{
                WProductType type = getType(hashMap, k);
                type.getChildren().add(v);
            }
        });
        return types;
    }
    public WProductType getType(Map<Integer,WProductType> v,Integer id){
        WProductType type = v.get(id);
        while (type.getPid()!=0){
            type=getType(v,type.getPid());
        }
        return type;
    }
}
