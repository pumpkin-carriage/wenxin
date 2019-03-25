package com.wenxin.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wenxin.mapper.WUserMapper;
import com.wenxin.pojo.WUser;
import com.wenxin.pojo.WUserExample;
import com.wenxin.service.UserService;
import com.wenxin.utils.MD5Utils;
import com.wenxin.utils.Pagnation;
import com.wenxin.utils.StrUtils;
import org.apache.commons.codec.binary.StringUtils;
import org.apache.poi.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * @ClassName UserServiceImpl
 * @Author Spring
 * @DateTime 2019/2/2 12:13
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private WUserMapper userMapper;

    @Override
    public WUser validate(String username, String password) {
        WUserExample userExample = new WUserExample();
        WUserExample.Criteria criteria = userExample.createCriteria();
        criteria.andUserNameEqualTo(username);
        criteria.andTypeEqualTo(1);
        List<WUser> users = userMapper.selectByExample(userExample);
        if (users.size() == 0) {
            return null;
        }
        WUser user = users.get(0);
        String userPassword = user.getPassword();
        String salt = user.getSalt();
        if (MD5Utils.md5(password + salt).equals(userPassword)) {
            return user;
        }
        return null;
    }

    @Override
    public WUser getUserByUserName(String userName) {
        WUserExample userExample = new WUserExample();
        WUserExample.Criteria criteria = userExample.createCriteria();
        criteria.andUserNameEqualTo(userName);
        List<WUser> users = userMapper.selectByExample(userExample);
        return users.get(0);
    }

    @Override
    public boolean updatePassword(String userName,String password) {
        WUserExample userExample = new WUserExample();
        WUserExample.Criteria criteria = userExample.createCriteria();
        criteria.andUserNameEqualTo(userName);
        List<WUser> users = userMapper.selectByExample(userExample);
        WUser user = users.get(0);
        String salt = user.getSalt();
        String pwd = MD5Utils.md5(password + salt);
        user.setPassword(pwd);
        userMapper.updateByPrimaryKeySelective(user);
        return true;
    }

    @Override
    public WUser updateUser(WUser user) {
        user.setUpdateTime(new Date());
        userMapper.updateByPrimaryKeySelective(user);
        WUser user1 = userMapper.selectByPrimaryKey(user.getId());
        if(!"".equals(user.getPassword())){
            String salt = user1.getSalt();
            String md5 = MD5Utils.md5(user.getPassword() + salt);
            user1.setPassword(md5);
            userMapper.updateByPrimaryKeySelective(user1);
        }
        return user1;
    }

    @Override
    public Pagnation getUserPage(Integer page,Integer limit,String keyword) {
        WUserExample example = new WUserExample();
        WUserExample.Criteria criteria = example.createCriteria();
        criteria.andTypeEqualTo(0);
        if (!"".equals(keyword)){
            criteria.andUserNameEqualTo(keyword);
        }
        int count = userMapper.countByExample(example);
        Pagnation<WUser> pagnation1 = new Pagnation<>(page, limit, count);
        Integer begin = pagnation1.getBegin();
        List<WUser> list = userMapper.selectPage(begin, pagnation1.getPageSize(),keyword);
        list.forEach(l->{
            l.setPassword(null);
        });
        pagnation1.setData(list);
        return pagnation1;
    }

    @Override
    public void deleteByIds(String[] ids) {
        WUserExample example = new WUserExample();
        WUserExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(StrUtils.toIntegerList(ids));
        userMapper.deleteByExample(example);
    }

    @Override
    public void addForm(WUser user) {
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        user.setType(0);
        String uuid = StrUtils.getRandom32UUID();
        user.setSalt(uuid);
        String md5 = MD5Utils.md5(user.getPassword() + uuid);
        user.setPassword(md5);
        userMapper.insert(user);
        user.setUserName("wenxin-"+user.getId());
        userMapper.updateByPrimaryKey(user);
    }
}
