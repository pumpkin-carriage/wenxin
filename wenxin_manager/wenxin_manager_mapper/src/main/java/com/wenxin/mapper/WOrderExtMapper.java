package com.wenxin.mapper;

import com.wenxin.pojo.WOrderExt;
import com.wenxin.pojo.WOrderExtExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WOrderExtMapper {
    int countByExample(WOrderExtExample example);

    int deleteByExample(WOrderExtExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WOrderExt record);

    int insertSelective(WOrderExt record);

    List<WOrderExt> selectByExample(WOrderExtExample example);

    WOrderExt selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WOrderExt record, @Param("example") WOrderExtExample example);

    int updateByExample(@Param("record") WOrderExt record, @Param("example") WOrderExtExample example);

    int updateByPrimaryKeySelective(WOrderExt record);

    int updateByPrimaryKey(WOrderExt record);
}