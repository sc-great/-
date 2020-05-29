<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/common/common_taglib.jsp" %>
<%@ include file="/common/common_css.jsp" %>
<%@ include file="/common/common_js.jsp" %>
<!DOCTYPE html>
<html class="iframe-h">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="${path }/css/list.css"/>
    <link rel="stylesheet" type="text/css" href="${path }/css/admin.css"/>
</head>
<body>
<div class="serch-bar">
    <div class="search-input">
           防区名称：
        <div class="layui-inline layui-search-input">
            <input name="name" class="layui-input" id="name"
                   autocomplete="off">
        </div>
           状态：
        <div class="layui-inline layui-search-input">
            <select name="status" id="status"   class="layui-select">
                        <option value="0" >启用</option>
                        <option value="1" >停用</option>
                         <option value="" selected="selected">全部</option>
                        </select>
        </div>
       
        
        <button class="layui-btn layui-btn-orange layui-btn-search" data-type="reload">搜索</button>
    </div>
    <span class="layui-toolbar">
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="add"><div
                    class="layui-btn-toolbar-add"></div>添加</button>
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="userNormal"><div
                    class="layui-btn-toolbar-up"></div>启用</button>
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="userUnuser"><div
                    class="layui-btn-toolbar-stop"></div>停用</button>
			<button class="layui-btn layui-btn-primary layui-btn-tool-add" data-type="delALL"><div
                    class="layui-btn-toolbar-del"></div>删除</button>
		</span>
</div>

<!-- <table id="role" lay-filter="roleList"></table> -->
<table id="sarea" lay-filter="sareaList"></table>

<script id="toolBar" type="text/html">
    <a class="layui-btn layui-btn-primary layui-btn-tool-check" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-primary layui-btn-tool-edit" lay-event="edit">修改</a> 
    <a class="layui-btn layui-btn-xs" lay-event="addMenu">视频联动</a>
</script>

<!-- 用户状态数据格式化 -->
<script type="text/html" id="pstatus">
    {{ statusFormat(d.status) }}   
</script>

<!--主机名称格式化 -->
<script type="text/html" id="host">
    {{ creaetHost(d.host) }}
</script>
<!--主机编号格式化 -->

<script src="${path }/plugin/layui/layui.js" type="text/javascript"
        charset="utf-8"></script>
