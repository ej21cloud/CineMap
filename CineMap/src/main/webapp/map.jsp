<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>영화관 위치</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.5.0/css/ol.css">
<script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.5.0/build/ol.js"></script>
    <style>
        #map { height: 700px; width: 100%; }
    </style>
</head>
<body>
<div id="map"></div>
<script>
const map = new ol.Map({
	  target: 'map',
	  layers: [ new ol.layer.Tile({  source: new ol.source.OSM()  })],
	  view: new ol.View({
	    center: ol.proj.fromLonLat([127.7669, 35.9078]), // 첫 화면에서 대한민국 중심으로 이동
	    zoom: 7
	  })});

	const theaters = [
	  {name: "영화관", lon: 126.9780, lat: 37.5665},
	  {name: "영화관", lon: 129.0756, lat: 35.1796}];
	  // 임시 테이블 영화관 정보 등을 더해 데이터 테이블 연동으로 사용

	const features = theaters.map(theater => {
	  return new ol.Feature({
	    geometry: new ol.geom.Point(ol.proj.fromLonLat([theater.lon, theater.lat])),
	    name: theater.name
	  });});

	const vectorSource = new ol.source.Vector({
	  features: features
	});

	const vectorLayer = new ol.layer.Vector({ // 마커 생성
	  source: vectorSource,
	  style: new ol.style.Style({
	    image: new ol.style.Circle({
	      radius: 5,
	      fill: new ol.style.Fill({color: 'gray'}),
	      stroke: new ol.style.Stroke({color: 'black', width: 1})})})});

	map.addLayer(vectorLayer);
	
	const popup = new ol.Overlay({
		  element: document.createElement('div'),
		  positioning: 'bottom-center',
		  stopEvent: false,
		  offset: [0, -10]
		});
		map.addOverlay(popup);

		map.on('click', function(evt) { // 마커 클릭 시 이벤트
			const feature = map.forEachFeatureAtPixel(evt.pixel, function(feature) {
		    return feature;
		  });
		  if (feature) {
			  const coordinates = feature.getGeometry().getCoordinates();
		    popup.setPosition(coordinates);
		    popup.getElement().innerHTML = feature.get('name');
		    popup.getElement().style.display = 'block';
		  } else {
		    popup.getElement().style.display = 'none';
		  }});
</script>
</body>
</html>