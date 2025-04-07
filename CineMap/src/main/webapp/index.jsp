<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/main.css">
<title>시네맵</title>
</head>
<body>
<%@include file="index_top.jsp" %>
    <main>
        <div class="content-wrapper">
            <div class="left-section">
                 <div class="image-pair-container">
        <c:forEach items="${imagePair}" var="imageUrl">
            <img src="${imageUrl}" class="movie-image" 
                 alt="영화 포스터" 
                 onerror="this.src='https://via.placeholder.com/400x600?text=Image+Not+Found'">
        </c:forEach>
    </div>
                <div class="free-board">게시판 최근 게시글</div>
            </div>
            <div class="right-section">
	           <div class="review">인기 리뷰</div>
            </div>
            <div class="ad" id="ad">광고</div>
        </div>
    </main>
</body>
</html>