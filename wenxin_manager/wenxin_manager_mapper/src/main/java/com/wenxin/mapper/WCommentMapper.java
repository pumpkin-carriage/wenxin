package com.wenxin.mapper;

import com.wenxin.pojo.WComment;
import com.wenxin.pojo.WCommentExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface WCommentMapper {
    int countByExample(WCommentExample example);

    int deleteByExample(WCommentExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(WComment record);

    int insertSelective(WComment record);

    List<WComment> selectByExample(WCommentExample example);

    WComment selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") WComment record, @Param("example") WCommentExample example);

    int updateByExample(@Param("record") WComment record, @Param("example") WCommentExample example);

    int updateByPrimaryKeySelective(WComment record);

    int updateByPrimaryKey(WComment record);
}