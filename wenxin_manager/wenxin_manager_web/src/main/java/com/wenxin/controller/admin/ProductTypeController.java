package com.wenxin.controller.admin;

import com.wenxin.pojo.WProductType;
import com.wenxin.service.ProductTypeService;
import com.wenxin.utils.Result;
import com.wenxin.utils.SimpleZtree;
import com.wenxin.utils.ZTree;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ProductTypeController
 * @Author Spring
 * @DateTime 2019/2/4 22:43
 */
@Controller
@RequestMapping("admin/productType")
public class ProductTypeController {
    @Autowired
    private ProductTypeService productTypeService;
    @RequestMapping("getZtreeList")
    public @ResponseBody Result getZtreeList(){
        List<ZTree> list=productTypeService.getZtreeList();
        return Result.success(list);
    } @RequestMapping("getSimpleZtreeList")
    public @ResponseBody Result getSimpleZtreeList(){
        List<SimpleZtree> list=productTypeService.getSimpleZtreeList();
        return Result.success(list);
    }
    @RequestMapping("getProductTypeList")
    public @ResponseBody Result getProductTypeList(){
        List<WProductType> list=productTypeService.getProductTypeList();
        return Result.success(list);
    }
    @RequestMapping("deleteById")
    public @ResponseBody Result deleteById(Integer id){
        productTypeService.deleteById(id);
        return Result.success(null);
    } @RequestMapping("checkName")
    public @ResponseBody Result checkName(@RequestBody  String name){
        boolean exist=productTypeService.checkName(name);
        if (exist){
            return Result.failure(null);
        }
        return Result.success(null);
    }
    @RequestMapping("addOrupdate")
    public @ResponseBody Result addOrupdate(@RequestBody WProductType productType){
        if ("".equals(productType.getDescription())){
            productType.setDescription(productType.getName());
        }
        if (productType.getId()==null){
            productTypeService.addProductType(productType);
        }
        else{
            productTypeService.updateProductType(productType);
        }
        List<ZTree> list=productTypeService.getZtreeList();
        return Result.success(list);
    }
}
