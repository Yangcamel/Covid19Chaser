<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62e7a3a69293ccda4804ae2416e6eec5"></script>
<head>
<title>Home</title>
</head>
<body>
	<div id="staticMap" style="width:600px;height:350px;"></div>

	<script>
		var staticMapContainer  = document.getElementById('staticMap'), // 이미지 지도를 표시할 div
		    staticMapOption = {
		        center: new kakao.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
		        level: 3 // 이미지 지도의 확대 레벨
		    };

		// 이미지 지도를 표시할 div와 옵션으로 이미지 지도를 생성합니다
		var staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
	</script>

</body>
</html>
