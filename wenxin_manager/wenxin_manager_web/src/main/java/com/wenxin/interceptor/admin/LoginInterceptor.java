package com.wenxin.interceptor.admin;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;
import java.util.Map;

/**
 * @ClassName LoginInterceptor
 * @Author Spring
 * @DateTime 2019/2/2 20:55
 */
public class LoginInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        boolean hasParams=true;
        Map map = request.getParameterMap();
        if (map.size()==0){
            response.sendRedirect("/admin/login/view");
            hasParams=false;
        }
        return hasParams;
    }
}
