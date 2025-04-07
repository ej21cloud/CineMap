<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.post.PostBean" %>
<%@ page import="pack.post.PostDao" %>

<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="bean" class="pack.post.PostBean" />
<jsp:setProperty name="bean" property="*" />

<jsp:useBean id="dao" class="pack.post.PostDao" />

<%
    boolean success = dao.updatePost(bean);  // DTO 대신 bean 사용
    if (success) {
        response.sendRedirect("view.jsp?no=" + bean.getNo());
    } else {
        request.setAttribute("errorMessage", "게시글 수정에 실패했습니다.");
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
%>