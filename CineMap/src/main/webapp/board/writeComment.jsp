<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="pack.board.CommentDto"%>
<%@page import="pack.board.CommentManager"%>
<%
request.setCharacterEncoding("utf-8");

    String loginId = (String) session.getAttribute("idKey");
    if (loginId == null) {
        out.println("<script>alert('로그인 후 작성해주세요.'); history.back();</script>");
        return;
    }

    int postNo = Integer.parseInt(request.getParameter("postNo"));
    String content = request.getParameter("content");

    if (content == null || content.trim().isEmpty()) {
        out.println("<script>alert('내용을 입력하세요.'); history.back();</script>");
        return;
    }

    CommentManager commentManager = new CommentManager();
    int commentNo = commentManager.getNextPostNo();

    CommentDto dto = new CommentDto();
    dto.setNo(commentNo);
    dto.setPost_no(postNo);
    dto.setId(loginId);
    dto.setContent(content);
    dto.setGno(postNo);
    dto.setOno(0);
    dto.setNested(0);

    commentManager.addComment(dto);
    response.sendRedirect("view.jsp?no=" + postNo);
%>