<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/3
  Time: 11:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>已完成订单打印</title>
    <link rel="stylesheet" href="../../../static/layui/css/layui.css" media="all">
    <script type="text/javascript" src="../../../static/js/jquery.min.js"></script>
</head>
<body>

<div class="layui-inline">
    <input type="text" aria-invalid="date" class="layui-input" id="date">
</div>
<button id="print" class="layui-btn">打印</button>
<script src="../../../static/layui/layui.js"></script>
<script>
    layui.use('laydate', function(){
        var laydate = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#date', //指定元素
            type:'month',
            value:'2019-01',
            min:'2016-01-01',
            max:'2099-12-31',
        });
    });
    $(function () {
        $("#print").click(function () {
            window.location.href="/admin/order/print?time="+$("#date").val()
        });
    })
</script>
</body>
</html>