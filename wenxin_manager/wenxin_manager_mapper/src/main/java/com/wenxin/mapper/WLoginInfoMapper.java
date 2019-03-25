package com.wenxin.mapper;

import com.wenxin.pojo.WLoginInfo;
import com.wenxin.pojo.WLoginInfoExample;
import java.util.List;

import com.wenxin.utils.ZXT;
import org.apache.ibatis.annotations.Param;

public interface WLoginInfoMapper {
    int countByExample(WLoginInfoExample example);

    int deleteByExample(WLoginInfoExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WLoginInfo record);

    int insertSelective(WLoginInfo record);

    List<WLoginInfo> selectByExample(WLoginInfoExample example);

    WLoginInfo selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WLoginInfo record, @Param("example") WLoginInfoExample example);

    int updateByExample(@Param("record") WLoginInfo record, @Param("example") WLoginInfoExample example);

    int updateByPrimaryKeySelective(WLoginInfo record);

    int updateByPrimaryKey(WLoginInfo record);

    List<ZXT> selectInfo();
}