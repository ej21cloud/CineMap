<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.cookie.CookieManager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% CookieManager cm = CookieManager.getInstance(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", () => {
    // 서버에서 현재 테마 상태 가져오기
    fetch("/CineMap/getThemeCookie", { credentials: "same-origin" })
        .then((response) => response.json())
        .then((data) => {
            if (data.mode === "dark") {
                document.body.classList.add("dark-mode");
                themeToggle.textContent = "☀️";
            } else {
                document.body.classList.remove("dark-mode");
                themeToggle.textContent = "🌙";
            }
        });
});
</script>
</head>
<body>
    <!-- 헤더 영역 -->
    <header>
        <div class="logo"><a href="/CineMap/index.jsp">시네맵</a></div>
        <div class="search-bar"><input type="text" id="movieSearch" name="movieSearch" placeholder="영화 제목 입력"></div>
        <div class="login">
    <c:choose>
        <%-- 세션에 id 값이 있는 경우(로그인 상태) --%>
        <c:when test="${not empty sessionScope.idKey}">
            <a href="/CineMap/member/mypage.jsp">마이페이지</a>
            <a href="/CineMap/member/logout.jsp">로그아웃</a>
        </c:when>        
        <%-- 세션에 id 값이 없는 경우(비로그인 상태) --%>
        <c:otherwise>
            <a href="/CineMap/member/login.jsp">로그인</a>
        </c:otherwise>
    </c:choose>
</div>
		<button id="theme-toggle">🌙</button>
    </header>
    <!-- 메뉴 영역 -->
    <nav>
     	<div class="menu-item"><a href="/CineMap/board/list.jsp?category=%EA%B3%B5%EC%A7%80%EC%82%AC%ED%95%AD&sort=recent">공지사항</a></div>
        <div class="menu-item"><a href="/CineMap/review/movielist.jsp">영화 리뷰</a></div>
          <div class="navbar">
    	<div class="nav-item">영화관
      <div class="dropdown-content">
        <div class="sub-item">
          <a href="/CineMap/location/theaterGroup.jsp?name=CGV">CGV</a>
        </div>
        <div class="sub-item">
          <a href="/CineMap/location/theaterGroup.jsp?name=메가박스">메가박스</a>
        </div>
        <div class="sub-item">
          <a href="/CineMap/location/theaterGroup.jsp?name=롯데시네마">롯데시네마</a>
        </div>
        <div class="sub-item">
          <a href="/CineMap/location/theaterGroup.jsp?name=기타">그 외</a>
        </div>
      </div>
    </div>
  </div>
        <div class="menu-item"><a href="/CineMap/board/list.jsp">자유 게시판</a></div>
    </nav>
<!-- 검색어 자동 완성 기능 스크립트 -->
        <script>
        $(function() {
            const searchInput = $("#movieSearch");
            searchInput.autocomplete({
    source: function(request, response) {
        $.ajax({
            url: "/CineMap/autocomplete.jsp",
            dataType: "json",
            data: { term: request.term },
            success: function(data) {
                response(data);
            },
            error: function(xhr, status, error) {
                response([]);
            }
        });
    },
    minLength: 1
});
            // Enter 키 이벤트 핸들러
            searchInput.on("keydown", function(event) {
                if (event.keyCode === 13) { // Enter 키 코드
                    event.preventDefault();
                    executeSearch();
                }
            });
            // 검색 실행 함수
            function executeSearch() {
                const searchTerm = searchInput.val().trim();
                if (searchTerm) {
                    window.location.href = "/CineMap/search.jsp?query=" + encodeURIComponent(searchTerm);
                }
            }
        });
        
        const themeToggle = document.getElementById("theme-toggle");
        // 버튼 클릭 이벤트
        themeToggle.addEventListener("click", () => {
    const isDarkMode = document.body.classList.contains("dark-mode");
 
    if (isDarkMode) {
        // 다크 모드 -> 라이트 모드로 전환
        document.body.classList.remove("dark-mode");
        themeToggle.textContent = "🌙";

        // 서버에 요청하여 쿠키 삭제
        fetch("/CineMap/deleteThemeCookie", {
            method: "POST"
        });
    } else {
        // 라이트 모드 -> 다크 모드로 전환
        document.body.classList.add("dark-mode");
        themeToggle.textContent = "☀️";

        // 서버에 요청하여 쿠키 추가
        fetch("/CineMap/ThemeCookie", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ mode: "dark" })
        });
    }
});
</script>
</body>
</html>