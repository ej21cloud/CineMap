<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="pack.board.CommentDTO"%>
<%@page import="pack.board.CommentManager"%>
<%
    String loginId = (String) session.getAttribute("idKey");
    if (loginId == null) {
        out.println("<script>alert('로그인 후 이용해주세요.'); history.back();</script>");
        return;
    }

    int commentNo = Integer.parseInt(request.getParameter("commentNo"));
    int postNo = Integer.parseInt(request.getParameter("postNo"));

    CommentManager manager = new CommentManager();
    CommentDTO dto = manager.getCommentByNo(commentNo);

    if (dto == null || !dto.getId().equals(loginId)) {
        out.println("<script>alert('권한이 없습니다.'); history.back();</script>");
        return;
    }

    manager.deleteComment(commentNo);
    response.sendRedirect("view.jsp?no=" + postNo);
%>