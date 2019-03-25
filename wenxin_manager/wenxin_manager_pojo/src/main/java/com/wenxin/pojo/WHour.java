package com.wenxin.pojo;

import java.io.Serializable;

public class WHour implements Serializable {
    private Integer id;

    private String hour;

    private static final long serialVersionUID = 1L;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getHour() {
        return hour;
    }

    public void setHour(String hour) {
        this.hour = hour == null ? null : hour.trim();
    }
}