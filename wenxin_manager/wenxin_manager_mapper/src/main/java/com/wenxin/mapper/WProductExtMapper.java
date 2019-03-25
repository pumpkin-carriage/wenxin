package com.wenxin.mapper;

import com.wenxin.pojo.WProductExt;
import com.wenxin.pojo.WProductExtExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WProductExtMapper {
    int countByExample(WProductExtExample example);

    int deleteByExample(WProductExtExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WProductExt record);

    int insertSelective(WProductExt record);

    List<WProductExt> selectByExampleWithBLOBs(WProductExtExample example);

    List<WProductExt> selectByExample(WProductExtExample example);

    WProductExt selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WProductExt record, @Param("example") WProductExtExample example);

    int updateByExampleWithBLOBs(@Param("record") WProductExt record, @Param("example") WProductExtExample example);

    int updateByExample(@Param("record") WProductExt record, @Param("example") WProductExtExample example);

    int updateByPrimaryKeySelective(WProductExt record);

    int updateByPrimaryKeyWithBLOBs(WProductExt record);

    int updateByPrimaryKey(WProductExt record);
}