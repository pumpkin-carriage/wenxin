package com.wenxin.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName ZheXianTuView
 * @Author Spring
 * @DateTime 2019/2/3 10:26
 */
public class ZheXianTuView<T> {
    private List<T> xData=new ArrayList<>();
    private List<T> yData=new ArrayList<>();

    public List<T> getxData() {
        return xData;
    }

    public void setxData(List<T> xData) {
        this.xData = xData;
    }

    public List<T> getyData() {
        return yData;
    }

    public void setyData(List<T> yData) {
        this.yData = yData;
    }
}
