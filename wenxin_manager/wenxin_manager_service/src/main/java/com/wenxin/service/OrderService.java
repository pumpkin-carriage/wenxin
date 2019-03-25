package com.wenxin.service;

import com.wenxin.pojo.WOrder;
import com.wenxin.utils.Pagnation;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

public interface OrderService {
    void print(String time, HttpServletResponse response, HttpServletRequest request) throws IOException;

    Pagnation<WOrder> getOrderPage(Integer page, Integer limit);

    boolean deleteByIds(List<Integer> toIntegerList);

}
