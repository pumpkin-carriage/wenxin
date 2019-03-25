package com.wenxin.controller.interceptor;

import com.wenxin.mapper.WUserMapper;
import com.wenxin.pojo.WUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @ClassName IndexInterceptor
 * @Author Spring
 * @DateTime 2019/2/10 14:00
 */
public class IndexInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        boolean flag = false;
        WUser user = (WUser) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("/main/login");
        } else {
            request.getSession().setMaxInactiveInterval(7200);//重新设置为2小时
            flag = true;
        }
        return flag;
    }
}
