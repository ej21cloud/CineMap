<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.cookie.CookieManager" %>
<%@ page import="jakarta.servlet.http.Cookie" %>

<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="bean" class="pack.post.PostBean" />
<jsp:setProperty name="bean" property="*" />

<jsp:useBean id="dao" class="pack.post.PostDao" />

<%
    // 추가 설정 (폼에 없던 값들)
    bean.setViews(0);
    bean.setLikes(0);

    boolean success = dao.insertPost(bean);

    // 쿠키 삭제 처리
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