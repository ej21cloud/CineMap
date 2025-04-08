<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="pack.board.CommentManager"%>
<%
    request.setCharacterEncoding("utf-8");

    String loginId = (String) session.getAttribute("idKey");
    if (loginId == null) {
        out.println("<script>alert('로그인 후 이용해주세요.'); history.back();</script>");
        return;
    }

    int commentNo = Integer.parseInt(request.getParameter("commentNo"));
    int postNo = Integer.parseInt(request.getParameter("postNo"));
    String content = request.getParameter("content");

    if (content == null || content.trim().isEmpty()) {
        out.println("<script>alert('내용을 입력하세요.'); history.back();</script>");
        return;
    }

    CommentManager manager = new CommentManager();
    manager.updateComment(commentNo, content);
    response.sendRedirect("view.jsp?no=" + postNo);
%>
