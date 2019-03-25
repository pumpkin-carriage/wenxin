package com.wenxin.service.impl;

import com.wenxin.mapper.WBulletinMapper;
import com.wenxin.pojo.WBulletin;
import com.wenxin.pojo.WBulletinExample;
import com.wenxin.service.WBulletinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * @ClassName WBulletinServiceImpl
 * @Author Spring
 * @DateTime 2019/2/13 17:48
 */
@Service
public class WBulletinServiceImpl implements WBulletinService {
    @Autowired
    private WBulletinMapper bulletinMapper;
    @Override
    public List<WBulletin> getAll() {
        WBulletinExample example = new WBulletinExample();
        List<WBulletin> bulletins = bulletinMapper.selectByExample(example);
        Collections.sort(bulletins, new Comparator<WBulletin>() {
            @Override
            public int compare(WBulletin o1, WBulletin o2) {
                return (int)(o2.getCreateTime().getTime()-o1.getCreateTime().getTime());
            }
        });
        return bulletins;
    }
}
