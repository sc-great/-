<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/common_taglib.jsp"%>
<%@ include file="/common/common_css.jsp"%>
<%@ include file="/common/common_js.jsp"%>
<!DOCTYPE html>
<html class="iframe-h">
<head>
<meta charset="UTF-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
<title></title>
<link rel="stylesheet" type="text/css" href="${path }/css/list.css" />
<link rel="stylesheet" type="text/css"
	href="${path }/plugin/kalendae/kalendae.css" />
	<script src="${path }/plugin/layui/layui.js" type="text/javascript"
	charset="utf-8"></script>
<script type="text/javascript"
	src="${path }/plugin/kalendae/kalendae.standalone.js"></script>
	<style>
        input,
        label {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            -moz-osx-font-smoothing: grayscale;
            -webkit-font-smoothing: antialiased;
            text-rendering: optimizeLegibility;
            font-family: Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Arial, sans-serif;
        }

        a:focus,
        a:active {
            outline: none;
        }

        a,
        a:focus,
        a:hover {
            cursor: pointer;
            color: inherit;
            text-decoration: none;
        }

        button {
            outline: none;
        }

        html,
        body {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            height: 100%;
        }

        ul {
            overflow: hidden;
            padding: 0
        }

        ul li {
            margin: 0;
            padding: 10px 0;
            list-style: none;
            width: 190px;
              height:202px;
            border: 1px solid #ebebeb;
            margin: 10px 1.2%;
            float: left;
        }

        .header-warp {
            padding: 0 20px;
            margin-top: 20px;
        }

        .warp-input {
            height: 32px;
            width: 205px
        }

        .label-tit {
            display: inline-block;
            color: #a2a2a2;
            font-size: 15px;
            width: 80px;
            text-align: right;
        }

        .year-title {
            height: 40px;
            border: 1px solid #ebebeb;
            margin: 20px 10px 0 10px;
            background: #eceaea;
            border-radius: 4px;
            text-align: center;
            line-height: 40px;
            color: #AA7652;
            font-size: 18px;
            font-weight: bold;
            position: relative;
        }

        .year-title:hover {
            opacity: 0.7px;
        }

        .clickRiht {
            width: 0;
            height: 0;
            border-width: 15px;
            border-style: solid;
            border-color: transparent rgba(125, 127, 128, 0.267) transparent transparent;
            transform: rotate(180deg);
            position: absolute;
            right: 0px;
            top: 5px;
        }

        .clickLeft {
            width: 0;
            height: 0;
            border-width: 15px;
            border-style: solid;
            border-color: transparent rgba(125, 127, 128, 0.267) transparent transparent;
            transform: rotate(360deg);
            position: absolute;
            left: 0px;
            top: 5px;
        }

        .clickLeft:hover {
            opacity: 0.6;
            border-color: transparent #0099CC transparent transparent;
        }

        .clickRiht:hover {
            opacity: 0.6;
            border-color: transparent #0099CC transparent transparent;
        }

        .header-th {
            width: 100%;
            text-align: center;
            color: #a2a2a2;
            font-weight: bold;
            height: 28px;
        }

        .thead-td {
            display: inline-block;
            width: 27px;
            height: 20px;
            text-align: center;
            line-height: 20px;
            font-size: 14px;
            color: #a2a2a2;
            font-weight: bold;
        }

        .tbody {
            height: 135px
        }

        .tbody-td {
            display: inline-block;
            width: 27px;
            height: 27px;
            text-align: center;
            line-height: 27px;
            font-size: 12px;
            color: #a2a2a2;
        }

        .dyspan {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            line-height: 20px;
            cursor: pointer;
        }

        .dyspan:hover {
            background: cadetblue;
            color: #fff;
        }

        .td-span {
            background: cadetblue;
            color: #fff;
        }

        .display-item {
            display: none
        }

        .checkbox-init {
            display: inline-block;
            width: 100px;
            height: 32px;
            border: 0;
            padding: 0;
            margin-right: 10px;
            background-color: #3da1ff;
            color: #fff;
            border-radius: 4px;
            text-align: center;
            line-height: 32px;
            font-size: 14px;
        }

        .checkbox-init:hover {
            opacity: 0.7;
        }
    </style>
	
