<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="pack.post.PostDTO" %>
<%@ page import="pack.post.PostManager" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:useBean id="postManager" class="pack.post.PostManager" />

<%
    int no = Integer.parseInt(request.getParameter("no"));
    PostDTO dto = postManager.getPostByNo(no);
    request.setAttribute("dto", dto);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="../css/write.css">
</head>
<body>
<div class="container">
<h2>게시글 수정</h2>

<form action="update.jsp" method="post">
    <input type="hidden" name="no" value="${dto.no}" />
    <input type="hidden" name="id" value="${dto.id}" />

    작성자: <input type="text" name="nickname" value="${dto.nickname}" readonly /><br/>

    제목: <input type="text" name="title" value="${dto.title}" required /><br/>

    카테고리:
    <select name="category" required>
        <option value="스포" ${dto.category == '스포' ? 'selected' : ''}>스포</option>
        <option value="개봉예정작" ${dto.category == '개봉예정작' ? 'selected' : ''}>개봉예정작</option>
        <option value="공지사항" ${dto.category == '공지사항' ? 'selected' : ''}>공지사항</option>
        <option value="자유게시판" ${dto.category == '자유게시판' ? 'selected' : ''}>자유게시판</option>
    </select><br/>

    내용:<br/>
    <textarea name="content" rows="10" cols="50" required>${dto.content}</textarea><br/>

    <input type="submit" value="수정 완료" />
    <input type="button" value="수정 취소" onclick="location.href='view.jsp?no=${dto.no}'" />
</form>
</div>
</body>
</html>