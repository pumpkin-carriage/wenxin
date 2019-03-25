package com.wenxin.service;

import com.wenxin.pojo.WProduct;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

public interface WProductService {
    List<WProduct> getListById(Integer id);

    WProduct getById(Integer id, HttpServletResponse response, HttpServletRequest request, Model model);

    List<WProduct> getListByKeyword(String keyword);

    List<WProduct> getMyProduct(Integer id);

    void updateOff(Integer id);

    void updateDel(Integer id);

    void add(WProduct product, HttpSession session);
}
