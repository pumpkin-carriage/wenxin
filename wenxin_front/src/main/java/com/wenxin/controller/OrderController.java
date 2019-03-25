package com.wenxin.controller;

import com.wenxin.pojo.WComment;
import com.wenxin.pojo.WOrder;
import com.wenxin.pojo.WOrderExt;
import com.wenxin.pojo.WUser;
import com.wenxin.service.WOrderService;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName OrderController
 * @Author Spring
 * @DateTime 2019/2/13 9:26
 */
@Controller
@RequestMapping("order")
public class OrderController {
    @Autowired
    private WOrderService orderService;
    @RequestMapping("add")
    public @ResponseBody Result add (@RequestBody String[] ids,HttpSession session){
        WUser user = (WUser) session.getAttribute("user");
        Integer orderId=orderService.addOrder(user.getId(),ids);
        return Result.success(orderId);
    }
    @RequestMapping("{id}")
    public String show(@PathVariable("id") Integer id, Model model){
        WOrder order=orderService.getOrder(id);
        model.addAttribute("order",order);
        return "order";
    }
    @RequestMapping("pay")
    public String pay(WOrderExt orderExt, Model model, HttpSession session){
       try {
           List<String> addExt = orderService.addExt(orderExt, session);
           model.addAttribute("orderNo",orderExt.getOrderNo());
           if (addExt.size()==0){
               return "complete";
           }
           else{
               model.addAttribute("names",addExt);
               return "fail";
           }
       }catch (Exception e){
           List<String> addExt=new ArrayList<>();
           addExt.add("系统检测到该订单你已确认，请不要重复确认");
           model.addAttribute("names",addExt);
           return "fail";
       }
    }
    @RequestMapping("myorder")
    public String myorder(HttpSession session,Model model){
        WUser user= (WUser) session.getAttribute("user");
        List<WOrder> orders=orderService.selectMyOrder(user.getId());
        model.addAttribute("orderList",orders);
        return "myorder";
    }
    @RequestMapping("cancel/{id}")
    public @ResponseBody Result receive(@PathVariable("id")Integer id){
        orderService.updateState(id,3);
        return Result.success(null);
    }
    @RequestMapping("del/{id}")
    public @ResponseBody Result del(@PathVariable("id")Integer id){
        orderService.DeleteById(id);
        return Result.success(null);
    }
    @RequestMapping("comment")
    public String comment(WComment comment,HttpSession session){
        WUser user = (WUser) session.getAttribute("user");
        comment.setUserId(user.getId());
        orderService.addComment(comment);
        return "redirect:/order/myorder";
    }
    @RequestMapping("receive/{id}")
    public @ResponseBody Result receive1(@PathVariable Integer id){
       orderService.updateState(id,1);
        return Result.success(null);
    }
}
