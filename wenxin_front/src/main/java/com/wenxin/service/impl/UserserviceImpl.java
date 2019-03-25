package com.wenxin.service.impl;

import com.wenxin.mapper.WLoginInfoMapper;
import com.wenxin.mapper.WUserMapper;
import com.wenxin.pojo.WLoginInfo;
import com.wenxin.pojo.WUser;
import com.wenxin.pojo.WUserExample;
import com.wenxin.service.Userservice;
import com.wenxin.util.DateUtil;
import com.wenxin.util.MailUtil;
import com.wenxin.util.Random6Util;
import com.wenxin.utils.CookieUtils;
import com.wenxin.utils.MD5Utils;
import com.wenxin.utils.Result;
import com.wenxin.utils.StrUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * @ClassName UserserviceImpl
 * @Author Spring
 * @DateTime 2019/2/10 9:39
 */
@Service
public class UserserviceImpl implements Userservice {
    @Autowired
    private JedisPool jedisPool;
    @Autowired
    private MailUtil mailUtil;
    @Autowired
    private WUserMapper userMapper;
    @Autowired
    private WLoginInfoMapper loginInfoMapper;
    @Override
    public void sendMail(String email){
        String code = Random6Util.code();
        mailUtil.sendMail(email,"温馨商城-注册验证通知","尊敬的 "+email+" 您好，您此次注册的验证码为："+code+",一分钟之内输入有效");
        try {
            Jedis jedis = jedisPool.getResource();
            jedis.setex(email,60,code);
        }catch (Exception e){

        }
    }

    @Override
    public Result addUser(String email, String password, String code) {
        try {
            if ("".equals(email) || "".equals(password)) {
                return Result.failure("请输入用户名和密码");
            } else {
                Jedis jedis = jedisPool.getResource();
                String jcode = jedis.get(email);

                if (jcode == null || !code.equalsIgnoreCase(jcode)) {
                    return Result.failure("验证码错误");
                } else {
                    String salt = StrUtils.getRandom32UUID();
                    String pwd = MD5Utils.md5(password + salt);
                    WUser user = new WUser();
                    user.setUserName("wenxin-" + code);
                    user.setPassword(pwd);
                    user.setType(0);
                    user.setSalt(salt);
                    user.setCreateTime(new Date());
                    user.setUpdateTime(new Date());
                    user.setEmail(email);
                    userMapper.insert(user);
                    mailUtil.sendMail(email, "温馨商城-注册通知", "用户 " + email + "您好，恭喜您注册成功，您的用户名为：" + user.getUserName() + ",密码为：" + password + ",请妥善保管账号");
                    return Result.success(null);
                }
            }
        }catch (Exception e){
            return Result.failure("失败");
        }
    }

    @Override
    public WUser findUserByEmail(String email) {
        WUserExample example = new WUserExample();
        WUserExample.Criteria criteria = example.createCriteria();
        criteria.andEmailEqualTo(email);
        List<WUser> list = userMapper.selectByExample(example);
        if (list.size()==0){
            return null;
        }
        else{
            return list.get(0);
        }
    }

    @Override
    public Result updateUser(String email, String password, String code) {
        try {
            if ("".equals(email) || "".equals(password)) {
                return Result.failure("请输入用户名和密码");
            } else {
                Jedis jedis = jedisPool.getResource();
                String jcode = jedis.get(email);

                if (jcode == null || !code.equalsIgnoreCase(jcode)) {
                    return Result.failure("验证码错误");
                } else {
                    WUserExample example = new WUserExample();
                    WUserExample.Criteria criteria = example.createCriteria();
                    criteria.andEmailEqualTo(email);
                    List<WUser> list = userMapper.selectByExample(example);
                    WUser user = list.get(0);
                    String salt = StrUtils.getRandom32UUID();
                    String pwd = MD5Utils.md5(password + salt);
                    user.setPassword(pwd);
                    user.setSalt(salt);
                    user.setUpdateTime(new Date());
                    userMapper.updateByPrimaryKeySelective(user);
                    mailUtil.sendMail(email, "温馨商城-修改密码通知", "用户 " + user.getUserName() + "您好，您于： " + DateUtil.format(new Date()) + " 修改密码为：" + password);
                    return Result.success(null);
                }
            }
        }catch (Exception e){
            return Result.failure("失败");
        }
    }

    @Override
    public Result findUserByUsernameAndPwd(String userName, String password, String remember, HttpServletResponse response, HttpServletRequest request) {
        WUserExample example = new WUserExample();
        WUserExample.Criteria criteria = example.createCriteria();
        criteria.andUserNameEqualTo(userName);
        criteria.andTypeEqualTo(0);
        List<WUser> list = userMapper.selectByExample(example);
        if (list.size()==0){
            return Result.failure("用户名不存在");
        }
        else{
            WUser user = list.get(0);
            String salt = user.getSalt();
            String md5 = MD5Utils.md5(password + salt);
            if (!md5.equals(user.getPassword())){
                return Result.failure("密码错误");
            }
            else{
                user.setPassword(null);
                request.getSession().setAttribute("user",user);
                request.getSession().setMaxInactiveInterval(7200);//两小时
                WLoginInfo info = new WLoginInfo();
                info.setLoginTime(new Date());
                info.setUserId(user.getId());
                info.setIpAddress( request.getHeader("x-forwarded-for"));
                loginInfoMapper.insert(info);
                if ("true".equals(remember)){
                    Cookie cookie = new Cookie("wenxin-username",userName);
                    cookie.setMaxAge(60*60*24*30);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }
                else{
                    Cookie cookie = CookieUtils.getCookieByName("wenxin-username", request.getCookies());
                    if (cookie!=null){
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }
                }
                return Result.success(user.getId());
            }
        }
    }

    @Override
    public WUser findById(Integer id) {
        return userMapper.selectByPrimaryKey(id);
    }

    @Override
    public void logout(HttpSession session) {
        session.removeAttribute("user");
    }
}
