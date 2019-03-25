package com.wenxin.util;

import com.wenxin.pojo.WCart;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName CartUtil
 * @Author Spring
 * @DateTime 2019/2/9 22:08
 */
public class CartUtil {
    private Integer totalCount=0;
    private Long totalAmount=0L;
    List<WCart> list=new ArrayList<>();

    public Long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Integer getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Integer totalCount) {
        this.totalCount = totalCount;
    }

    public List<WCart> getList() {
        return list;
    }

    public void setList(List<WCart> list) {
        this.list = list;
    }
}
