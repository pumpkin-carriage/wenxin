<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/3
  Time: 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>系统访问压力</title>
    <script type="text/javascript" src="../../../static/js/echarts.min.js"></script>
    <script type="text/javascript" src="../../../static/js/axios.min.js"></script>
</head>
<body>
<div id="echart" style="width: 100%;height:400px;"></div>
</body>
<script type="text/javascript">
    window.onload=function () {
        var mychart=echarts.init(document.getElementById("echart"));
        axios({
            url:"/admin/statis/accessPressure",
            method:"get",
        }).then(resp=>{
            var option = {
                xAxis: {
                    name:'时间',
                    data:resp.data.xData,
                },
                yAxis: {
                    name:'访问量',
                },
                series: [{
                    data: resp.data.yData,
                    type: 'line',
                    smooth: true
                }]
            };
            mychart.setOption(option);
            window.onresize = mychart.resize;
        })
    }
</script>
</html>
