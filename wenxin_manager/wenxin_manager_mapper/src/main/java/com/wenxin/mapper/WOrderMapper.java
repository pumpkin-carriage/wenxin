package com.wenxin.mapper;

import com.wenxin.pojo.WOrder;
import com.wenxin.pojo.WOrderExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WOrderMapper {
    int countByExample(WOrderExample example);

    int deleteByExample(WOrderExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WOrder record);

    int insertSelective(WOrder record);

    List<WOrder> selectByExample(WOrderExample example);

    WOrder selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WOrder record, @Param("example") WOrderExample example);

    int updateByExample(@Param("record") WOrder record, @Param("example") WOrderExample example);

    int updateByPrimaryKeySelective(WOrder record);

    int updateByPrimaryKey(WOrder record);

    List<WOrder> selectInfo(@Param("start") Integer start,@Param("pageSize") Integer pageSize);

    void updateStateBatch(@Param("list") List<WOrder> orders);

    List<WOrder> selectByTime(@Param("createTime") String createTime);
}