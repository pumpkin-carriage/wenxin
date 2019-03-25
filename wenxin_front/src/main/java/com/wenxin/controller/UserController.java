package com.wenxin.controller;

import com.wenxin.pojo.WUser;
import com.wenxin.service.Userservice;
import com.wenxin.util.MailUtil;
import com.wenxin.util.Random6Util;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.ws.EndpointReference;

/**
 * @ClassName UserController
 * @Author Spring
 * @DateTime 2019/2/10 9:05
 */
@Controller
@RequestMapping("user")
public class UserController {
    @Autowired
    private Userservice userservice;
    @RequestMapping("email")
    public @ResponseBody Result email(String email){
        try {
            userservice.sendMail(email);
            return Result.success(null);
        }catch (Exception e){
            return Result.failure(null);
        }

    }
    @RequestMapping("regist")
    public @ResponseBody Result regist(@RequestParam(value = "email",defaultValue = "") String email,@RequestParam(value = "password",defaultValue = "") String password,@RequestParam(value = "code",defaultValue = "") String code){
        Result result=userservice.addUser(email,password,code);
        return result;
    }
    @RequestMapping("forget")
    public @ResponseBody Result forget(@RequestParam(value = "email",defaultValue = "") String email,@RequestParam(value = "password",defaultValue = "") String password,@RequestParam(value = "code",defaultValue = "") String code){
        Result result=userservice.updateUser(email,password,code);
        return result;
    }
    @RequestMapping("login")
    public @ResponseBody Result login(@RequestParam(value = "userName",defaultValue = "") String userName, @RequestParam(value = "password",defaultValue = "") String password, @RequestParam(value = "remember",defaultValue = "") String remember, HttpServletResponse response, HttpServletRequest request){
        Result result=userservice.findUserByUsernameAndPwd(userName,password,remember,response,request);
        return result;
    }
    @RequestMapping("logout")
    public String logout(HttpSession session){
        userservice.logout(session);
        return "login";
    }
    @RequestMapping("checkExist")
    public @ResponseBody Result checkExist(String email){
        WUser user=userservice.findUserByEmail(email);
        if (user==null){
            return Result.failure(null);
        }
        return Result.success(null);
    }
}
