package com.wenxin.util;

import java.util.UUID;

/**
 * @ClassName Random6Util
 * @Author Spring
 * @DateTime 2019/2/10 9:31
 */
public class Random6Util {
    public static String code(){
        return UUID.randomUUID().toString().replaceAll("-","").substring(0,6);
    }
}
