package com.wenxin.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * @ClassName StrUtils
 * @Author Spring
 * @DateTime 2019/2/2 11:10
 */
public class StrUtils {
    public static String getRandom32UUID(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
    public static List<Integer> toIntegerList(String str){
        String[] split = str.split(",");
        ArrayList<Integer> list = new ArrayList<>();
        for (String s : split) {
            list.add(Integer.valueOf(s));
        }
        return list;
    }
    public static List<Integer> toIntegerList(String[] str){
        ArrayList<Integer> list = new ArrayList<>();
        for (String s : str) {
            list.add(Integer.valueOf(s));
        }
        return list;
    }
}
