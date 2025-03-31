<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>영화관 메뉴</title>
  <!-- 꾸미는 것과 예외로 필수 스타일 이라 확인하고 css 정리하시라고 분리 안해뒀습니다 -->
  <style>
    .navbar {
    display: flex;
    justify-content: center;
    margin-top: 20px;
  	}
  
    .nav-item {
      position: relative;
      display: inline-block;
      cursor: pointer;
    }

    .nav-item:hover .dropdown-content {
      display: flex;
    }

    .dropdown-content {
      display: none;
      position: absolute;
      left:-100px;
      white-space: nowrap;
    }
    
    .sub-item {
      padding: 5px;
    }
  </style>
</head>
<body>

  <div class="navbar">
    <div class="nav-item">영화관
      <div class="dropdown-content">
        <div class="sub-item">
          <a href="theaterGroup.jsp?name=CGV">CGV</a>
        </div>
        <div class="sub-item">
          <a href="theaterGroup.jsp?name=메가박스">메가박스</a>
        </div>
        <div class="sub-item">
          <a href="theaterGroup.jsp?name=롯데시네마">롯데시네마</a>
        </div>
        <div class="sub-item">
          <a href="theaterGroup.jsp?name=기타">그 외</a>
        </div>
      </div>
    </div>
  </div>

</body>
</html>