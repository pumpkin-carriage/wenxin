package com.wenxin.controller;

import com.wenxin.pojo.WUser;
import com.wenxin.service.Userservice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @ClassName MainController
 * @Author Spring
 * @DateTime 2019/2/8 21:11
 */
@Controller
@RequestMapping("main")
public class MainController {
    @Autowired
    private Userservice userservice;
    @RequestMapping("index")
    public String index(){
        return "index";
    }
    @RequestMapping("footer")
    public String footer(){
        return "footer";
    }
    @RequestMapping("login")
    public String login(){
        return "login";
    }
    @RequestMapping("forget")
    public String forget(){
        return "forget";
    }
    @RequestMapping("regist")
    public String regist(){
        return "regist";
    }
}
