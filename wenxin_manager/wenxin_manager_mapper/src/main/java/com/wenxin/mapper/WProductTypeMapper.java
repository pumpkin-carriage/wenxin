package com.wenxin.mapper;

import com.wenxin.pojo.WProductType;
import com.wenxin.pojo.WProductTypeExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WProductTypeMapper {
    int countByExample(WProductTypeExample example);

    int deleteByExample(WProductTypeExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WProductType record);

    int insertSelective(WProductType record);

    List<WProductType> selectByExample(WProductTypeExample example);

    WProductType selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WProductType record, @Param("example") WProductTypeExample example);

    int updateByExample(@Param("record") WProductType record, @Param("example") WProductTypeExample example);

    int updateByPrimaryKeySelective(WProductType record);

    int updateByPrimaryKey(WProductType record);
}