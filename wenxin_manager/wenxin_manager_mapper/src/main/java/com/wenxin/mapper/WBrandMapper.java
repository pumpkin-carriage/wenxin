package com.wenxin.mapper;

import com.wenxin.pojo.WBrand;
import com.wenxin.pojo.WBrandExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface WBrandMapper {
    int countByExample(WBrandExample example);

    int deleteByExample(WBrandExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WBrand record);

    int insertSelective(WBrand record);

    List<WBrand> selectByExample(WBrandExample example);

    WBrand selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WBrand record, @Param("example") WBrandExample example);

    int updateByExample(@Param("record") WBrand record, @Param("example") WBrandExample example);

    int updateByPrimaryKeySelective(WBrand record);

    int updateByPrimaryKey(WBrand record);

    List<WBrand> selectPage(@Param("start") Integer start,@Param("pageSize") Integer pageSize,@Param("keyword")String keyword);
}