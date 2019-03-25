package com.wenxin.utils;

/**
 * @ClassName SimpleZtree
 * @Author Spring
 * @DateTime 2019/2/6 10:00
 */
public class SimpleZtree {
    private Integer id;
    private Integer pId;
    private String name;
    private boolean open=true;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getpId() {
        return pId;
    }

    public void setpId(Integer pId) {
        this.pId = pId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isOpen() {
        return open;
    }

    public void setOpen(boolean open) {
        this.open = open;
    }
}
