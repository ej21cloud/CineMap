<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pack.board.CommentManager" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 로그인 여부 확인
    String loginId = (String) session.getAttribute("idKey");
    if (loginId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. POST 방식만 허용
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST 방식만 허용됩니다.");
        return;
    }

    // 3. 파라미터 유효성 확인
    int commentNo = 0;
    int postNo = 0;
    try {
        commentNo = Integer.parseInt(request.getParameter("commentNo"));
        postNo = Integer.parseInt(request.getParameter("postNo"));
    } catch (Exception e) {
        response.sendRedirect("list.jsp");
        return;
    }

    // 4. 중복 방지를 위한 likedComments 세션 확인
    ArrayList<Integer> likedComments = (ArrayList<Integer>) session.getAttribute("likedComments");
    if (likedComments == null) {
        likedComments = new ArrayList<>();
    }

    // 5. 좋아요 처리
    if (!likedComments.contains(commentNo)) {
        CommentManager commentManager = new CommentManager();
        boolean success = commentManager.likeComments(commentNo);
        if (success) {
            likedComments.add(commentNo);
            session.setAttribute("likedComments", likedComments);
        } else {
            request.setAttribute("errorMessage", "댓글 추천 처리에 실패했습니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
    }

    // 6. 다시 게시글로 이동
    response.sendRedirect("view.jsp?no=" + postNo);
%>