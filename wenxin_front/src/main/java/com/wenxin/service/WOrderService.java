package com.wenxin.service;

import com.wenxin.pojo.WComment;
import com.wenxin.pojo.WOrder;
import com.wenxin.pojo.WOrderExt;

import javax.servlet.http.HttpSession;
import java.util.List;

public interface WOrderService {
    Integer addOrder(Integer id, String[] ids);

    WOrder getOrder(Integer id);

    List<String> addExt(WOrderExt orderExt, HttpSession session);

    List<WOrder> selectMyOrder(Integer id);

    void updateState(Integer id,Integer state);

    void DeleteById(Integer id);

    void addComment(WComment comment);
}
