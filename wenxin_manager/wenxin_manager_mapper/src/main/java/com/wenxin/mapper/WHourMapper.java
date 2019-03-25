package com.wenxin.mapper;

import com.wenxin.pojo.WHour;
import com.wenxin.pojo.WHourExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WHourMapper {
    int countByExample(WHourExample example);

    int deleteByExample(WHourExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WHour record);

    int insertSelective(WHour record);

    List<WHour> selectByExample(WHourExample example);

    WHour selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WHour record, @Param("example") WHourExample example);

    int updateByExample(@Param("record") WHour record, @Param("example") WHourExample example);

    int updateByPrimaryKeySelective(WHour record);

    int updateByPrimaryKey(WHour record);
}