package com.wenxin.mapper;

import com.wenxin.pojo.WOrderInfo;
import com.wenxin.pojo.WOrderInfoExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WOrderInfoMapper {
    int countByExample(WOrderInfoExample example);

    int deleteByExample(WOrderInfoExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WOrderInfo record);

    int insertSelective(WOrderInfo record);

    List<WOrderInfo> selectByExample(WOrderInfoExample example);

    WOrderInfo selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WOrderInfo record, @Param("example") WOrderInfoExample example);

    int updateByExample(@Param("record") WOrderInfo record, @Param("example") WOrderInfoExample example);

    int updateByPrimaryKeySelective(WOrderInfo record);

    int updateByPrimaryKey(WOrderInfo record);
}