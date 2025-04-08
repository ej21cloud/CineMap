<%@ page import="pack.cookie.CookieManager" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    CookieManager cm = CookieManager.getInstance();
    response.addCookie(cm.deleteCookie("savedTitle"));
    response.addCookie(cm.deleteCookie("savedContent"));
    response.addCookie(cm.deleteCookie("savedCategory"));

    response.sendRedirect("list.jsp");
%>