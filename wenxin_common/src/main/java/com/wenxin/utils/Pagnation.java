package com.wenxin.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName Pagnation
 * @Author Spring
 * @DateTime 2019/2/3 13:49
 */
public class Pagnation<T> {
    private Integer pageNo;
    private Integer pageSize;
    private Integer totalCount;
    private Integer totalPage;
    private List<T> data=new ArrayList<>();

    public Pagnation(Integer pageNo, Integer pageSize, Integer totalCount) {
        this.totalCount=totalCount;
        this.pageSize=pageSize;
        this.totalPage=(int)Math.ceil((double)totalCount/pageSize);
        this.pageNo = pageNo;
        if (pageNo<=1){
            this.pageNo=1;
        }else if(pageNo>=totalPage){
            this.pageNo=totalPage;
        }
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPage = totalPage;
    }

    public Integer getPageNo() {
        return pageNo;
    }

    public void setPageNo(Integer pageNo) {
        this.pageNo = pageNo;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Integer totalCount) {
        this.totalCount = totalCount;
    }

    public Integer getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(Integer totalPage) {
        this.totalPage = totalPage;
    }

    public List<T> getData() {
        return data;
    }

    public void setData(List<T> data) {
        this.data = data;
    }
    public Integer getBegin(){
        return (pageNo-1)*pageSize;
    }
}
