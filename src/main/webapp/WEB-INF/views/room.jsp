<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Room</title>
	
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
			padding: 25px;
		}
		.container h1 {
			text-align: center;
			margin: 0 auto;
			margin-bottom: 20px;
			/* padding: 5px 5px 5px 15px; */
			color: SlateBlue;
			/* border-left: 3px solid SlateBlue; */
		}
		.roomContainer {
			background-color: #F6F6F6;
			width: 500px;
			height: 500px;
			margin: 0 auto;
			overflow: auto;
		}
		.roomList {
			width: 500px;
			border: none;
		}
		.roomList th {
			border: 1px solid #6A5BCD;
			background-color: #fff;
			color: black;
		}
		.roomList td {
			border: 1px solid #6A5BCD;
			background-color: #fff;
			text-align: left;
			color: black;
		}
		.roomList .num {
			height: 40px;
			width: 75px;
			text-align: center;
		}
		.roomList .room {
			height: 40px;
			width: 350px;
			text-align: center;
		}
		.roomList .go {
			height: 40px;
			width: 71px;
			text-align: center;
		}
		.inputTable th {
			padding: 5px;
			margin: 0 auto;
		}
		.inputTable input {
			width: 330px;
			margin: 0 auto;
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
		input[type=text] {
			height: 40px;
		}
	</style>
</head>

<body>
	<div class="container">
		<h1>
			<i class='fas fa-comment-dots' style='font-size: 36px; color: SlateBlue;'>&nbsp;채팅방</i>
		</h1>
		<div id="roomContainer" class="roomContainer">
			<table id="roomList" class="roomList"></table>
		</div>
		<div class="d-flex justify-content-center mt-4" id="create-room-box">
			<button type="button" class="btn" id="create-room">채팅방 만들기</button> 
			<!-- 버튼 누르면 스크립트 조작할 곳 -->
		</div>
	</div>
	
<script type="text/javascript">
	var ws;
	window.onload = function(){
		getRoom();
//		createRoom();
	}

	// 최초 페이지 접근시 기존에 생성된 방 리스트를 가져옴
	function getRoom(){
		commonAjax('/getRoom', "", 'post', function(result){
			createChatingRoom(result);
		});
	}
	
	/*
	function createRoom(){
		$("#createRoom").click(function(){
			
			if ($("#roomName").val() == "") {
				alert("채팅방 이름을 입력해주세요");
				return false;
			};
			
			var msg = {	roomName : $('#roomName').val()	};

			commonAjax('/createRoom', msg, 'post', function(result){
				createChatingRoom(result);
			});

			$("#roomName").val("");
		});
	}
	*/
	
	// 채팅방 생성창
	$("#create-room").one("click", function() {
		
		$(this).hide();
		var content = '<div class="d-flex justify-content-center">';
		content += '<table class="inputTable">';
		content += "<tr>";
		content += '<th><input type="text" name="roomName" id="roomName" placeholder="채팅방 이름을 입력해주세요"></th>';
		content += '<th><button type="button" class="btn btn-success btn-sm" id="createRoom">만들기</button></th>';
		content += "</tr>";
		content += "</table>";
		content += "</div>";
		
		$("#create-room-box").append(content);
	})
	
	// 동적으로 append한 요소 클릭 이벤트 적용 // 동적 바인딩
	$(document).ready(function() {
		$(document).on("click","#createRoom",function(event){
			if ($("#roomName").val() == "") {
				alert("채팅방 이름을 입력해주세요.");
				$("#roomName").focus();
				return false;
			};
			
			// 정규표현식 24자 이하로
			var lengthRegExp = /^.{1,24}$/;
			
			var roomName = $("#roomName").val();
			
			if (!lengthRegExp.test(roomName)) {
				alert("글자수가 초과되었습니다. 24자 이하로 입력해주세요.");
				$("#roomName").focus();
				return false;
			}
			
			/*
			if ($(".room").val() == roomName) {
				alert("동일한 이름의 채팅방이 이미 존재합니다.");
				return false;
			}
			*/
			
			var msg = {	roomName : $('#roomName').val()	};

			commonAjax('/createRoom', msg, 'post', function(result){
				createChatingRoom(result);
			});

			$("#roomName").val("");
        });
    })

	function goRoom(number, name){
		location.href = "/chat.do?roomName="+name+"&"+"roomNumber="+number;
	}

	function createChatingRoom(res){
		if(res != null){
			var tag = "<tr><th class='num'>번호</th><th class='room'>방 이름</th><th class='go'></th></tr>";
			res.forEach(function(d, idx){
				var rn = d.roomName.trim();
				var roomNumber = d.roomNumber;
				tag += "<tr>"+
							"<td class='num'>"+(idx+1)+"</td>"+
							"<td class='room'>"+ rn +"</td>"+
							"<td class='go'><button type='button' class='btn btn-sm' onclick='goRoom(\""+roomNumber+"\", \""+rn+"\")'>참여</button></td>" +
						"</tr>";	
			});
			$("#roomList").empty().append(tag);
		}
	}

	function commonAjax(url, parameter, type, calbak, contentType) {
		$.ajax({
			url: url,
			data: parameter,
			type: type,
			contentType : contentType!=null?contentType:'application/x-www-form-urlencoded; charset=UTF-8',
			success: function (res) {
				calbak(res);
			},
			error : function(err){
				console.log('error');
				calbak(err);
			}
		});
	}
</script>
</body>
</html>