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
</head>
<body>
<form class="layui-form  layui-from-header" lay-filter="roleForm">
    <input type="hidden" id="userPic" name="userPic" value="">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-form-item">
                <label class="layui-form-label">角色名</label>
                <div class="layui-input-block">
                    <input name="roleName" class="layui-input" type="text"
                           autocomplete="off" lay-verify="required" maxlength="64">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">描述</label>
                <div class="layui-input-block">
						<textarea class="layui-textarea" name="description"
                                  maxlength="1000" placeholder="请输入描述"></textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-submit-block">
                    <button class="layui-btn" lay-submit lay-filter="subimitForm">立即提交</button>
                    <button type="button" class="layui-btn layui-btn-primary layui-close-layer">取消</button>
                </div>
            </div>
        </div>
    </div>
</form>
<script src="${path }/plugin/layui/layui.js" type="text/javascript"
        charset="utf-8"></script>
<script type="text/javascript">
    layui.use(['laydate', 'layer', 'form', 'jquery'], function () {
        var form = layui.form;
        var $ = layui.jquery;
        $('.layui-close-layer').click(function () {
            let index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        });
        $('*[lay-verify*="required"]').parent().prev('label').prepend('<span style="color:red">*</span>&nbsp;&nbsp;');
        //表单提交方法
        form.on('submit(subimitForm)', function (data) {
            $.ajax({
                url: '${path }/role/add.do',
                method: 'post',
                data: data.field,
                dataType: 'JSON',
                success: function (res) {
                    if (res.success) {
                        $("*[lay-submit]").addClass("layui-btn-disabled").attr("disabled", "disabled");
                        var key = top.layer.alert("添加成功！", {
                                icon: 1,
                                closeBtn: 0
                            },
                            function () {
                                var index = parent.layer.getFrameIndex(window.name);
                                parent.layer.close(index);
                                parent.layer.close(key);
                            });
                    } else {
                        //layer.alert("添加失败！");
                        top.layer.alert("添加失败！" + res.msg);
                    }
                },
                error: function (data) {
                    var key = top.layer.alert("服务器异常！",
                        function () {
                            location.reload();
                            parent.layer.close(key);
                        });
                }
            })
            return false;
        });
    });
</script>
</body>
</html>