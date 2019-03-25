package com.wenxin.mapper;

import com.wenxin.pojo.WUser;
import com.wenxin.pojo.WUserExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WUserMapper {
    int countByExample(WUserExample example);

    int deleteByExample(WUserExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WUser record);

    int insertSelective(WUser record);

    List<WUser> selectByExample(WUserExample example);

    WUser selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WUser record, @Param("example") WUserExample example);

    int updateByExample(@Param("record") WUser record, @Param("example") WUserExample example);

    int updateByPrimaryKeySelective(WUser record);

    int updateByPrimaryKey(WUser record);

    List<WUser> selectPage(@Param("start") Integer start,@Param("pageSize") Integer pageSize,@Param("keyword")String keyword);
}