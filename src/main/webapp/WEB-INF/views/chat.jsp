<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Chatting</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
	
	<!-- <link rel="stylesheet" href="/examples/media/expand_style.css"> css 작성하기 -->
	
	<style>
		* {
			margin:0;
			padding:0;
		}
		.container {
			width: 600px;
			margin: 0 auto;
			padding: 25px
		}
		.container h1{
			text-align: center;
			margin: 0 auto;
			margin-bottom: 20px;
			/* padding: 5px 5px 5px 15px; */
			color: SlateBlue;
			/* border-left: 3px solid SlateBlue; */
		}
		.chating{
			background-color: #F6F6F6;
			width: 500px;
			height: 500px;
			margin: 0 auto;
			overflow: scroll;
		}
		.chating .me{
			font-weight: bold;
			color: black;
			text-align: right;
			font-size: 18px;
		}
		.chating .meText{
			color: black;
			text-align: right;
		}
		.chating .others{
			font-weight: bold;
			color: black;
			text-align: left;
			font-size: 18px;
		}
		.chating .othersText{
			color: black;
			text-align: left;
		}
		input{
			width: 330px;
			height: 25px;
			margin: 0 auto;
		}
		#yourMsg{
			display: none;
		}
		.btn {
			background-color: #6A5BCD;
			/* padding: 15px 30px; */
			border: solid 1px #6A5BCD;
			color: white;
			text-align: center;
			text-decoration: none;
			font-size: 16px;
			display: inline-block;
			cursor: pointer;
			/* float: right; */
		}
		.btn:hover {
			background-color: #1E90FF;
			border: solid 1px #1E90FF;
			color: white;
		}
		.inputTable th {
			padding: 5px;
			margin: 0 auto;
		}
		.inputTable input {
			width: 330px;
			margin: 0 auto;
		}
		input[type=text] {
			height: 40px;
		}
	</style>
</head>
<body>
	<div id="container" class="container">
		<h1>
			<i class='fas fa-comment-dots' style='font-size: 36px; color: SlateBlue;'>&nbsp;${roomName}</i>
		</h1>
		<input type="hidden" id="sessionId" value="">
		<input type="hidden" id="roomNumber" value="${roomNumber}">
		
		<div id="chating" class="chating">
		<!-- 채팅내역 -->
		</div>
		
		<div id="yourName">
			<table class="inputTable d-flex justify-content-center">
				<tr>
					<th><input type="text" name="userName" id="userName" placeholder="사용자명을 입력해주세요"></th>
					<th><button class="btn btn-sm" onclick="chatName()" id="startBtn">등록</button></th>
				</tr>
			</table>
			<div class="d-flex justify-content-center">
				<button class="btn btn-sm mt-5" onclick="backPage()">뒤로가기</button>
			</div>
		</div>
		
		<div id="yourMsg">
			<table class="inputTable d-flex justify-content-center">
				<tr>
					<th><input type="text" id="chatting" placeholder="보내실 메시지를 입력하세요"></th>
					<th><button class="btn btn-sm" onclick="send()" id="sendBtn">전송</button></th>
				</tr>
			</table>
			<div class="d-flex justify-content-center">
				<button class="btn btn-sm mt-5" onclick="backPage()">뒤로가기</button>
			</div>
		</div>
	</div>
	
<script type="text/javascript">

	var ws;

	function wsOpen(){
		// 웹소켓 전송시 현재 방의 번호를 넘겨서 보낸다.
		ws = new WebSocket("ws://" + location.host + "/chating/"+$("#roomNumber").val());
		wsEvt();
	}
		
	function wsEvt() {
		ws.onopen = function(data) {
			// 소켓이 열리면 동작
		}
		
		ws.onmessage = function(data) {
			// 메시지를 받으면 동작
			var msg = data.data;
			if (msg != null && msg.trim() != '') {
				var d = JSON.parse(msg);
				if (d.type == "getId") {
					var si = d.sessionId != null ? d.sessionId : "";
					if (si != '') {
						$("#sessionId").val(si); 
					}
				} else if (d.type == "message") {
					if (d.sessionId == $("#sessionId").val()) {
						$("#chating").append("<p class='me'><i class='fas fa-user-circle'></i>&nbsp;나&nbsp;</p>" + "<p class='meText'><mark>" + d.msg + "</mark>&nbsp;</p>");	
					} else {
						$("#chating").append("<p class='others'>&nbsp;<i class='fas fa-user-circle'></i>&nbsp;" + d.userName + "</p>" + "<p class='ohtersText'>&nbsp;<mark>" + d.msg + "<mark></p>");
					}
						
				} else {
					console.warn("unknown type!")
				}
			}
		}

		document.addEventListener("keypress", function(e) {
			if (e.keyCode == 13){ // enter press
				send();
			}
		});
	}

	function chatName(){
		var userName = $("#userName").val();
		if (userName == null || userName.trim() == "") {
			alert("사용자 이름을 입력해주세요.");
			$("#userName").focus();
		} else {
			wsOpen();
			$("#yourName").hide();
			$("#yourMsg").show();
		}
	}

	function send() {
		var option = {
			type: "message",
			roomNumber: $("#roomNumber").val(),
			sessionId : $("#sessionId").val(),
			userName : $("#userName").val(),
			msg : $("#chatting").val()
		}
		ws.send(JSON.stringify(option))
		$('#chatting').val("");
	}
	
	function backPage() {
		location.href = "/room.do";
	}
	
	// 스크롤 하단 고정
	$(document).ready(function() {
		$('#chating').scrollTop($('#chating')[0].scrollHeight);
	})
</script>
</body>
</html>