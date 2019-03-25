package com.wenxin.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @ClassName DateUtil
 * @Author Spring
 * @DateTime 2019/2/10 11:13
 */
public class DateUtil {
    public static String format(Date date){
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        return  format.format(date);
    }
}
