<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="pack.board.CommentDto"%>
<%@page import="pack.board.CommentManager"%>
<%
int commentNo = Integer.parseInt(request.getParameter("commentNo"));
    String loginId = (String) session.getAttribute("idKey");

    CommentManager manager = new CommentManager();
    CommentDto dto = manager.getCommentByNo(commentNo);

    if (dto == null || !dto.getId().equals(loginId)) {
        out.println("<script>alert('권한이 없습니다.'); history.back();</script>");
        return;
    }
    
    System.out.println("editComment.jsp commentNo: " + commentNo);
    System.out.println("dto: " + dto);
%>

<form action="updateComment.jsp" method="post">
    <input type="hidden" name="commentNo" value="<%= commentNo %>">
    <input type="hidden" name="postNo" value="<%= dto.getPost_no() %>">
    <textarea name="content" style="width:100%; height:60px;"><%= dto.getContent() %></textarea><br/>
    <input type="submit" value="수정 완료">
</form>