<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="pack.post.PostManager" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="postManager" class="pack.post.PostManager" />

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

    // 3. 게시글 번호 유효성 확인
    int no = 0;
    try {
        no = Integer.parseInt(request.getParameter("no"));
    } catch (NumberFormatException e) {
        response.sendRedirect("list.jsp");
        return;
    }

    // 4. 세션 likedPosts 리스트 확인
    ArrayList<Integer> likedPosts = (ArrayList<Integer>) session.getAttribute("likedPosts");
    if (likedPosts == null) {
        likedPosts = new ArrayList<>();
    }

    // 5. 추천/취소 처리
    boolean success;
    if (likedPosts.contains(no)) {
        // 이미 추천한 경우 → 취소
        success = postManager.decreaseLikes(no);
        if (success) {
            likedPosts.remove((Integer) no); // Object 타입으로 제거
            session.setAttribute("likedPosts", likedPosts);
        } else {
            request.setAttribute("errorMessage", "추천 취소에 실패했습니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
    } else {
        // 추천하지 않은 경우 → 추천
        success = postManager.increaseLikes(no);
        if (success) {
            likedPosts.add(no);
            session.setAttribute("likedPosts", likedPosts);
        } else {
            request.setAttribute("errorMessage", "추천 처리에 실패했습니다.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
    }

    // 6. 완료 후 게시글 페이지로 이동
    response.sendRedirect("view.jsp?no=" + no);
%>