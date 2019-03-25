package com.wenxin.mapper;

import com.wenxin.pojo.WProduct;
import com.wenxin.pojo.WProductExample;
import com.wenxin.pojo.WUser;
import com.wenxin.utils.BingTuView;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WProductMapper {
    int countByExample(WProductExample example);

    int deleteByExample(WProductExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WProduct record);

    int insertSelective(WProduct record);

    List<WProduct> selectByExample(WProductExample example);

    WProduct selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WProduct record, @Param("example") WProductExample example);

    int updateByExample(@Param("record") WProduct record, @Param("example") WProductExample example);

    int updateByPrimaryKeySelective(WProduct record);

    int updateByPrimaryKey(WProduct record);

    List<BingTuView> selectInfo();

    List<WProduct> selectPage(@Param("start") Integer start, @Param("pageSize") Integer pageSize);

    void updateStateBatch(@Param("list") List<WProduct> products);
}