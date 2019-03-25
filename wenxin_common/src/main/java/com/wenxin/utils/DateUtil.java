package com.wenxin.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @ClassName DateUtil
 * @Author Spring
 * @DateTime 2019/2/8 14:27
 */
public class DateUtil {
    public static String dateToString(Date date){
        SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
        return format.format(date);
    }
}
