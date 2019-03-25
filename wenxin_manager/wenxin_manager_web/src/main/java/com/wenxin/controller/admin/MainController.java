package com.wenxin.controller.admin;

import com.wenxin.service.UserService;
import com.wenxin.utils.Pagnation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @ClassName MainController
 * @Author Spring
 * @DateTime 2019/2/2 18:28
 */
@Controller
@RequestMapping("admin/main")
public class MainController {
    @Autowired
    private UserService userService;
    @RequestMapping("index")
    public String index(){
        return "admin/index";
    }
    @RequestMapping("accessPressure")
    public String accessPressure(){
        return "admin/accessPressure";
    }
    @RequestMapping("user")
    public String user(@RequestParam(value = "page",defaultValue = "1") Integer page, @RequestParam(value ="limit",defaultValue = "6") Integer limit,@RequestParam(value = "keyword",defaultValue = "") String keyword, Model model){
        Pagnation pagnation = userService.getUserPage(page, limit,keyword);
        model.addAttribute("userList",pagnation);
        return "admin/user";
    }
    @GetMapping("view")
    public String view(){
        return "admin/bulletin";
    }
    @RequestMapping("print")
    public String print(){
        return "admin/print";
    }
    @RequestMapping("productSale")
    public String productSale(){
        return "admin/productSale";
    }
    @RequestMapping("changePass")
    public String changePass(){
        return "admin/changePass";
    }
    @RequestMapping("personalData")
    public String personalData(){
        return "admin/personalData";
    }
    @RequestMapping("productType")
    public String productType(){
        return "admin/productType";
    }
    @RequestMapping("product")
    public String product(Integer page,Integer limit){
        return "redirect:/admin/product/productPage?page="+page+"&limit="+limit;
    }
    @RequestMapping("brand")
    public String brand(){
        return "admin/brand";
    }
    @RequestMapping("order")
    public String order(Integer page,Integer limit){
        return "redirect:/admin/order/orderPage?page=1&limit=6";
    }
}