<script type="text/javascript">
    layui.use(['table', 'laydate', 'form', 'jquery'], function () {
        var table = layui.table;
        var form = layui.form;
        var layerIndex;
        var layerInitWidth;
        var layerInitHeight;
        var $ = layui.jquery;
        
        var currpage = $('.layui-laypage-skip').children('.layui-input').val();
        var laydate = layui.laydate;
       
        $(window).resize(function () {
            resizeLayer($, layerIndex, layerInitWidth, layerInitHeight);
        });
        //查询条件开始时间实发始化
      
        //日期范围
      
        //表格数据初始化
        table.render({
            elem: '#sarea',
            height: 'full-120',
            url: '${path}/sarea/getPage.do',          
            cellMinWidth: 80,
            
            cols: [[ //标题栏
                {
                    type: 'checkbox',
                    LAY_CHECKED: false
                }, {
                    field: 'name',
                    title: '防区名称'
                  //  templet:function(d){
                  //   return '<div style="text-align:center">'+d.name+'</div>'
                  //  }
                }, {
                    field: 'host',
                    title: '主机名称',  
                    templet: '#host'                      
 
                }, {
                    field: 'createTime',
                    title: '创建时间',
                    templet:function (d) {
					 if(d.createTime==""){
							return '<a style="color:#ed2a4a" >-</a>';
						}else{
							return  dateFormat(d.createTime,'yMdhms');
						}
					 }      
                                 
                }, {
                    field: 'status',
                    title: '状态',
                   	templet:function (d) {
					  if(d.status==0){
							return '<a style="color:#00A600" >启动</a>';
						}else if(d.status==1){
							return '<a style="color:#ed2a4a" >停用</a>';
						}
					  }                  
                           
                }, {

                    field: '',
                    title: ''                    
                                                      
                }, {
                    fixed: 'right',
                    title: '操作',
                    toolbar: '#toolBar',
                    width: 320
                }]],
            skin: 'line', //line row表格风格
            even: true, //,size: 'lg' //尺寸
            page: true, //是否显示分页,           
            limits: [10, 15],
            limit: 10
        });
        //监听工具条
        table.on('tool(sareaList)', function (obj) {
            var data = obj.data;
            if (obj.event === 'detail') {
                top.layer.open({
                    type: 2,
                    title: '查看',
                    area: ['600px', '430px'],
                    fixed: false, //不固定
                    maxmin: false,
                    shade: [0.3],
                    anim: 5,
                    isOutAnim: true,
                    resize: false,
                    content: '${path}/jsp/sarea/sarea_display.jsp?areaId=' + data.areaId,
                    end: function () {
// 							active.reload();
                        table.reload('sarea', {page: {curr: currpage}});
                    }
                });
            } else if (obj.event === 'edit') {
                top.layer.open({
                    type: 2,
                    title: '信息修改',
                    area: ['600px', '350px'],
                    fixed: false, //不固定
                    maxmin: false,
                    shade: [0.3],
                    anim: 5,
                    isOutAnim: true,
                    resize: false,
                    content: '${path}/jsp/sarea/sarea_update.jsp?areaId=' + data.areaId,
                    end: function () {
                        table.reload('sarea', {page: {curr: currpage}});
                    }
                });
            } else if (obj.event === "addMenu") {  //改为视频联动 ,暂未改
               top.layer.open({
                    type: 2,
                    title: '视频联动',
                    area: ['1160px', '800px'],
                    fixed: false, //不固定
                    maxmin: false,
                    shade: [0.3],
                    anim: 5,
                    isOutAnim: true,
                    resize: false,
                    content: '${path}/jsp/smovlink/smovlink_update.jsp?areaId=' + data.areaId,
                    end: function () {
                        table.reload('sarea', {page: {curr: currpage}});
                    }
                });
               
               
               
            } else if (obj.event === 'del') {
                let id = [data.areaId];
                //console.log(id);
                top.layer.confirm('确定要删除选中的数据吗？', {
                    btn: ['确定', '取消']
                }, function () {
                    var actionUrl = "${path}/sarea/del.do";
                    var params = {
                        ids: id
                    };
                    $.post(actionUrl, params, function (data) {
                        if (data.success) {
                            top.layer.alert('删除成功！！');
                            //active.reload();
                            table.reload('role', {page: {curr: currpage}});
                        } else {
                            top.layer.alert(data.msg);
                            return;
                        }
                    });
                });

            }
        });
        var $ = layui.jquery,
            active = {
                //信息添加
                add: function () {
                    top.layer.open({
                        type: 2,
                        title: '添加',
                        area: ['600px', '400px'],
                        fixed: false, //不固定
                        maxmin: false,
                        shade: [0.3],
                        anim: 5,
                        isOutAnim: true,
                        resize: false,
                        content: '${path}/jsp/sarea/sarea_add.jsp',
                        success: function () {
                            $(':focus').blur();
                        },
                        end: function () {
                            active.reload();
                            table.reload('area', {page: {curr: currpage}});
                        }
                    });
                },
                //角色信息批量删除
                delALL: function () {
                    var ids = active.getCheckData();
                    if (ids.length == 0) {
                        top.layer.alert('请选择需要删除的数据！！');
                    } else {
                        top.layer.confirm('确定要删除选中的所有数据吗？', {
                            btn: ['确定', '取消']
                        }, function () {
                            var actionUrl = "${path}/sarea/del.do";
                            var params = {
                                ids: ids
                            };
                            $.post(actionUrl, params, function (data) {
                                if (data.success) {
                                    top.layer.alert('删除成功！！');
                                    active.reload();
                                } else {
                                    top.layer.alert(data.msg);
                                    return;
                                }
                            });
                        });
                    }
                },
                //刷新表格数据重新请求
                reload: function () {
                    //执行重载
                    table.reload('sarea', {
                        page: {
                            curr: 1
                        },
                        //查询条件参数
                        where: {
                            name: $("#name").val(),
                            status: $("#status").val(),                          
                        }
                    });
                },
                //设置用户状态启用
                userNormal: function () {
                    var ids = active.getCheckData();
                    if (ids.length == 0) {
                        top.layer.alert('请选择需要启用的防区！！');
                    } else {
                        top.layer.confirm('确定要启用选中的防区吗？', {
                            btn: ['确定', '取消']
                        }, function () {
                            var actionUrl = "${path}/sarea/changeStatus.do";
                            var params = {
                                ids: ids,
                                status: 0
                            };
                            $.post(actionUrl, params, function (data) {
                                if (data.success) {
                                    top.layer.alert('启用成功！！');
                                    //active.reload();
                                    table.reload('sarea', {page: {curr: currpage}});
                                } else {
                                    top.layer.alert('启用失败！！');
                                    return;
                                }
                            });
                        });
                    }
                },
                //设置用户状态停用
                userUnuser: function () {
                    var ids = active.getCheckData();
                    if (ids.length == 0) {
                        top.layer.alert('请选择需要停用的防区！');
                    } else {
                        top.layer.confirm('确定要停用选中的防区吗？', {
                            btn: ['确定', '取消']
                        }, function () {
                            var actionUrl = "${path}/sarea/changeStatus.do";
                            var params = {
                                ids: ids,
                                status: 1
                            };
                            $.post(actionUrl, params, function (data) {
                                if (data.success) {
                                    top.layer.alert('停用成功！！');
                                   // active.reload();
                                    table.reload('sarea', {page: {curr: currpage}});
                                } else {
                                    top.layer.alert(data.msg);
                                    return;
                                }
                            });
                        });
                    }
                },
                //获取被选中的表格数据ID集合
                getCheckData: function () {
                    var data = table.checkStatus('sarea').data;
                    var ids = [];
                    for (var i = 0; i < data.length; i++) {
                        ids.push(data[i].areaId);
                    }
                    return ids;
                }
            };
        $('i').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
// 			$('#roleName').on('input', function() {
// 				active.reload();
// 			});
        $('.layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });

    //用户状态格式化方法
    function statusFormat(value) {       
        return value == "1" ? "停用" : "启用";
    }
    //主机名称格式化
    function creaetHost(value){       
        if (value == "") {
           return "无";
        }
        return value.name;
    }
</script>
</body>
</html>