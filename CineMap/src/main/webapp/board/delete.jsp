<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="dao" class="pack.post.PostDao" />

<%
    int no = Integer.parseInt(request.getParameter("no"));
    boolean success = dao.deletePost(no);

    if (success) {
        response.sendRedirect("list.jsp");
    } else {
    	request.setAttribute("errorMessage", "게시글 삭제에 실패했습니다.");
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
%>