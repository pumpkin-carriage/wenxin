package com.wenxin.service;

import com.wenxin.pojo.WBulletin;
import com.wenxin.utils.Pagnation;

public interface BulletinService {
    Pagnation<WBulletin> findPage(Integer page, Integer limit);

    void deleteBulletins(Integer[] ids);

    void addBulletin(WBulletin bulletin);
}
