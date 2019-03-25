package com.wenxin.service.impl;

import com.wenxin.mapper.WBulletinMapper;
import com.wenxin.pojo.WBulletin;
import com.wenxin.pojo.WBulletinExample;
import com.wenxin.service.BulletinService;
import com.wenxin.utils.Pagnation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @ClassName BulletinServiceImpl
 * @Author Spring
 * @DateTime 2019/2/13 15:12
 */
@Service
public class BulletinServiceImpl implements BulletinService {
    @Autowired
    private WBulletinMapper bulletinMapper;
    @Override
    public Pagnation<WBulletin> findPage(Integer page, Integer limit) {
        WBulletinExample example = new WBulletinExample();
        int count = bulletinMapper.countByExample(example);
        Pagnation<WBulletin> pagnation = new Pagnation<>(page, limit, count);
        List<WBulletin> bulletins = bulletinMapper.selectPage(pagnation.getBegin(), pagnation.getPageSize());
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        bulletins.forEach(bulletin -> {
            Date time = bulletin.getCreateTime();
            String s = format.format(time);
            bulletin.setViewTime(s);
        });
        pagnation.setData(bulletins);
        return pagnation;
    }

    @Override
    public void deleteBulletins(Integer[] ids) {
        WBulletinExample example = new WBulletinExample();
        WBulletinExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(Arrays.asList(ids));
        bulletinMapper.deleteByExample(example);
    }

    @Override
    public void addBulletin(WBulletin bulletin) {
        bulletin.setCreateTime(new Date());
        bulletin.setUpdateTime(new Date());
        bulletinMapper.insert(bulletin);
    }
}
