package com.wenxin.service.impl;

import com.sun.org.apache.regexp.internal.RE;
import com.wenxin.mapper.WProductTypeMapper;
import com.wenxin.pojo.WProductType;
import com.wenxin.pojo.WProductTypeExample;
import com.wenxin.service.ProductTypeService;
import com.wenxin.utils.SimpleZtree;
import com.wenxin.utils.ZTree;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @ClassName ProductTypeServiceImpl
 * @Author Spring
 * @DateTime 2019/2/4 22:48
 */
@Service
public class ProductTypeServiceImpl implements ProductTypeService {
    @Autowired
    private WProductTypeMapper productTypeMapper;
    @Value("${close_image}")
    private String close_image;
    @Value("${open_image}")
    private String open_image;
    @Value("${children_image}")
    private String children_image;
    @Override
    public List<WProductType> getProductTypeList() {
        WProductTypeExample example = new WProductTypeExample();
        return productTypeMapper.selectByExample(example);
    }

    @Override
    public List<ZTree> getZtreeList() {
        List<WProductType> typeList = getProductTypeList();
        Map<Integer, ZTree> map = new HashMap<>();
        typeList.forEach(type -> {
            ZTree tree = new ZTree();
            tree.setId(type.getId());
            tree.setpId(type.getPid());
            tree.setOpen(true);
            tree.setName(type.getName());
            map.put(tree.getId(), tree);
        });
        List<ZTree> list = new ArrayList<>();
        map.forEach((k,v)->{
            if (v.getpId()==0){
                if(v.getChildren()==null){
                    List<ZTree> trees = new ArrayList<>();
                    v.setChildren(trees);
                }
                v.setIconClose(close_image);
                v.setIconOpen(open_image);
                list.add(v);
            }else{
                v.setIcon(children_image);
                Integer id = v.getpId();
                ZTree tree = map.get(id);
                List<ZTree> children = tree.getChildren();
                if (children==null){
                    children=new ArrayList<>();
                    tree.setChildren(children);
                }
                children.add(v);
            }
        });
        return list;
    }

    @Override
    public void deleteById(Integer id) {
        productTypeMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void addProductType(WProductType productType) {
        productType.setCreateTime(new Date());
        productType.setUpdateTime(new Date());
        if (productType.getPid()==null){
            productType.setPid(0);
            productTypeMapper.insert(productType);
            productType.setPath("-"+productType.getId()+"-");
        }
        else{
            productTypeMapper.insert(productType);
            Integer id = productType.getId();
            WProductType parent = productTypeMapper.selectByPrimaryKey(productType.getPid());
            productType.setPath(parent.getPath()+id+"-");
        }
        productTypeMapper.updateByPrimaryKeySelective(productType);
    }

    @Override
    public void updateProductType(WProductType productType) {
        productType.setUpdateTime(new Date());
        productTypeMapper.updateByPrimaryKeySelective(productType);
    }

    @Override
    public List<SimpleZtree> getSimpleZtreeList() {
        List<WProductType> typeList = getProductTypeList();
        List<SimpleZtree> list=new ArrayList<>();
        typeList.forEach(type->{
            SimpleZtree ztree = new SimpleZtree();
            ztree.setId(type.getId());
            ztree.setpId(type.getPid());
            ztree.setName(type.getName());
            list.add(ztree);
        });
        return list;
    }

    @Override
    public boolean checkName(String name) {
        WProductTypeExample example = new WProductTypeExample();
        WProductTypeExample.Criteria criteria = example.createCriteria();
        criteria.andNameEqualTo(name);
        List<WProductType> types = productTypeMapper.selectByExample(example);
        if(types.size()==0){
            return false;
        }
        return true;
    }
}
