<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="pack.cookie.CookieManager" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // CookieManager 인스턴스 가져오기
    CookieManager cookieManager = CookieManager.getInstance();

    // 현재 모드 확인 (기본값: light)
    String mode = "light"; // 기본값
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("mode".equals(cookie.getName())) {
                try {
                    mode = cookieManager.readCookie(cookie);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // 모드 변경 요청 처리
    String toggleMode = request.getParameter("toggleMode");
    if (toggleMode != null) {
        mode = toggleMode;
        try {
            Cookie updatedCookie = cookieManager.updateCookie("mode", mode);
            response.addCookie(updatedCookie);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
</head>
<body class="<%= mode %>">
    <!-- 헤더 영역 -->
    <header>
        <div class="logo"><a >시네맵</a></div>
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
		<form method="post">
        <button type="submit" name="toggleMode" value="<%= mode.equals("light") ? "dark" : "light" %>" class="mode-toggle">
            <%= mode.equals("light") ? "다크 모드로 전환" : "라이트 모드로 전환" %>
        </button>
    </form>
    </header>
    <!-- 메뉴 영역 -->
    <nav>

     	<div class="menu-item"><a href="/CineMap/board/list.jsp?category=%EA%B3%B5%EC%A7%80%EC%82%AC%ED%95%AD&sort=recent">공지사항</a></div>
        <div class="menu-item"><a href="/CineMap/review/reviewlist.jsp">영화 리뷰</a></div>
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
        <script>
        $(function() {
            const searchInput = $("#movieSearch");
            
            // Autocomplete 설정
            searchInput.autocomplete({
    source: function(request, response) {
        console.log("검색어:", request.term);
        $.ajax({
            url: "/CineMap/autocomplete.jsp",
            dataType: "json",
            data: { term: request.term },
            success: function(data) {
                console.log("응답 데이터:", data);
                response(data);
            },
            error: function(xhr, status, error) {
                console.error("오류:", error);
                // 오류 발생 시 빈 결과 반환
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
    </script>
</body>
</html>