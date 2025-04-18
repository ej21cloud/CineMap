<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
String id = (String) session.getAttribute("idKey");

if (id == null) {
    // 로그인 정보가 없을 경우
    out.println("<script>alert('로그인 정보가 없습니다.'); location.href='login.jsp';</script>");
    return;
}

try {
    boolean b = memberManager.memberDelete(id);

    if (b) {
        // 회원 탈퇴가 성공하면 세션을 무효화하고 로그아웃 처리
        session.invalidate(); // 세션 무효화

        // 성공 메시지와 함께 메인 페이지로 리디렉션
%>
        <script>
            alert("회원 탈퇴 성공");
            location.href = "../index.jsp";  // 메인 페이지로 리디렉션
        </script>
<%
    } else {
        // 회원 탈퇴 실패 시
%>
        <script>
            alert("삭제 실패\n 관리자에게 문의 바랍니다.");
            history.back();  // 이전 페이지로 돌아감
        </script>
<%
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('서버 오류로 인한 실패. 다시 시도해주세요.'); location.href='../index.jsp';</script>");
}
%>
