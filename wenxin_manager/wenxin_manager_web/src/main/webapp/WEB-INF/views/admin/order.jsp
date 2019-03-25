<%@ taglib prefix="v" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/8
  Time: 9:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>订单管理</title>
    <link rel="stylesheet" type="text/css" href="../../../static/layui/css/layui.css"/>
    <script type="text/javascript" src="../../../static/js/vue.js"></script>
    <script type="text/javascript" src="../../../static/js/axios.min.js"></script>
    <script type="text/javascript" src="../../../static/layui/layui.js"></script>
    <script type="text/javascript" src="../../../static/js/jquery.min.js"></script>
    <script type="text/javascript" src="../../../static/js/dateformat.js"></script>
</head>
<body>
<div id="app" style="padding: 20px; background-color: #F2F2F2;">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md16">
            <div class="layui-card">
                <div class="layui-card-header">
                    <div class="layui-btn-group">
                        <button id="del" class="layui-btn layui-bg-red">删除</button>
                    </div>
                </div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <tr class="layui-tab-title">
                            <th><input type="checkbox" id="all"/></th>
                            <th style="text-align: center;">序号</th>
                            <th style="text-align: center;">订单号</th>
                            <th style="text-align: center;">创建人</th>
                            <th style="text-align: center;">创建时间</th>
                            <th style="text-align: center;">订单状态</th>
                        </tr>
                        <v:forEach items="${orderPage.data}" var="order" varStatus="index">
                            <tr class="layui-tab-content" style="text-align: center">
                                <td style="text-align: left">
                                    <input type="hidden" value="${index.count}">
                                    <input type="checkbox" class="one"/>
                                    <input type="hidden" value="${order.id}">
                                    <input type="hidden" value="${order.state}">
                                </td>
                                <td>${index.count}</td>
                                <td>${order.no}</td>
                                <td>${order.username}</td>
                                <td class="date">${order.createTime}</td>
                                <td class="state">${order.state}</td>
                            </tr>
                        </v:forEach>
                    </table>
                    <input type="hidden" id="pageNo" value="${orderPage.pageNo}"/>
                    <input type="hidden" id="pageSize" value="${orderPage.pageSize}"/>
                    <input type="hidden" id="totalCount" value="${orderPage.totalCount}"/>
                    <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
    $(function () {
     $("tr").attr("bgColor","cc0085").css("color","white").mouseover(function () {
            $(this).css("backgroundColor","cc0085")
        });
        $($("tr")[0]).attr("bgColor","green").css("color","white").mouseover(function () {
            $(this).css("backgroundColor","green")
        });
        var ids=[];
        var indexs=[];
        layui.use('laypage', function () {
            var laypage = layui.laypage;
            //执行一个laypage实例
            laypage.render({
                elem: 'page',//注意，这里的 test1 是 ID，不用加 # 号
                count: $("#totalCount").val(), //数据总数，从服务端得到,
                curr:$("#pageNo").val(),
                limit: 6,
                jump: function (obj, first) {
                    if (!first) {
                        window.location.href="/admin/order/orderPage?page="+obj.curr+"&limit=6";
                    }
                }
            });
        });
        layui.use('layer', function(){
            var layer = layui.layer;
        });
            for (var i = 0; i < $(".date").length; i++) {
                $($(".date")[i]).html(Todate($($(".date")[i]).html()));
            }
        for (var i = 0; i < $(".state").length; i++) {
            var state=$($(".state")[i]);
            var content=$($(".layui-tab-content")[i]);
            switch (state.html()) {
                case "0":
                    state.html("已预约");
                    break;
                case "1":
                    state.html("预约成功");
                    break;
                case "3":
                    state.html("已取消");
                    break;
                case "2":
                case "4":
                    state.html("已完成");
                    break;
                case "5":
                    state.html("待预约");
                    break;
            }
        }
        $("#all").change(function () {
            if ($(this).prop("checked") == true) {
                ids = [];
                indexs=[];
                for (var i = 0; i < $(".one").length; i++) {
                    $($(".one")[i]).prop("checked", true)
                    ids.push($($(".one")[i]).next().val())
                    indexs.push($($(".one")[i]).prev().val())
                }
            } else {
                ids = [];
                indexs=[];
                for (var i = 0; i < $(".one").length; i++) {
                    $($(".one")[i]).prop("checked", false)
                }
            }
        })
        $(".one").change(function () {
            if ($(this).prop("checked") == true) {
                ids.push($(this).next().val())
                indexs.push($(this).prev().val())
            }
            else {
                var v = $(this).next().val();
                var index = ids.indexOf(v);
                ids.splice(index, 1);

                v = $(this).prev().val();
                index = indexs.indexOf(v);
                indexs.splice(index, 1);
            }
            if (ids.length == $(".one").length) {
                $("#all").prop("checked", true)
            }
            else {
                $("#all").prop("checked", false)
            }
        })
        $("#del").click(function () {
            if(ids.length==0){
                layer.msg("请选择要删除的订单",{
                    time:1200,
                })
                return;
            }
            for (var i=0;i<indexs.length;i++) {
                var v=indexs[i]-1;
                var one=$($(".one")[v]);
                if(one.next().next().val()!=2&&one.next().next().val()!=4){
                    layer.msg("不能删除未完成的订单")
                    return;
                }
            }
            if (confirm("确认删除？")){
                var load=layer.load();
                axios({
                    url:"/admin/order/delete",
                    method:"delete",
                    data:ids,
                }).then(resp=>{
                    if(resp.data.code===1){
                        layer.close(load);
                        window.location.href="/admin/order/orderPage?page="+$("#pageNo").val()+"&limit=6";
                        layer.msg("删除成功",{
                            time:1000,
                        })
                    }
                    else{
                        layer.msg("删除失败",{
                            time:1000,
                        })
                    }
                })
            }
        });
    })
</script>
</html>
