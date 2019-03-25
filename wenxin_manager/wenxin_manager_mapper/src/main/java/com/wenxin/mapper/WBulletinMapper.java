package com.wenxin.mapper;

import com.wenxin.pojo.WBulletin;
import com.wenxin.pojo.WBulletinExample;
import java.util.List;

import com.wenxin.pojo.WUser;
import org.apache.ibatis.annotations.Param;

public interface WBulletinMapper {
    int countByExample(WBulletinExample example);

    int deleteByExample(WBulletinExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WBulletin record);

    int insertSelective(WBulletin record);

    List<WBulletin> selectByExample(WBulletinExample example);

    WBulletin selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WBulletin record, @Param("example") WBulletinExample example);

    int updateByExample(@Param("record") WBulletin record, @Param("example") WBulletinExample example);

    int updateByPrimaryKeySelective(WBulletin record);

    int updateByPrimaryKey(WBulletin record);

    List<WBulletin> selectPage(@Param("start") Integer start, @Param("pageSize") Integer pageSize);
}