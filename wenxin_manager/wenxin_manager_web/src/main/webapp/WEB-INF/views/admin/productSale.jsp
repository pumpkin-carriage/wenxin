<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/3
  Time: 12:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品销售排名</title>
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
            url:"/admin/statis/productSale",
            method:"get",
        }).then(resp=>{
            var option = {
                title : {
                    text: '商品销售排名',
                    subtext: '真实有效',
                    x:'center'
                },
                legend: {
                    x : 'center',
                    y : 'bottom',
                    data:resp.data
                },
                toolbox: {
                    show : true,
                    feature : {
                        mark : {show: true},
                        dataView : {show: true, readOnly: false},
                        magicType : {
                            show: true,
                            type: ['pie', 'funnel']
                        },
                        restore : {show: true},
                        saveAsImage : {show: true}
                    }
                },
                calculable : true,
                series: [
                    {
                        name:'销售排名',
                        type:'pie',
                        radius : [20, 160],
                        center : ['25%', '50%'],
                        roseType : 'radius',
                        label: {
                            normal: {
                                show: false
                            },
                            emphasis: {
                                show: true
                            }
                        },
                        lableLine: {
                            normal: {
                                show: false
                            },
                            emphasis: {
                                show: true
                            }
                        },
                        data:resp.data,
                    },
                    {
                        name:'商品销售排名',
                        type:'pie',
                        radius : [20, 160],
                        center : ['75%', '50%'],
                        roseType : 'area',
                        data:resp.data,
                    }
                    ]
            };

            mychart.setOption(option);
            window.onresize = mychart.resize;
        })
    }
</script>
</html>
