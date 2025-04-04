<%@page import="java.time.ZoneId"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.time.LocalDate"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="pack.post.PostDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="postManager" class="pack.post.PostManager" />
<jsp:useBean id="dto" class="pack.post.PostDTO" />

<%
    String category = request.getParameter("category");
    if (category == null) category = "";

    String sort = request.getParameter("sort");
    if (sort == null || sort.isEmpty()) sort = "recent";

    int pageSize = 5;
    int pageno = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) pageno = Integer.parseInt(pageParam);

    int start = (pageno - 1) * pageSize;

    String type = request.getParameter("type");
    String keyword = request.getParameter("keyword");

    ArrayList<PostDTO> list;
    int totalPosts;

    if (type != null && keyword != null && !type.isEmpty() && !keyword.isEmpty()) {
        list = postManager.searchPosts(type, keyword, start, pageSize, "recent");
        totalPosts = postManager.countSearchPosts(type, keyword);
    } else if (!category.isEmpty()) {
        list = postManager.getPostsByCategoryPageSorted(category, start, pageSize, sort);
        totalPosts = postManager.getCategoryPostCount(category);
    } else {
        list = postManager.getPostsByPageSorted(start, pageSize, sort);
        totalPosts = postManager.getTotalPostCount();
    }

    int totalPages = (int)Math.ceil(totalPosts / (double)pageSize);
    if (totalPages == 0) totalPages = 1; // 최소 1페이지 보장

    request.setAttribute("list", list);
    request.setAttribute("totalPosts", totalPosts);
    request.setAttribute("pageno", pageno);
    request.setAttribute("totalPages", totalPages);

    // 파라미터 문자열 조립 (JSTL용)
    StringBuilder paramBuilder = new StringBuilder();
    if (category != null && !category.isEmpty()) paramBuilder.append("&category=").append(category);
    if (sort != null && !sort.isEmpty()) paramBuilder.append("&sort=").append(sort);
    if (type != null && !type.isEmpty() && keyword != null && !keyword.isEmpty()) {
        paramBuilder.append("&type=").append(type).append("&keyword=").append(keyword);
    }
    request.setAttribute("paramString", paramBuilder.toString());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <link rel="stylesheet" type="text/css" href="../css/board1.css">
</head>
<body>

<h2>게시판</h2>

<!-- 카테고리 필터 -->
<div class="category-menu">
    <a href="list.jsp?sort=${param.sort}" class="${empty param.category ? 'active' : ''}">전체</a>
    <a href="list.jsp?category=스포&sort=${param.sort}" class="${param.category == '스포' ? 'active' : ''}">스포</a>
    <a href="list.jsp?category=개봉예정작&sort=${param.sort}" class="${param.category == '개봉예정작' ? 'active' : ''}">개봉예정작</a>
    <a href="list.jsp?category=공지사항&sort=${param.sort}" class="${param.category == '공지사항' ? 'active' : ''}">공지사항</a>
    <a href="list.jsp?category=자유게시판&sort=${param.sort}" class="${param.category == '자유게시판' ? 'active' : ''}">자유게시판</a>
</div>

<!-- 정렬 + 검색 -->
<div style="display: flex; justify-content: space-between; align-items: center; margin: 15px 0;">
    <!-- 정렬 -->
    <form method="get" action="list.jsp" style="display: flex; align-items: center; gap: 8px;">
        <label for="sort">정렬:</label>
        <select name="sort" id="sort" onchange="this.form.submit()">
            <option value="recent" ${param.sort == 'recent' || empty param.sort ? 'selected' : ''}>최신순</option>
            <option value="views" ${param.sort == 'views' ? 'selected' : ''}>조회순</option>
            <option value="likes" ${param.sort == 'likes' ? 'selected' : ''}>추천순</option>
        </select>
        <input type="hidden" name="category" value="${param.category}" />
    </form>

    <!-- 검색 -->
    <form action="list.jsp" method="get" style="display: flex; align-items: center; gap: 8px;">
        <select name="type" id="type">
            <option value="title" <c:if test="${param.type == 'title'}">selected</c:if>>제목</option>
            <option value="nickname" <c:if test="${param.type == 'nickname'}">selected</c:if>>작성자</option>
            <option value="content" <c:if test="${param.type == 'content'}">selected</c:if>>내용</option>
        </select>
        <input type="text" name="keyword" placeholder="검색어 입력" value="${param.keyword}" />
    	<button type="submit" style="display: flex; align-items: center;">
        검색<img src="../images/search.png" alt="검색 아이콘" style="width: 20px; height: 20px;" />
    	</button>
    </form>
</div>

<!-- 게시글 목록 -->
<table>
    <tr>
        <th style="width: 5%;">번호</th>
        <th style="width: 54%;">제목</th>
        <th style="width: 15%;">작성자</th>
        <th style="width: 10%;">작성일</th>
        <th style="width: 8%;">조회수</th>
        <th style="width: 8%;">추천수</th>
    </tr>
    <c:forEach var="dto" items="${list}">
        <%
        Date createdAt = (Date) pageContext.getAttribute("dto", PageContext.PAGE_SCOPE).getClass().getMethod("getCreatedAt").invoke(pageContext.getAttribute("dto"));
        LocalDate createdDate = createdAt.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate today = LocalDate.now();

        String displayDate;
        if (createdDate.equals(today)) {
            displayDate = new SimpleDateFormat("HH:mm").format(createdAt);
        } else {
            displayDate = new SimpleDateFormat("yy.MM.dd").format(createdAt);
        }
    	%>
        <tr>
            <td style="width: 5%;">${dto.no}</td>
            <td style="width: 54%;"><a href="view.jsp?no=${dto.no}">${dto.title}</a></td>
            <td style="width: 15%;">${dto.nickname}</td>
            <td style="width: 10%;"><%= displayDate %></td>
            <td style="width: 8%;">${dto.views}</td>
            <td style="width: 8%;">${dto.likes}</td>
        </tr>
    </c:forEach>
</table>

<!-- 페이지네이션 -->
<div style="display: flex; justify-content: space-between; align-items: center; margin: 20px 0;">
    <div class="pagination" style="flex: 1; text-align: center;">
        <!-- 이전 버튼 -->
        <c:choose>
            <c:when test="${pageno > 1}">
                <a href="list.jsp?page=${pageno - 1}${paramString}">❮</a>
            </c:when>
            <c:otherwise>
                <span class="disabled">❮</span>
            </c:otherwise>
        </c:choose>

        <!-- 페이지 번호들 -->
        <c:forEach var="i" begin="1" end="${totalPages}">
            <a href="list.jsp?page=${i}${paramString}" class="${i == pageno ? 'active' : ''}">${i}</a>
        </c:forEach>

        <!-- 다음 버튼 -->
        <c:choose>
            <c:when test="${pageno < totalPages}">
                <a href="list.jsp?page=${pageno + 1}${paramString}">❯</a>
            </c:when>
            <c:otherwise>
                <span class="disabled">❯</span>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 글쓰기 버튼 -->
    <form action="write.jsp" method="get" style="margin-left: 20px;">
        <button type="submit" style="display: flex; align-items: center;">
        글쓰기<img src="../images/pencil.png" alt="글쓰기 아이콘" style="width: 20px; height: 20px;" />
    </button>
    </form>
</div>

</body>
</html>