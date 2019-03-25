package com.wenxin.mapper;

import com.wenxin.pojo.WCart;
import com.wenxin.pojo.WCartExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WCartMapper {
    int countByExample(WCartExample example);

    int deleteByExample(WCartExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WCart record);

    int insertSelective(WCart record);

    List<WCart> selectByExample(WCartExample example);

    WCart selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WCart record, @Param("example") WCartExample example);

    int updateByExample(@Param("record") WCart record, @Param("example") WCartExample example);

    int updateByPrimaryKeySelective(WCart record);

    int updateByPrimaryKey(WCart record);
}