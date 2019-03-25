package com.wenxin.controller.admin;

import com.wenxin.pojo.WBrand;
import com.wenxin.service.BrandService;
import com.wenxin.utils.Pagnation;
import com.wenxin.utils.Result;
import com.wenxin.utils.StrUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @ClassName BrandController
 * @Author Spring
 * @DateTime 2019/2/4 10:10
 */
@Controller
@RequestMapping("admin/brand")
public class BrandController {
    @Autowired
    private BrandService brandService;
    @RequestMapping("brandPage")
    public @ResponseBody Pagnation brandPage(@RequestParam(value = "page",defaultValue = "1")Integer page,@RequestParam(value = "limit",defaultValue = "6")Integer limit,@RequestParam(value = "keyword",defaultValue = "")String keyword){
        Pagnation pagnation = brandService.getBrandPage(page, limit, keyword);
        return pagnation;
    }
    @RequestMapping("delete")
    public @ResponseBody Result delete(@RequestBody String[] ids){
        brandService.deleteByIds(StrUtils.toIntegerList(ids));
        return Result.success(null);
    }
    @RequestMapping("updateBrandForm")
    public String updateBrandForm(WBrand brand){
        if (brand.getId()!=null){
            brandService.updateBrandForm(brand);
        }
        else{
            brandService.saveBrandForm(brand);
        }
        return "redirect:/admin/main/brand";
    }
}
