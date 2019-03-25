package com.wenxin.interceptor.admin;

import com.wenxin.pojo.WUser;
import com.wenxin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @ClassName MainInterceptor
 * @Author Spring
 * @DateTime 2019/2/2 19:03
 */
public class MainInterceptor extends HandlerInterceptorAdapter {
    @Autowired
    private JedisPool jedisPool;
    @Value("${jedis_session_time}")
    private Integer jedis_session_time;
    @Autowired
    private UserService userService;
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
       boolean isLogin=true;
        HttpSession session = request.getSession();
        Jedis jedis = jedisPool.getResource();
        WUser user= (WUser) session.getAttribute("user");
        if (user==null){
            response.sendRedirect("/admin/login/view");
            return false;
        }
        String id = jedis.get("user-" +user.getUserName());
        if (id==null||"".equals(id)){
            isLogin=false;
            session.removeAttribute("user");
            response.sendRedirect("/admin/login/view");
        }else{
            jedis.setex("user-"+user.getUserName(),jedis_session_time,user.getId()+"");
        }
        jedis.close();
        return isLogin;
    }
}
