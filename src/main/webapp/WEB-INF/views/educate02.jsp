<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<html>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62e7a3a69293ccda4804ae2416e6eec5"></script>


<head>
	<title>지도 이동시키기</title>
</head>
<body>
	<div id="map" style="width:100%;height:350px;"></div>
	<p>
		<button onclick="setCenter()">지도 중심좌표 이동시키기</button>
		<button onclick="panTo()">지도 중심좌표 부드럽게 이동시키기</button>
	</p>
	<p>
		<button onclick="zoomIn()">지도레벨 - 1</button>
		<button onclick="zoomOut()">지도레벨 + 1</button>
		<span id="maplevel"></span>
	</p>
	<script type="text/javascript">
		var mapContainer = document.getElementById('map');
		 // 지도를 표시할 div
		 var mapOption = {
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

		// 지도 레벨을 표시합니다
		displayLevel();

		function setCenter() {
		    // 이동할 위도 경도 위치를 생성합니다
		    var moveLatLon = new kakao.maps.LatLng(33.452613, 126.570888);

		    // 지도 중심을 이동 시킵니다
		    map.setCenter(moveLatLon);
		}

		function panTo() {
		    // 이동할 위도 경도 위치를 생성합니다
		    var moveLatLon = new kakao.maps.LatLng(33.450580, 126.574942);

		    // 지도 중심을 부드럽게 이동시킵니다
		    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
		    map.panTo(moveLatLon);
		}

		function displayLevel(){
  		  var levelEl = document.getElementById('maplevel');
 		   levelEl.innerHTML = '현재 지도 레벨은 ' + map.getLevel() + ' 레벨 입니다.';
		}



	</script>

</body>
</html>
