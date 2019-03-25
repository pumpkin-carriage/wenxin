package com.wenxin.utils;

import javax.servlet.http.Cookie;

/**
 * @ClassName CookieUtils
 * @Author Spring
 * @DateTime 2019/2/1 20:54
 */
public class CookieUtils {
    public static Cookie getCookieByName(String name,Cookie[] cookies){
        if (cookies==null){
            return null;
        }
        for (Cookie cookie : cookies) {
            if (name.equals(cookie.getName())){
                return cookie;
            }
        }
        return null;
    }
}
