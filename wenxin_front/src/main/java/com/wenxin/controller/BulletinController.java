package com.wenxin.controller;

import com.wenxin.pojo.WBulletin;
import com.wenxin.service.WBulletinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * @ClassName BulletinController
 * @Author Spring
 * @DateTime 2019/2/13 17:46
 */
@Controller
@RequestMapping("bulletin")
public class BulletinController {
    @Autowired
    private WBulletinService bulletinService;
    @GetMapping
    public String view(Model model){
        List<WBulletin> bulletins=bulletinService.getAll();
        model.addAttribute("bulletinList",bulletins);
        return "bulletin";
    }
}
