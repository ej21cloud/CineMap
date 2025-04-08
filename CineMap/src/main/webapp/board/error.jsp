<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오류 발생</title>
<style>
    body { font-family: Arial; background-color: #f8f8f8; text-align: center; padding-top: 100px; }
    .error-box {
        display: inline-block; padding: 30px; background: #fff;
        border: 1px solid #ccc; box-shadow: 2px 2px 10px rgba(0,0,0,0.1);
    }
</style>
</head>
<body>

<div class="error-box">
    <h2>⚠ 오류 발생</h2>
    <p><%= request.getAttribute("errorMessage") %></p>
    <br/>
    <a href="javascript:history.back();">← 이전 페이지로 돌아가기</a>
</div>

</body>
</html>