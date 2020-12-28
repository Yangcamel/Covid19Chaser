<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<html>
<script type="text/javascript"
src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62e7a3a69293ccda4804ae2416e6eec5"></script>
<head>
	<title>Home</title>
	<style>
		html, body {width:100%;height:100%;margin:0;padding:0;}
		.map_wrap {position:relative;overflow:hidden;width:100%;height:350px;}
		.radius_border{border:1px solid #919191;border-radius:5px;}
		.custom_typecontrol {position:absolute;top:10px;right:10px;overflow:hidden;width:130px;height:30px;margin:0;padding:0;z-index:1;font-size:12px;font-family:'Malgun Gothic', '맑은 고딕', sans-serif;}
		.custom_typecontrol span {display:block;width:65px;height:30px;float:left;text-align:center;line-height:30px;cursor:pointer;}
		.custom_typecontrol .btn {background:#fff;background:linear-gradient(#fff,  #e6e6e6);}
		.custom_typecontrol .btn:hover {background:#f5f5f5;background:linear-gradient(#f5f5f5,#e3e3e3);}
		.custom_typecontrol .btn:active {background:#e6e6e6;background:linear-gradient(#e6e6e6, #fff);}
		.custom_typecontrol .selected_btn {color:#fff;background:#425470;background:linear-gradient(#425470, #5b6d8a);}
		.custom_typecontrol .selected_btn:hover {color:#fff;}
		.custom_zoomcontrol {position:absolute;top:50px;right:10px;width:36px;height:80px;overflow:hidden;z-index:1;background-color:#f5f5f5;}
		.custom_zoomcontrol span {display:block;width:36px;height:40px;text-align:center;cursor:pointer;}
		.custom_zoomcontrol span img {width:15px;height:15px;padding:12px 0;border:none;}
		.custom_zoomcontrol span:first-child{border-bottom:1px solid #bfbfbf;}
	</style>
</head>
<body>
<h1>지도 기본 기능 (지도 생성, 이동, 레이어 보이기, 뷰 보이기 등등)</h1>
	<div class="map_wrap">
	 	<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
	 	 <!-- 지도타입 컨트롤 div인데 안쓸거 같아서 주석 -->
<!-- 	    <div class="custom_typecontrol radius_border">
	        <span id="btnRoadmap" class="selected_btn" onclick="setMapType('roadmap')">지도</span>
	        <span id="btnSkyview" class="btn" onclick="setMapType('skyview')">스카이뷰</span>
	    </div>
	    지도 확대, 축소 컨트롤 div 입니다
	    <div class="custom_zoomcontrol radius_border">
	        <span onclick="zoomIn()"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_plus.png" alt="확대"></span>
	        <span onclick="zoomOut()"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_minus.png" alt="축소"></span>
	    </div>
	    -->
	</div>
	<button onclick="getInfo()">정보 받아오기</button>
	<p>
		<span id="messageSpan"></span>
	</p>

	<p>
		<button onclick="setDraggable(false)">지도 드래그 이동 끄기</button>
		<button onclick="setDraggable(true)">지도 드래그 이동 켜기</button>
	</p>
	<p>
		<button onclick="setZoomable(false)">지도 확대/축소 끄기</button>
		<button onclick="setZoomable(true)">지도 확대/축소 켜기</button>
	</p>
	<p>
		<button onclick="setZoomable(false)">지도 확대/축소 끄기</button>
		<button onclick="setZoomable(true)">지도 확대/축소 켜기</button>
	</p>
	<p>
		<button id="trafficMapTypeCheck" onclick="trafficCheckMapType()" value="false">교통정보 지도를 표시</button>
		<button id="roadviewMapTypeCheck" onclick="roadviewCheckMapType()" value="false">로드뷰 지도를 표시</button>
		<button id="terrainMapTypeCheck" onclick="terrainCheckMapType()" value="false">지형도뷰 지도를 표시</button>
	</p>
	<p>
	    <input type="checkbox" id="chkUseDistrict" onclick="setOverlayMapTypeId()" /> 지적편집도 정보 보기
	    <input type="checkbox" id="chkTerrain" onclick="setOverlayMapTypeId()" /> 지형정보 보기 
	    <input type="checkbox" id="chkTraffic" onclick="setOverlayMapTypeId()" /> 교통정보 보기       
	    <input type="checkbox" id="chkBicycle" onclick="setOverlayMapTypeId()" /> 자전거도로 정보 보기
	</p>

	<script>
	// 서울시청 기준
	// 지도 중심좌표는 위도 37.56617750588228, 경도 126.9774045281636
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div
		mapOption = {
			// 지도의 중심좌표
			center : new kakao.maps.LatLng(33.450701, 126.570667),
			// 지도의 확대 레벨
			level : 3
		};

		// 지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성 및 표시
		//(딴 지도 올릴려면 apis.map.kakao.com/web/sample/changeOverlay2/ 에서 버튼을 만든 뒤에 올릴수 있는 듯)
		var mapTypeControl = new kakao.maps.MapTypeControl();
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

		function getInfo() {
		    // 지도의 현재 중심좌표를 얻어옵니다
		    var center = map.getCenter();

		    // 지도의 현재 레벨을 얻어옵니다
		    var level = map.getLevel();

		    // 지도타입을 얻어옵니다
		    var mapTypeId = map.getMapTypeId();

		    // 지도의 현재 영역을 얻어옵니다
		    var bounds = map.getBounds();

		    // 영역의 남서쪽 좌표를 얻어옵니다
		    var swLatLng = bounds.getSouthWest();

		    // 영역의 북동쪽 좌표를 얻어옵니다
		    var neLatLng = bounds.getNorthEast();

		    // 영역정보를 문자열로 얻어옵니다. ((남,서), (북,동)) 형식입니다
		    var boundsStr = bounds.toString();


		    var message = '지도 중심좌표는 위도 ' + center.getLat() + ', <br>';
		    message += '경도 ' + center.getLng() + ' 이고 <br>';
		    message += '지도 레벨은 ' + level + ' 입니다 <br> <br>';
		    message += '지도 타입은 ' + mapTypeId + ' 이고 <br> ';
		    // message += '지도의 남서쪽 좌표는 ' + swLatLng.getLat() + ', ' + swLatLng.getLng() + ' 이고 <br>';
		    // message += '북동쪽 좌표는 ' + neLatLng.getLat() + ', ' + neLatLng.getLng() + ' 입니다';
		    var messageSpan = document.getElementById('messageSpan');
		    messageSpan.innerHTML = message;


		    // 개발자도구를 통해 직접 message 내용을 확인해 보세요.
		    // ex) console.log(message);
		}

		/*	//지도타입 CSS 컨트롤 하는 부분인데 안쓸거 같아서 일단 주석

		function setMapType(maptype) {
		    var roadmapControl = document.getElementById('btnRoadmap');
		    var skyviewControl = document.getElementById('btnSkyview');
		    if (maptype === 'roadmap') {
		        map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);
		        roadmapControl.className = 'selected_btn';
		        skyviewControl.className = 'btn';
		    } else {
		        map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);
		        skyviewControl.className = 'selected_btn';
		        roadmapControl.className = 'btn';
		    }
		}

		//지도 축소
		function zoomIn() {
		    map.setLevel(map.getLevel() - 1);
		}

		//지도 확대
		function zoomOut() {
		    map.setLevel(map.getLevel() + 1);
		} */

		// 버튼 클릭에 따라 지도 이동 기능을 막거나 풀고 싶은 경우에는 map.setDraggable(true/false)로 지정
		function setDraggable(draggable) {
		    // 마우스 드래그로 지도 이동 가능여부를 설정합니다
		    map.setDraggable(draggable);
		}
		// 버튼 클릭에 따라 지도 확대, 축소 기능을 막거나 풀고 싶은 경우에는 map.setZoomable(true/false)로 지정
		function setZoomable(zoomable) {
		    // 마우스 휠로 지도 확대,축소 가능여부를 설정합니다
		    map.setZoomable(zoomable);
		}

		// 지도에 교통정보를 표시하도록 지도타입을 추가합니다
		function trafficCheckMapType() {
			var trafficMapTypeCheck = document.getElementById('trafficMapTypeCheck');
			if(trafficMapTypeCheck.value == 'false'){
				map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC);
				trafficMapTypeCheck.value = 'true';
			}else{
				// 아래 코드는 위에서 추가한 교통정보 지도타입을 제거합니다
				map.removeOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC);
				trafficMapTypeCheck.value = 'false';
			}
		}

		// 지도에 로드뷰를 표시하도록 지도타입을 추가합니다
		function roadviewCheckMapType() {
			var roadviewMapTypeCheck = document.getElementById('roadviewMapTypeCheck');
			if(roadviewMapTypeCheck.value == 'false'){
				map.addOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);
				roadviewMapTypeCheck.value = 'true';
			}else{
				// 아래 코드는 위에서 추가한 교통정보 지도타입을 제거합니다
				map.removeOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);
				roadviewMapTypeCheck.value = 'false';
			}
		}

		// 지도에 지형도를 표시하도록 지도타입을 추가합니다
		function terrainCheckMapType() {
			var terrainMapTypeCheck = document.getElementById('terrainMapTypeCheck');
			if(terrainMapTypeCheck.value == 'false'){
				map.addOverlayMapTypeId(kakao.maps.MapTypeId.TERRAIN);
				terrainMapTypeCheck.value = 'true';
			}else{
				// 아래 코드는 위에서 추가한 교통정보 지도타입을 제거합니다
				map.removeOverlayMapTypeId(kakao.maps.MapTypeId.TERRAIN);
				terrainMapTypeCheck.value = 'false';
			}
		}

		function setOverlayMapTypeId() {
			
			var mapTypes = {
				    terrain : kakao.maps.MapTypeId.TERRAIN,    
				    traffic :  kakao.maps.MapTypeId.TRAFFIC,
				    bicycle : kakao.maps.MapTypeId.BICYCLE,
				    useDistrict : kakao.maps.MapTypeId.USE_DISTRICT
			};

			// 지도 타입을 제거합니다
		    for (var type in mapTypes) {
			    console.log(type);
		        map.removeOverlayMapTypeId(mapTypes[type]);    
		    }

		    // 지적편집도정보 체크박스가 체크되어있으면 지도에 지적편집도정보 지도타입을 추가합니다
		    if (chkUseDistrict.checked) {
		        map.addOverlayMapTypeId(mapTypes.useDistrict);    
		    }
		    
		    // 지형정보 체크박스가 체크되어있으면 지도에 지형정보 지도타입을 추가합니다
		    if (chkTerrain.checked) {
		        map.addOverlayMapTypeId(mapTypes.terrain);    
		    }
		    
		    // 교통정보 체크박스가 체크되어있으면 지도에 교통정보 지도타입을 추가합니다
		    if (chkTraffic.checked) {
		        map.addOverlayMapTypeId(mapTypes.traffic);    
		    }
		    
		    // 자전거도로정보 체크박스가 체크되어있으면 지도에 자전거도로정보 지도타입을 추가합니다
		    if (chkBicycle.checked) {
		        map.addOverlayMapTypeId(mapTypes.bicycle);    
		    }
		}

</script>

</body>
</html>
