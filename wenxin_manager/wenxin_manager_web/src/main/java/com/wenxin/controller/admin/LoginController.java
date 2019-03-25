package com.wenxin.controller.admin;

import com.wenxin.pojo.WUser;
import com.wenxin.service.UserService;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * @ClassName LoginController
 * @Author Spring
 * @DateTime 2019/2/2 16:24
 */
@Controller
@RequestMapping("admin/login")
public class LoginController {
    @Autowired
    private UserService userService;
    @Autowired
    private JedisPool jedisPool;
    @Value("${jedis_session_time}")
    private Integer jedis_session_time;
    @RequestMapping("view")
    public String view(){
        return "admin/login";
    }
    @RequestMapping("login")
    public @ResponseBody Result login(HttpServletResponse response,HttpServletRequest request, @RequestParam(value = "userName",defaultValue = "") String userName, @RequestParam(value = "password",defaultValue = "") String password, HttpSession session){
        if ("".equals(userName)||"".equals(password)){
            return Result.failure("登录失败");
        }
        WUser user=userService.validate(userName,password);
            if (user==null){
                return Result.failure("登录失败");
            }
            else{
                Jedis jedis = jedisPool.getResource();
                jedis.setex("user-"+userName,jedis_session_time,user.getId()+"");
                jedis.close();
                user.setPassword(null);
                session.setAttribute("user",user);
                 }
            return Result.success(user);
    }
    @RequestMapping("logout")
    public String logout(HttpSession session){
        WUser user= (WUser) session.getAttribute("user");
        if (user!=null){
            Jedis jedis = jedisPool.getResource();
            jedis.del("user-"+user.getUserName());

        }
        session.removeAttribute("user");
        return "admin/login";
    }
}
