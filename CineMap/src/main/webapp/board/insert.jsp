<%@page import="pack.post.PostDTO"%>
<%@page import="pack.post.PostManager"%>
<%@page import="pack.cookie.CookieManager" %>
<%@page import="jakarta.servlet.http.Cookie" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager" />
<jsp:useBean id="dto" class="pack.post.PostDTO" />

<%
    request.setCharacterEncoding("UTF-8");

    int nextNo = postManager.getNextPostNo();
    dto.setNo(nextNo);
    dto.setId(request.getParameter("id"));
    dto.setTitle(request.getParameter("title"));
    dto.setCategory(request.getParameter("category"));
    dto.setContent(request.getParameter("content"));
    dto.setViews(0);
    dto.setLikes(0);

    boolean success = postManager.insertPost(dto);

    // 쿠키 삭제 처리 (작성 완료 시)
    CookieManager cm = CookieManager.getInstance();
    response.addCookie(cm.deleteCookie("savedTitle"));
    response.addCookie(cm.deleteCookie("savedContent"));
    response.addCookie(cm.deleteCookie("savedCategory"));

    if (success) {
        response.sendRedirect("list.jsp");
    } else {
        request.setAttribute("errorMessage", "게시글 등록에 실패했습니다. 다시 시도해주세요.");
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
%>