package com.wenxin.utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @ClassName MD5Utils
 * @Author Spring
 * @DateTime 2019/2/2 10:04
 */
public class MD5Utils {
    public static String md5(String text){
        try {
            byte[] secret = MessageDigest.getInstance("md5").digest(text.getBytes());
            String md5Code=new BigInteger(1,secret).toString(16);
            for (int i=0;i<32-md5Code.length();i++){
                md5Code="0"+md5Code;
            }
            return md5Code;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }
}
