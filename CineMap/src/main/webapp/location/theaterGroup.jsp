<%@ page import="java.util.ArrayList" %>
<%@ page import="pack.theater.TheaterManager" %>
<%@ page import="pack.theater.TheaterDTO" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
   <title>영화관 목록</title>
   <meta charset="UTF-8">
   <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9f8edb499be7a8316726bf8802b0fa00"></script>
<link rel="stylesheet" type="text/css" href="../css/theater.css">
</head>
<body>
<div class="container">
<%
    String name = request.getParameter("name");
    TheaterManager manager = new TheaterManager();
    ArrayList<TheaterDTO> list = manager.getTheatersByName(name);
%>

<h2><%= name %> 영화관</h2>

<div class="theater-list">
    <%
        for (int i = 0; i < list.size(); i++) {
            TheaterDTO dto = list.get(i);
    %>
        <div class="theater-item" onclick="showMarker(<%= dto.getLatitude() %>, <%= dto.getLongitude() %>, '<%= dto.getName().replace("'", "\\'") %>', '<%= dto.getAddress().replace("'", "\\'") %>')">
            🎬 <%= dto.getName() %>
        </div>
    <%
        }
    %>
</div>

<div class="map-image" style="display: flex; align-items: center; margin-bottom: 10px;">
    <div style="flex: 1; height: 1px; background-color: #ccc;"></div>
    <img src="../images/theater.gif" alt="영화관 이미지" style="margin: 0 15px; height: 40px;">
    <div style="flex: 1; height: 1px; background-color: #ccc;"></div>
</div>

<div id="map"></div>
</div>

<h3 style="text-align:center;">영화목록</h3>

<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5003928, 127.0269962),
        level: 4
    };
    var map = new kakao.maps.Map(mapContainer, mapOption);

    var currentMarker = null;
    var currentInfowindow = null;

    function showMarker(lat, lng, name, address) {
        var position = new kakao.maps.LatLng(lat, lng);

        // 기존 마커 제거
        if (currentMarker) {
            currentMarker.setMap(null);
        }
        if (currentInfowindow) {
            currentInfowindow.close();
        }

        // 새 마커 생성
        currentMarker = new kakao.maps.Marker({
            position: position,
            map: map
        });

        currentInfowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:5px; width:200px; word-break:break-word;">' +
                     '<strong>' + name + '</strong><br>' +
                     address + '</div>'
        });

        currentInfowindow.open(map, currentMarker);
        map.setCenter(position);
        map.setLevel(4);
    }
</script>
</body>
</html>