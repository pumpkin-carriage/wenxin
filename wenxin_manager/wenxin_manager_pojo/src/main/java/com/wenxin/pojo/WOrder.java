package com.wenxin.pojo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class WOrder implements Serializable {
    private Integer id;

    private Integer userId;

    private String no;

    private Long totalMoney;

    private Integer state;

    private Date payTime;

    private Date createTime;

    private Date updateTime;

    private String username;

    private List<WOrderInfo> orderInfoList=new ArrayList<>();
    private static final long serialVersionUID = 1L;

    public List<WOrderInfo> getOrderInfoList() {
        return orderInfoList;
    }

    public void setOrderInfoList(List<WOrderInfo> orderInfoList) {
        this.orderInfoList = orderInfoList;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no == null ? null : no.trim();
    }

    public Long getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(Long totalMoney) {
        this.totalMoney = totalMoney;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public Date getPayTime() {
        return payTime;
    }

    public void setPayTime(Date payTime) {
        this.payTime = payTime;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}