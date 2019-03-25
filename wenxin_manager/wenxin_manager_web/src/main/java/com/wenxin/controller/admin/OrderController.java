package com.wenxin.controller.admin;

import com.wenxin.pojo.WOrder;
import com.wenxin.service.OrderService;
import com.wenxin.utils.Pagnation;
import com.wenxin.utils.Result;
import com.wenxin.utils.StrUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @ClassName OrderController
 * @Author Spring
 * @DateTime 2019/2/7 11:29
 */
@Controller
@RequestMapping("admin/order")
public class OrderController {
    @Autowired
    private OrderService orderService;
    @RequestMapping("print")
    public void print(String time, HttpServletResponse response, HttpServletRequest request) throws IOException {
        orderService.print(time,response,request);
    }
    @RequestMapping("orderPage")
    public String orderPage(Integer page, Integer limit, Model model){
        Pagnation<WOrder> pagnation=orderService.getOrderPage(page,limit);
        model.addAttribute("orderPage",pagnation);
        return "admin/order";
    }
    @RequestMapping("delete")
    public @ResponseBody Result delete(@RequestBody String[] ids){
        boolean result = orderService.deleteByIds(StrUtils.toIntegerList(ids));
        if (result){
            return Result.success(null);
        }
        return Result.failure(null);
    }
}
