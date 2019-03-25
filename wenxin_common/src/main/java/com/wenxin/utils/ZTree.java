package com.wenxin.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName ZTree
 * @Author Spring
 * @DateTime 2019/2/4 14:58
 */
public class ZTree {
    private Integer id;
    private Integer pId;
    private String name;
    private String iconOpen;
    private String iconClose;
    private String icon;
    private boolean open;
    private List<ZTree> children;

    public String getIconOpen() {
        return iconOpen;
    }

    public void setIconOpen(String iconOpen) {
        this.iconOpen = iconOpen;
    }

    public boolean isOpen() {
        return open;
    }

    public void setOpen(boolean open) {
        this.open = open;
    }

    public String getIconClose() {
        return iconClose;
    }

    public void setIconClose(String iconClose) {
        this.iconClose = iconClose;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

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

    public List<ZTree> getChildren() {
        return children;
    }

    public void setChildren(List<ZTree> children) {
        this.children = children;
    }
}
