package com.wenxin.service;

import com.wenxin.pojo.WUser;
import com.wenxin.utils.Result;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public interface Userservice {
    void sendMail(String email);

    Result addUser(String email, String password, String code);

    WUser findUserByEmail(String email);

    Result updateUser(String email, String password, String code);

    Result findUserByUsernameAndPwd(String userName, String password, String remember, HttpServletResponse response, HttpServletRequest request);

    WUser findById(Integer id);

    void logout(HttpSession session);
}
