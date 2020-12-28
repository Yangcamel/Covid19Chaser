<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62e7a3a69293ccda4804ae2416e6eec5"></script>
<head>
<title>Home</title>
</head>
<body>
	<h1>지도기능(마커</h1>
	<div id="map" style="width: 100%; height: 350px;"></div>
	<p>
		<button onclick="setBounds()">지도 범위 재설정 하기</button>
	</p>
	<p>
	<em>지도를 클릭해주세요!</em><br>
		<span id="result"></span>
	</p>
	<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

	// 버튼을 클릭하면 아래 배열의 좌표들이 모두 보이게 지도 범위를 재설정합니다
	var points = [
	    new kakao.maps.LatLng(33.452671, 126.574792),
	    new kakao.maps.LatLng(33.451744, 126.572441),
	    new kakao.maps.LatLng(33.451447, 126.572442),
	    new kakao.maps.LatLng(33.451949, 126.572440)

	];

	// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성합니다
	var bounds = new kakao.maps.LatLngBounds();

	var i, marker;
	for (i = 0; i < points.length; i++) {
	    // 배열의 좌표들이 잘 보이게 마커를 지도에 추가합니다
	    marker = new kakao.maps.Marker({ 
		    position : points[i] 
	    });
	    marker.setMap(map);

	    // LatLngBounds 객체에 좌표를 추가합니다
	    bounds.extend(points[i]);
	}

	function setBounds() {
	    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
	    // 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
	    map.setBounds(bounds);
	}


	//마커 중심에 생성 후 map에 세팅
	var markerMove = new kakao.maps.Marker({ 
	    // 지도 중심좌표에 마커를 생성합니다 
	    position: map.getCenter() 
	}); 
	markerMove.setMap(map);

	/*
	*이벤트 리스너 모음 들  (click, dragend, zoom_changed, center_changed, bounds_changed, tilesloaded)
	*/ 
	//지도 클릭 이벤트시
	kakao.maps.event.addListener(map, 'click', function(mouseEvent){
		console.log(mouseEvent);
		var latlng = mouseEvent.latLng;

		//생성한 markerMove 마크를 마우스 클릭한 위치로 셋포지션 
		markerMove.setPosition(latlng);
		
		var message = '클릭한 위치의 위도는 '+latlng.getLat()+' : ';
		message += '경도는 '+latlng.getLng();

		var resultDiv = document.getElementById('result');
		resultDiv.innerHTML = message;

		});

	//지도 드래그 이벤트시
	kakao.maps.event.addListener(map, 'dragend', function() {        
	    
	    // 지도 중심좌표를 얻어옵니다 
	    var latlng = map.getCenter(); 
	    
	    var message = '변경된 지도 중심좌표는 ' + latlng.getLat() + ' 이고, ';
	    message += '경도는 ' + latlng.getLng() + ' 입니다';
	    
	    var resultDiv = document.getElementById('result');  
	    resultDiv.innerHTML = message;
	    
	});

	//지도 줌 변경시
	kakao.maps.event.addListener(map, 'zoom_changed', function() {        
	    
	    // 지도의 현재 레벨을 얻어옵니다
	    var level = map.getLevel();
	    
	    var message = '현재 지도 레벨은 ' + level + ' 입니다';
	    var resultDiv = document.getElementById('result');  
	    resultDiv.innerHTML = message;
	    
	});

	//지도 중심좌표 변경시
	kakao.maps.event.addListener(map, 'center_changed', function() {

	    // 지도의  레벨을 얻어옵니다
	    var level = map.getLevel();

	    // 지도의 중심좌표를 얻어옵니다 
	    var latlng = map.getCenter(); 

	    var message = '<p>지도 레벨은 ' + level + ' 이고</p>';
	    message += '<p>중심 좌표는 위도 ' + latlng.getLat() + ', 경도 ' + latlng.getLng() + '입니다</p>';

	    var resultDiv = document.getElementById('result');
	    resultDiv.innerHTML = message;

	});

	//지도 영역 변경시
	kakao.maps.event.addListener(map, 'bounds_changed', function() {             
	    
	    // 지도 영역정보를 얻어옵니다 
	    var bounds = map.getBounds();
	    
	    // 영역정보의 남서쪽 정보를 얻어옵니다 
	    var swLatlng = bounds.getSouthWest();
	    
	    // 영역정보의 북동쪽 정보를 얻어옵니다 
	    var neLatlng = bounds.getNorthEast();
	    
	    var message = '<p>영역좌표는 남서쪽 위도, 경도는  ' + swLatlng.toString() + '이고 <br>'; 
	    message += '북동쪽 위도, 경도는  ' + neLatlng.toString() + '입니다 </p>'; 
	    
	    var resultDiv = document.getElementById('result');   
	    resultDiv.innerHTML = message;
	    
	});

	//지도 로딩이 끝났을시
	var centerMarker = new kakao.maps.Marker();
	//함수 따로 만드는 방식
	kakao.maps.event.addListener(map, 'tilesloaded', displayMarker);
	function displayMarker() {
	    // 마커의 위치를 지도중심으로 설정합니다 
	    centerMarker.setPosition(map.getCenter()); 
	    centerMarker.setMap(map); 

	    // 아래 코드는 최초 한번만 타일로드 이벤트가 발생했을 때 어떤 처리를 하고 
	    // 지도에 등록된 타일로드 이벤트를 제거하는 코드입니다 
	    // kakao.maps.event.removeListener(map, 'tilesloaded', displayMarker);
	}
	
	</script>

</body>
</html>
