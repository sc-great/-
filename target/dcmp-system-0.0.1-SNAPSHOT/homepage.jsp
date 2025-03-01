<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/common/common_taglib.jsp" %>
<%@ include file="/common/common_css.jsp" %>
<%@ include file="/common/common_js.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"/>
    <title>物联网综合管理平台-后台管理系统</title>
    <link rel="stylesheet" type="text/css" href="${path }/css/admin.css"/>
    <style>
        .layui-nav-itemed > a, .layui-nav-tree .layui-nav-title a, .layui-nav-tree .layui-nav-title a:hover {
            color: #fff !important
            /*color: #f60 !important*/
        }
    </style>
</head>
<body>
<div class="main-layout" id='main-layout'>
    <!--侧边栏-->
    <div class="main-layout-side">
        <ul id="menus" class="layui-nav layui-nav-tree" lay-filter="leftNav">

        </ul>
    </div>
    <!--右侧内容-->
    <div class="main-layout-container">
        <!--头部-->
        <div class="main-layout-header">
        </div>
        <!--主体内容-->
        <div class="main-layout-body" style="top:3px;left:3px;right:3px">
            <!--tab 切换-->
            <div class="main-pagetabs">
                <div class="layui-icon main-tabs-control layui-icon-prev" id="leftPage"></div>
                <div class="layui-icon main-tabs-control layui-icon-pagePrev" id="leftPagePrev"></div>
                <div class="layui-icon main-tabs-control layui-icon-pageNext" id="rightPageNext"></div>
                <div class="layui-icon main-tabs-control layui-icon-next" id="rightPage"></div>
                <div class="layui-tab layui-tab-brief main-layout-tab" lay-allowClose="true" lay-filter="tab">
                    <ul class="layui-tab-title">
                        <li class="layui-this welcome">首&nbsp;页</li>
                    </ul>
                    <div class="layui-tab-content">
                        <div class="layui-tab-item layui-show"
                             style="background: #f5f5f5;">
                            <!-- 							1 -->
                            <iframe src="" width="100%" height="100%" id="myframe"
                                    name="iframe" scrolling="no" class="iframe" framborder="0"></iframe>
                            <!-- 							1end -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${path }/plugin/layui/layui.js" type="text/javascript"
        charset="utf-8"></script>
<script type="text/javascript">
    layui.use(['layer', 'form', 'element', 'jquery'], function () {
        var element = layui.element;
        var $ = layui.jquery;
        var hideBtn = $('#hideBtn');
        var mainLayout = $('#main-layout');
        creatMenu();
        //监听导航点击
        element.on('nav(leftNav)', function (elem) {
            var id = elem.attr('data-id');
            var url = elem.attr('data-url');
            var text = elem.attr('data-text');
            if (!url) {
                return;
            }
            var isActive = $('.main-layout-tab .layui-tab-title').find("li[lay-id=" + id + "]");
            if (isActive.length > 0) {
                //切换到选项卡
                element.tabChange('tab', id);
            } else {
                element.tabAdd('tab', {
                    title: text,
                    content: '<iframe src="' + url + '" name="iframe' + id + '" class="iframe" framborder="0" data-id="' + id + '" scrolling="no" width="100%"  height="100%"></iframe>',
                    id: id
                });
                element.tabChange('tab', id);

            }
            mainLayout.removeClass('hide-side');
        });
        //监听导航点击
        element.on('nav(rightNav)', function (elem) {
            var id = elem.attr('data-id');
            var url = elem.attr('data-url');
            var text = elem.attr('data-text');
            layer.open({
                type: 2,
                title: text,
                area: ['1000px', '500px'],
                fixed: false, //不固定
                maxmin: false,
                shade: [0],
                anim: 5,
                isOutAnim: true,
                resize: false,
                content: url,

            });
            /* if (!url) {
                return;
            }
            var isActive = $('.main-layout-tab .layui-tab-title').find("li[lay-id=" + id + "]");
            if (isActive.length > 0) {
                //切换到选项卡
                element.tabChange('tab', id);
            } else {
                element.tabAdd('tab', {
                    title : text,
                    content : '<iframe src="' + url + '" name="iframe' + id + '" class="iframe" framborder="0" data-id="' + id + '" scrolling="no" width="100%"  height="100%"></iframe>',
                    id : id
                });
                element.tabChange('tab', id);

            }
            mainLayout.removeClass('hide-side'); */
        });
        //菜单隐藏显示
        hideBtn.on('click', function () {
            if (!mainLayout.hasClass('hide-side')) {
                mainLayout.addClass('hide-side');
                $("#menu-button").attr("class", "layui-icon layui-icon-spread-left");
            } else {
                mainLayout.removeClass('hide-side');
                $("#menu-button").attr("class", "layui-icon layui-icon-shrink-right");
            }
        });
        $("#loginOut").on('click', function () {
            $.ajax({
                url: '${path }/sys/loginOut.do',
                method: 'post',
                data: {},
                dataType: 'JSON',
                success: function (res) {
                    if (res.success) {
                        window.location.href = "login.jsp";
                    }
                },
                error: function (data) {
                    layer.alert("服务器异常！");
                }
            })
        });

        function creatMenu() {
            $.ajax({
                url: '${path }/user/getUsermenuByToken.do',
                method: 'post',
                data: {token: '${param.token}'},
                dataType: 'JSON',
                success: function (data) {
                    var parentMenu = [];
                    var childMenu = [];
                    $(data).each(function (index, element) {
                        if (this.parentMenu == null) {
                            parentMenu.push(this);
                        } else {
                            childMenu.push(this);
                        }
                    });
                    $(parentMenu).each(function (index, element) {
                        var parent = "<li class='layui-nav-item'><a href='javascript:;'><i class='iconfont'>" + this.menuIcon + "</i>" + this.menuName + "<i id='layui-down' class='layui-icon layui-icon-down'></i></a><dl class='layui-nav-child' id='" + this.menuId + "'></dl></li>";
                        $("#menus").append(parent);
                    });
                    $(childMenu).each(function (index, element) {
                        var child = "<dd><a href='javascript:;' data-url='" + this.menuUrl + "' data-id='" + this.menuId + "' data-text='" + this.menuName + "'><span class='menu-left'></span>" + this.menuName + "</a></dd>";
                        //var child = "<dd><a href='javascript:;' data-url='"+this.menuUrl+"' data-id='"+this.menuId+"' data-text='"+this.menuName+"'><span class=' iconfont menu-left'>"+  "<image width='20px' height='50%' src='" + this.menuIcon + "'/>"  +"</span>"+this.menuName+"</a></dd>";
                        $("#" + this.parentMenu.menuId).append(child);
                    })
                    element.init();
                    $("li.layui-nav-item").on('click', function () {
                        var chickItem = this;
                        if ($(chickItem).hasClass("layui-nav-itemed")) {
                            $("li.layui-nav-item").each(function () {
                                if (this != chickItem) {
                                    $(this).removeClass("layui-nav-itemed");
                                }
                            });
                        }
                    });

                    //请求成功了再去set iframe的内容${path }/jsp/project/project_index.jsp
                    document.getElementById("myframe").src = "${path }/jsp/project/project_index.jsp";
                },
                error: function (data) {
                    layer.alert("登陆信息失效！");
                }
            })
        }
    });
</script>
</body>
</html>
