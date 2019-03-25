package com.wenxin.controller;

import com.wenxin.pojo.WProductType;
import com.wenxin.service.WProductTypeService;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @ClassName PeoductTypeController
 * @Author Spring
 * @DateTime 2019/2/11 18:54
 */
@Controller
@RequestMapping("productType")
public class ProductTypeController {
    @Autowired
    private WProductTypeService productTypeService;
    @RequestMapping("list")
    public @ResponseBody Result getList(){
       List<WProductType> list= productTypeService.getList();
       return Result.success(list);
    }
}
