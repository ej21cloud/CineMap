<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <title>영화 프로젝트 홈페이지</title>
</head>
<body>
<%@include file="index_top.jsp" %>
<!-- 콘텐츠 영역 -->
    <main>
        <div class="content-wrapper">
            <div class="left-section">
                <div class="movie-info">인기 영화 정보</div>
                <div class="free-board">자유게시판</div>
            </div>
            <div class="right-section">
	           <div class="review">리뷰</div>
            </div>
            <div class="ad" id="ad">광고</div>
        </div>
    </main>
</body>
</html>