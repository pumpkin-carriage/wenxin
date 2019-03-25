package com.wenxin.controller.admin;

import com.wenxin.mapper.WBrandMapper;
import com.wenxin.mapper.WUserMapper;
import com.wenxin.pojo.*;
import com.wenxin.service.ProductService;
import com.wenxin.utils.Pagnation;
import com.wenxin.utils.Result;
import com.wenxin.utils.StrUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.UnknownHostException;
import java.util.List;

/**
 * @ClassName ProductController
 * @Author Spring
 * @DateTime 2019/2/6 11:06
 */
@Controller
@RequestMapping("admin/product")
public class ProductController {
    @Autowired
    private ProductService productService;
    @Autowired
    private WBrandMapper brandMapper;
    @Autowired
    private WUserMapper userMapper;
    @RequestMapping("productPage")
    public String producPage(Integer page, Integer limit, Model model){
        Pagnation<WProduct> pagnation=productService.producPage(page,limit);
        model.addAttribute("productPage",pagnation);
        WBrandExample example = new WBrandExample();
        List<WBrand> brands = brandMapper.selectByExample(example);
        model.addAttribute("brandList",brands);
        WUserExample userExample = new WUserExample();
        WUserExample.Criteria criteria = userExample.createCriteria();
        criteria.andTypeEqualTo(0);
        List<WUser> users = userMapper.selectByExample(userExample);
        model.addAttribute("userList",users);
        return "admin/product";
    }
    @RequestMapping("delete")
    public @ResponseBody Result delete(@RequestBody String[] ids){
        productService.deleteByIds(StrUtils.toIntegerList(ids));
        return Result.success(null);
    }
    @RequestMapping("addOrupdate")
    public String addOrupdate(WProduct product){
        if (product.getId()==null){
            productService.addProduct(product);
        }
        else{
            productService.updateProduct(product);
        }
       return "redirect:/admin/product/productPage?page=0&limit=6";
    }
    @RequestMapping("onsale")
    public @ResponseBody Result onsale(@RequestBody String[] ids){
        try {
            boolean b = productService.updateProductOnSale(StrUtils.toIntegerList(ids));
            if (b){
                return Result.success(null);
            }
            return Result.failure("商品类型为必填项");
        } catch (UnknownHostException e) {
            return Result.failure(null);
        }
    }
    @RequestMapping("offsale")
    public @ResponseBody Result offsale(@RequestBody String[] ids){
        try {
            productService.updateProductOffSale(StrUtils.toIntegerList(ids));
            return Result.success(null);
        } catch (UnknownHostException e) {
            return Result.failure(null);
        }
    }
    @RequestMapping("user")
    public @ResponseBody Result user(@RequestBody String[] ids){
        WUser user=productService.getUser(Integer.valueOf(ids[0]));
        return Result.success(user);
    }
}
