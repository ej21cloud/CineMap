<%@ page import="pack.cookie.CookieManager" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    String name = request.getParameter("name");
    String value = request.getParameter("value");

    try {
        CookieManager cm = CookieManager.getInstance();
        Cookie cookie = cm.updateCookie(name, value);
        response.addCookie(cookie);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>