<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Spring
  Date: 2019/2/3
  Time: 13:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户信息</title>
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
                        <button id="add" class="layui-btn">增加</button>
                        <button id="edit" class="layui-btn layui-bg-blue">编辑</button>
                        <button id="del" class="layui-btn layui-bg-red">删除</button>
                    </div>
                        <input type="text" id="username" name="keyword"  autocomplete="off" placeholder="请输入用户名" style="width: 120px;height: 35px;border-radius: 2px">
                        <i id="search" class="layui-icon layui-icon-search" style="cursor:pointer;font-size: 20px; color: #1E9FFF;" title="搜索"></i>
                </div>
                <div class="layui-card-body">
                   <table class="layui-table">
                       <tr class="layui-tab-title">
                           <th><input type="checkbox" id="all"/></th>
                           <th style="text-align: center;">序号</th>
                           <th style="text-align: center;">用户名</th>
                           <th style="text-align: center;">真实姓名</th>
                           <th style="text-align: center;">邮箱</th>
                           <th style="text-align: center;">电话号码</th>
                           <th style="text-align: center;">创建时间</th>
                       </tr>
                       <c:forEach items="${userList.data}" var="user" varStatus="index">
                           <tr class="layui-tab-content" style="text-align: center">
                               <td style="text-align: left">
                                   <input type="checkbox" class="one" />
                                   <input type="hidden" value="${user.id}" />
                               </td>
                               <td>${index.count}</td>
                               <td>${user.userName}</td>
                               <td>${user.name}</td>
                               <td>${user.email}</td>
                               <td>${user.phone}</td>
                               <td class="date">${user.createTime}</td>
                           </tr>
                       </c:forEach>
                   </table>
                    <input type="hidden" id="count" value="${userList.totalCount}"/>
                    <input type="hidden" id="pageNo" value="${userList.pageNo}"/>
                    <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="editModal" style="display: none">
        <form class="layui-form" action="/admin/user/updateUserForm" method="post">
            <div class="layui-form-item">
                <input type="hidden" id="id_e" name="id"/>
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" readonly id="userName_e" name="userName" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="password" id="password_e" name="password" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">真实姓名</label>
                <div class="layui-input-block">
                    <input type="text" id="name_e" name="name" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block">
                    <input type="email" id="email_e" name="email" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">电话</label>
                <div class="layui-input-block">
                    <input type="tel" id="phone_e" name="phone" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
            </div>
            <button type="submit" class="layui-btn layui-btn-fluid">提交修改</button>
        </form>
    </div>
    <div id="addModal" style="display: none;">
        <form class="layui-form" action="/admin/user/addForm" method="post">
            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="text"   name="password" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">真实姓名</label>
                <div class="layui-input-block">
                    <input type="text"  name="name" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block">
                    <input type="email"  name="email" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
                <label class="layui-form-label">电话</label>
                <div class="layui-input-block">
                    <input type="tel"  name="phone" autocomplete="off"  class="layui-input" style="width: 200px">
                </div>
            </div>
            <button type="submit" class="layui-btn layui-btn-fluid">添加</button>
        </form>
    </div>
</div>
</body>
<script type="text/javascript">
    layui.use('laypage', function(){
        var laypage = layui.laypage;

        //执行一个laypage实例
        laypage.render({
            elem: 'page',
            count: $("#count").val(),
            limit:6,
            curr:$("#pageNo").val(),
            hash:true,
            jump: function(obj, first){
                if(!first){
                    window.location.href="/admin/main/user?page="+obj.curr+"&limit="+obj.limit;
                }
            }
        });
    });
    $(function () {
        $("tr").attr("bgColor","cc0085").css("color","white").mouseover(function () {
            $(this).css("backgroundColor","cc0085")
        });
        $($("tr")[0]).attr("bgColor","green").css("color","white").mouseover(function () {
            $(this).css("backgroundColor","green")
        });
        layui.use('layer', function(){
            var layer = layui.layer;
        });
        var ids=[];
        $("#search").click(function () {
            if ($("#username").val()!=""){
                window.location.href="/admin/main/user?page=1&limit=1&keyword="+$("#username").val();
            }
        })
        for (var i=0;i<$(".date").length;i++){
            if ($($(".date")[i]).html()!=""){
                var d=Todate($($(".date")[i]).html());
                $($(".date")[i]).html(d)
            }
        }
        $("#all").change(function () {
            if ($(this).prop("checked")==true){
                ids=[];
               for (var i=0;i<$(".one").length;i++){
                   $($(".one")[i]).prop("checked",true)
                   ids.push($($(".one")[i]).next().val())
               }
            }else{
                ids=[];
                for (var i=0;i<$(".one").length;i++){
                    $($(".one")[i]).prop("checked",false)
                }
            }
        })
        $(".one").change(function () {
            if($(this).prop("checked")==true){
               ids.push($(this).next().val())
            }
            else{
                var v=$(this).next().val();
                var index=ids.indexOf(v);
                ids.splice(index,1);
            }
            if(ids.length==$(".one").length){
                $("#all").prop("checked",true)
            }
            else{
                $("#all").prop("checked",false)
            }
        })
        $("#del").click(function () {
            if (ids.length==0){
                layer.msg('请选择要删除的用户',{
                    time: 1000
                });
            }
            else{
                layer.confirm("确认要删除？",function () {
                    axios({
                        url:"/admin/user/delete",
                        method:"delete",
                        data:ids
                    }).then(resp=>{
                        if (resp.data.code===1){
                            layer.msg('删除成功',{
                                time: 200
                            });
                           setTimeout(function () {
                               window.location.href="/admin/main/user?page="+$("#pageNo").val()+"&limit=6"
                           },200)
                        }
                    })
                })
            }
        })
        $("#edit").click(function () {
            if (ids.length==0){
                layer.msg('请选择要编辑的用户',{
                    time: 1000
                });
            }
            else if(ids.length>1){
                layer.msg('选择的用户过多',{
                    time: 1000
                });
            }
            else{
                for (var i=0;i<$(".one").length;i++){
                    if($($(".one")[i]).next().val()==ids[0]){
                        $("#id_e").val($($(".one")[i]).next().val());
                        $("#password_e").val("");
                        $("#userName_e").val($($(".one")[i]).parent().next().next().html());
                        $("#name_e").val($($(".one")[i]).parent().next().next().next().html());
                        $("#email_e").val($($(".one")[i]).parent().next().next().next().next().html());
                        $("#phone_e").val($($(".one")[i]).parent().next().next().next().next().next().html());
                    }
                }
                layer.open({
                    type:1,//类型
                    area:['400px','286px'],//定义宽和高
                    title:'修改用户',//题目
                    shadeClose:false,//点击遮罩层关闭
                    content: $("#editModal")//打开的内容
                });
            }
        })
        $("#add").click(function () {
            layer.open({
                type:1,//类型
                area:['400px','248px'],//定义宽和高
                title:'添加用户',//题目
                shadeClose:false,//点击遮罩层关闭
                content: $("#addModal")//打开的内容
            });
        })
    })
</script>
</html>