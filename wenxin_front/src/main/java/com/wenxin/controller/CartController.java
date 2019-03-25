package com.wenxin.controller;

import com.wenxin.mapper.WProductMapper;
import com.wenxin.pojo.WCart;
import com.wenxin.pojo.WProduct;
import com.wenxin.pojo.WUser;
import com.wenxin.service.CartService;
import com.wenxin.util.CartUtil;
import com.wenxin.utils.Result;
import com.wenxin.utils.StrUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName CartController
 * @Author Spring
 * @DateTime 2019/2/9 21:46
 */
@Controller
@RequestMapping("cart")
public class CartController {
    @Autowired
    private CartService cartService;
    @Autowired
    private WProductMapper productMapper;
    @RequestMapping("list")
    public @ResponseBody Result list(HttpSession session){
        WUser user = (WUser) session.getAttribute("user");
        CartUtil util = new CartUtil();
        List<WCart> list=cartService.getListByUserId(user.getId());
        list.forEach(cart->{
            WProduct product = productMapper.selectByPrimaryKey(cart.getProductId());
            cart.setPrice(product.getPrice());
            util.setTotalCount(util.getTotalCount()+cart.getCount());
            util.setTotalAmount(util.getTotalAmount()+cart.getAmount());
        });
        util.setList(list);
        return Result.success(util);
    }
    @RequestMapping("view")
    public String view(){
        return "cart";
    }
    @RequestMapping("add")
    public @ResponseBody Result add(HttpSession session,Integer proId,Integer count){
        WUser user = (WUser) session.getAttribute("user");
        cartService.addCart(user.getId(),proId,count);
        return Result.success(null);
    }
    @RequestMapping("sub/{id}")
    public @ResponseBody Result sub(@PathVariable("id")Integer id){
        Long subCount = cartService.updateSubCount(id);
        return Result.success(subCount);
    }
    @RequestMapping("add/{id}")
    public @ResponseBody Result add(@PathVariable("id")Integer id){
        Long addCount = cartService.updateAddCount(id);
        return Result.success(addCount);
    } @RequestMapping("del")
    public @ResponseBody Result del(@RequestBody String[] ids){
        cartService.deleteCart(StrUtils.toIntegerList(ids));
        return Result.success(null);
    }
}
