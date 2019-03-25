package com.wenxin.service;


import com.wenxin.pojo.WUser;
import com.wenxin.utils.Pagnation;

import java.util.List;

/**
 * @ClassName UserService
 * @Author Spring
 * @DateTime 2019/2/2 12:12
 */
public interface UserService {
    WUser validate(String username, String password) ;

    WUser getUserByUserName(String userName);

    boolean updatePassword(String userName,String password);

    WUser updateUser(WUser user);

    Pagnation getUserPage(Integer page, Integer limit,String keyword);

    void deleteByIds(String[] ids);

    void addForm(WUser user);
}