</head>
<body>
<form class="layui-form  layui-from-header"
		style="height: calc(100% - 27px); overflow: auto;" lay-filter="mdForm">
	<input type="hidden" name="tId" value="${param.tId }" />
	<div class="layui-row">
			<div class="header-warp">
				<label class="label-tit">策略名称：</label> <input class="warp-input"
					id="tName" name="tName" />
			</div>
			<div class="header-warp">
				<label class="label-tit">日期：</label><label check="0"
					week="1-2-3-4-5" class="checkbox-init clickAllDay">所有工作日</label><label
					check="0" week="6-0" class="checkbox-init clickWeekDay">所有周末</label>
			</div>
			<div class="year-title">
				<span></span>
				<div class="clickLeft" onclick="clickLeft(true)"></div>
				<div class="clickRiht" onclick="clickLeft(false)"></div>
			</div>
			<div class="content">
				<ul id="calendar">
					<li class="calendar-item display-item">
						<div class="header-th">一月</div>
						<div class="thead"></div>
						<div class="tbody"></div>
					</li>
				</ul>
			</div>
		</div>
	</form>
	</body>

	
  <script src="http://www.jq22.com/jquery/2.1.1/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="js/jquery-2.1.1.min.js"><\/script>')</script>
    <script>
        /* 编辑更新方法： 选把后台拉过来的数据 赋给 dataSource 数组； 再调 updateCalendar（）
         * 如：  dataSource = ['2019-1-4', '2019-1-8']（后台接口数据)；
         *       date = new Date(dataSource[0].split('-')[0], 1, 1);
         *       updateCalendar()
        */
    	
        var date = new Date();
       var dataSource = [];
        var checkNodes = $('.checkbox-init');
        var weeks = [];
        var days = [];
        var dyspan = null;


        $(function () {
        	//表单初始赋值，通过编号获取设备类型数据初始化表单
    		$.post("${path}/tactics/getById.do", {
    			id : "${param.tId}"
    		}, function(data) {
    			dataSource =data.job.dateList;
    			date = new Date(dataSource[0].split('-')[0], 1, 1);
                initCalendar();
                updateCalendar();
				console.log(dataSource);
              // initCalendar();
               $(".clickAllDay").on("click", clickAllDay);
               $(".clickWeekDay").on("click", clickWeekDay);
    		});
            // dataSource = ['2018-1-4', '2018-1-8']
             
        })
        var FullYear = date.getFullYear();
        function clickLeft(value) {
            if (value == true) date = new Date(FullYear -= 1, 1, 1);
            else date = new Date(FullYear += 1, 1, 1);
            dataSource = [];
            weeks = [];
            days = [];
            $('.clickAllDay').attr('check', 0).text('所有工作日').css("background-color", '#3da1ff');
            $('.clickWeekDay').attr('check', 0).text('所有周末').css("background-color", '#3da1ff');
            $('#calendar').html(
                '<li class="calendar-item display-item">' +
                '<div class="header-th">一月</div>' +
                '<div class="thead"></div>' +
                '<div class="tbody"></div>' +
                '</li>'
            )
            initCalendar()
        }
        /* 日历表初始化*/
        function initCalendar() {
            let year = date.getFullYear();
            console.log(year)
            let m, d, day = "";
            $('.year-title span').text(year);
            for (m = 1; m <= 12; m++) {
                let lis =
                    '<li>' +
                    '<div class="header-th">' + m + '月</div>' +
                    '<div class="thead">' +
                    '<label class="thead-td">一</label>' +
                    '<label class="thead-td">二</label>' +
                    '<label class="thead-td">三</label>' +
                    '<label class="thead-td">四</label>' +
                    '<label class="thead-td">五</label>' +
                    '<label class="thead-td">六</label>' +
                    '<label class="thead-td">七</label>' +
                    '</div>' +
                    '<div class="tbody"></div>'
                '</li>'
                $('#calendar').append(lis);
                let dd = new Date(year + '/' + m + '/' + 1).getDay();
                for (let n = dd == 0 ? -5 : 2 - dd; n < mGetDate(year, m) + 1; n++) {
                    if (n <= 0) {
                        let tbody = '<label class="tbody-td">' + '<span class="disColor">-</span>' + '</label>'
                        $($('.tbody')[m]).append(tbody);
                    } else if (n >= 1 && n <= 31) {
                        let _m = m < 10 ? '0' + m : m; //月
                        let _n = n < 10 ? '0' + n : n; //日
                        let t = year + '-' + _m + '-' + _n; //年
                        let tbody = '<label class="tbody-td" onClick="clickDay(this)" dateTime=' + t + '>' + '<span class="dyspan" dateTime=' + t + '>' + n + '</span>' + '</label>'
                        $($('.tbody')[m]).append(tbody);
                    }
                }
            }
            dyspan = $('span.dyspan');
        }

        /* 更新日历表*/
        function updateCalendar() {
            for (let n = 0; n < dyspan.length; n++) {
                let dateTime = $(dyspan[n]).attr('dateTime');
                $(dyspan[n]).removeClass('td-span');
            }
            for (let i = 0; i < dataSource.length; i++) {
                for (let n = 0; n < dyspan.length; n++) {
                    let dateTime = $(dyspan[n]).attr('dateTime');
                    if (dateTime == dataSource[i]) {
                        $(dyspan[n]).addClass('td-span')
                    }
                }
            }
        }

        /* 所有周末*/
        function clickWeekDay() {
            handelClikBtn(this, 'clickWeekDay')
        }
        function handelClikBtn(that, type) {
            let str = '';
            let checkeds = [];
            if ($(that).attr('check') == 0) $(that).attr('check', 1).text('取消选择').css("background-color", '#e6a23c');
            else $(that).attr('check', 0).text(type == 'clickAllDay' ? '所有工作日' : '所有周末').css("background-color", '#3da1ff');
            if ($(that).attr('check') == 1) str += '-' + $(that).attr('week'); else {
                checkeds.push($(that).attr('check'));
                checkeds.length == checkNodes.length && (str = '');
            }
            if (type == 'clickAllDay') days = str.split('-');
            else weeks = str.split('-');
            dataSource = [];
            let ff = weeks.concat(days).filter(function (item) {
                return item != ''
            });
            for (let i = 0; i < ff.length; i++) {
                initDataSource(ff[i]);
            }
            updateCalendar();
            console.log('提交的数据', dataSource)
        }
        /* 所有工作日*/
        function clickAllDay() {
            handelClikBtn(this, 'clickAllDay');
        }

        /* 点击每一天*/
        function clickDay(that) {
            let dateTime = $(that).attr('dateTime');
            let indexOf = '';
            for (let i = 0; i < dataSource.length; i++) {
                if (dataSource[i] == dateTime) indexOf = i
            }
            if (indexOf.length == 0) dataSource.push(dateTime);
            else dataSource.splice(indexOf, 1);
            updateCalendar();
            console.log('提交的数据', dataSource)
        }

        /* 数据组装*/
        function initDataSource(week) {
            let year = date.getFullYear();
            let m, d, day = "";
            for (m = 1; m <= 12; m++) {
                for (d = 1; d <= mGetDate(year, m); d++) {
                    date.setMonth(m - 1, d);
                    day = date.getDay();
                    let _m = date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1; //月
                    let _n = date.getDate() < 10 ? '0' + date.getDate() : date.getDate(); //日
                    if (day == week) {
                        dataSource.push(date.getFullYear() + "-" + _m + "-" + _n)
                    }
                }
            }
        }

        /* 计算每月有多少天*/
        function mGetDate(year, month) {
            let day = new Date(year, month, 0);
            return day.getDate();
        }
	

		var nodeId;
		var nodeName;
		layui.use([ 'layer', 'form','tree','jquery' , 'upload'], function() {	
			var form = layui.form;
			var $ = layui.jquery;
			var upload=layui.upload;
			$('.layui-close-layer').click(function() {
				let index = parent.layer.getFrameIndex(window.name);
				parent.layer.close(index);
			});
			var $ = layui.jquery;			
		
			//表单初始赋值，通过编号获取设备类型数据初始化表单
			$.post("${path}/tactics/getById.do", {
				id : "${param.tId}"
			}, function(data) {
				form.val('mdForm', {
					"tName" : data.job.tName,
					dataSource : data.job.dateList,
					
				});	
			});
			
		
		});
		
		
		</script>		

</html>