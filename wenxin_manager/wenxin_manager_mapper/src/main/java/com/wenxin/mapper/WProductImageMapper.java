package com.wenxin.mapper;

import com.wenxin.pojo.WProductImage;
import com.wenxin.pojo.WProductImageExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WProductImageMapper {
    int countByExample(WProductImageExample example);

    int deleteByExample(WProductImageExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WProductImage record);

    int insertSelective(WProductImage record);

    List<WProductImage> selectByExample(WProductImageExample example);

    WProductImage selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WProductImage record, @Param("example") WProductImageExample example);

    int updateByExample(@Param("record") WProductImage record, @Param("example") WProductImageExample example);

    int updateByPrimaryKeySelective(WProductImage record);

    int updateByPrimaryKey(WProductImage record);
}