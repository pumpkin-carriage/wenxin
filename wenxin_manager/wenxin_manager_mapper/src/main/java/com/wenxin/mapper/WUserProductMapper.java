package com.wenxin.mapper;

import com.wenxin.pojo.WUserProduct;
import com.wenxin.pojo.WUserProductExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WUserProductMapper {
    int countByExample(WUserProductExample example);

    int deleteByExample(WUserProductExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WUserProduct record);

    int insertSelective(WUserProduct record);

    List<WUserProduct> selectByExample(WUserProductExample example);

    WUserProduct selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WUserProduct record, @Param("example") WUserProductExample example);

    int updateByExample(@Param("record") WUserProduct record, @Param("example") WUserProductExample example);

    int updateByPrimaryKeySelective(WUserProduct record);

    int updateByPrimaryKey(WUserProduct record);
}