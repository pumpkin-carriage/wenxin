package com.wenxin.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wenxin.pojo.WUser;
import com.wenxin.service.UserService;
import com.wenxin.utils.Pagnation;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @ClassName UserController
 * @Author Spring
 * @DateTime 2019/2/2 22:32
 */
@Controller
@RequestMapping("admin/user")
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("checkPassword")
    public @ResponseBody
    Result checkPassword(@RequestParam(value = "userName", defaultValue = "") String userName, @RequestParam(value = "password", defaultValue = "") String password) {
        WUser user = userService.validate(userName, password);
        if (user == null) {
            return Result.failure("密码不正确");
        }
        return Result.success(null);
    }
    @RequestMapping("updatePassword")
    public @ResponseBody
    Result updatePassword(@RequestParam(value = "userName", defaultValue = "") String userName, @RequestParam(value = "password", defaultValue = "") String password) {
        boolean result = userService.updatePassword(userName, password);
        if (result) {
            return Result.success(null);
        }
        return Result.failure(null);
    }

    @RequestMapping("updateUser")
    public @ResponseBody
    Result updateUser(@RequestBody WUser user, HttpSession session) {
        WUser user1 = userService.updateUser(user);
        session.setAttribute("user",user1);
        return Result.success(null);
    }
    @RequestMapping("updateUserForm")
    public String updateUserForm(WUser user) {
        userService.updateUser(user);
        return "redirect:/admin/main/user";
    }@RequestMapping("addForm")
    public String addForm(WUser user) {
        userService.addForm(user);
        return "redirect:/admin/main/user";
    }
    @RequestMapping("delete")
    public @ResponseBody Result deleteByIds(@RequestBody String[] ids){
        userService.deleteByIds(ids);
        return Result.success(null);
    }
}
