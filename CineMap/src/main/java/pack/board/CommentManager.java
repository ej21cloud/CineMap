package pack.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class CommentManager {
    // DB 관련 객체 선언
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private DataSource ds;

    // 생성자: DataSource 초기화 (JNDI로 DB 연결 설정)
    public CommentManager() {
        try {
            Context context = new InitialContext();
            ds = (DataSource) context.lookup("java:comp/env/jdbc_maria");
        } catch (Exception e) {
            System.out.println("DataSource 연결 실패: " + e.getMessage());
        }
    }

    // 특정 게시글 번호(no)에 해당하는 모든 댓글을 가져오는 메서드
    public ArrayList<CommentDto> getCommentsByPost(int no) {
        ArrayList<CommentDto> list = new ArrayList<>();
        String sql = "SELECT c.*, m.nickname FROM comments c JOIN member m ON c.id = m.id WHERE c.post_no = ? ORDER BY c.gno DESC, c.ono ASC";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, no);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CommentDto dto = new CommentDto();
                dto.setNo(rs.getInt("no"));
                dto.setPost_no(rs.getInt("post_no"));
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setLikes(rs.getInt("likes"));
                dto.setGno(rs.getInt("gno"));
                dto.setOno(rs.getInt("ono"));
                dto.setNested(rs.getInt("nested"));
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getCommentsByPost err: " + e);
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return list;
    }

    // 댓글 추가 메서드 (likes는 기본값 0으로 설정)
    public boolean addComment(CommentDto comment) {
        String sql = "INSERT INTO comments (no, post_no, id, content, created_at, likes, gno, ono, nested) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?)";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, comment.getNo());
            pstmt.setInt(2, comment.getPost_no());
            pstmt.setString(3, comment.getId());
            pstmt.setString(4, comment.getContent());
            pstmt.setInt(5, 0); // likes 기본값
            pstmt.setInt(6, comment.getGno());
            pstmt.setInt(7, comment.getOno());
            pstmt.setInt(8, comment.getNested());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("addComment err: " + e);
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return false;
    }

    // 다음 댓글 번호(no)를 얻기 위한 메서드
    public int getNextPostNo() {
        int nextNo = 1;
        String sql = "SELECT IFNULL(MAX(no), 0) + 1 AS nextNo FROM comments";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                nextNo = rs.getInt("nextNo");
            }
        } catch (Exception e) {
            System.out.println("getNextPostNo err: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return nextNo;
    }

    // 댓글 삭제 메서드
    public void deleteComment(int commentNo) {
        String sql = "DELETE FROM comments WHERE no = ?";
        try (Connection conn = ds.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, commentNo);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("deleteComment err: " + e);
        }
    }

    // 댓글 수정 메서드
    public boolean updateComment(int commentNo, String content) {
        boolean result = false;
        String sql = "UPDATE comments SET content = ? WHERE no = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, content);
            pstmt.setInt(2, commentNo);
            result = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateComment err: " + e);
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // 댓글 좋아요 증가 메서드
    public boolean likeComments(int commentNo) {
        String sql = "UPDATE comments SET likes = likes + 1 WHERE no = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentNo);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("likeComment err: " + e);
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return false;
    }

    // 댓글 번호(no)로 댓글 정보를 가져오는 메서드
    public CommentDto getCommentByNo(int commentNo) {
        CommentDto dto = null;
        String sql = "SELECT c.*, m.nickname FROM comments c JOIN member m ON c.id = m.id WHERE c.no = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new CommentDto();
                dto.setNo(rs.getInt("no"));
                dto.setPost_no(rs.getInt("post_no"));
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setLikes(rs.getInt("likes"));
                dto.setGno(rs.getInt("gno"));
                dto.setOno(rs.getInt("ono"));
                dto.setNested(rs.getInt("nested"));
            }
        } catch (Exception e) {
            System.out.println("getCommentByNo err: " + e);
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return dto;
    }

    // 간편한 댓글 추가 메서드 (매개변수 단순화)
    public void addComment(int postNo, String loginId, String content) {
        int nextNo = getNextPostNo();
        String sql = "INSERT INTO comments (no, post_no, id, content, created_at, likes, gno, ono, nested) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?)";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, nextNo);
            pstmt.setInt(2, postNo);
            pstmt.setString(3, loginId);
            pstmt.setString(4, content);
            pstmt.setInt(5, 0); // 기본 likes
            pstmt.setInt(6, postNo); // gno = 게시글 번호
            pstmt.setInt(7, 0);      // ono 기본값
            pstmt.setInt(8, 0);      // nested 기본값
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("addComment err: " + e);
        } finally {
            try { if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
    }

    // 회원 정보 가져오기 (id, nickname만)
    public CommentDto getMember(String id) {
        CommentDto dto = null;
        String sql = "SELECT id, nickname FROM member WHERE id = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new CommentDto();
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname"));
            }
        } catch (Exception e) {
            System.out.println("getMember err: " + e);
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return dto;
    }
}