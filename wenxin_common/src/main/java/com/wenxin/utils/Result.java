package com.wenxin.utils;

/**
 * @ClassName Result
 * @Author Spring
 * @DateTime 2019/2/2 11:31
 */
public class Result<T> {
    private Long code;
    private String msg;
    private T data=null;

    public Long getCode() {
        return code;
    }

    public void setCode(Long code) {
        this.code = code;
    }


    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    private Result(){}
    private static Result result=new Result();
    public static <T> Result success(T data){
        result.setCode(StateConst.RESULT_SUCCESS);
        result.setMsg("成功");
        result.setData(data);
        return result;
    }
    public static Result failure(String msg){
        result.setMsg(msg);
        result.setCode(StateConst.RESULT_FAILURE);
        result.setData(null);
        return result;
    }
}
