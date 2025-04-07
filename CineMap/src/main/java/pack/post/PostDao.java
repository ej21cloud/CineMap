package pack.post;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import pack.business.SqlMapperInter;
import pack.mybatis.SqlMapConfig;

public class PostDao {
    private SqlSessionFactory factory = SqlMapConfig.getSqlSession();

    private String getOrderByClause(String sort) {
        return switch (sort) {
            case "views" -> "views DESC";
            case "likes" -> "likes DESC";
            default -> "created_at DESC";
        };
    }
    
    // 게시판 전체 읽기
    public List<PostDto> getAllPosts() {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getAllPosts();
        }
    }
    
    // 게시글 1개 조회
    public PostDto getPostByNo(int no) {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getPostByNo(no);
        }
    }

    // 게시글 작성
    public boolean insertPost(PostBean bean) {
        try (SqlSession session = factory.openSession()) {
            boolean result = session.getMapper(SqlMapperInter.class).insertPost(bean);
            if (result) session.commit();
            return result;
        }
    }
    
    // 게시글 수정
    public boolean updatePost(PostBean bean) {
        try (SqlSession session = factory.openSession()) {
            boolean result = session.getMapper(SqlMapperInter.class).updatePost(bean);
            if (result) session.commit();
            return result;
        }
    }

    // 게시글 삭제
    public boolean deletePost(int no) {
        try (SqlSession session = factory.openSession()) {
            SqlMapperInter mapper = session.getMapper(SqlMapperInter.class);
            mapper.deleteCommentsByPostNo(no);
            boolean result = mapper.deletePost(no);
            if (result) session.commit();
            return result;
        }
    }
    


    // 카테고리별 게시글 조회
    public List<PostDto> getPostsByCategory(String category) {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getPostsByCategory(category);
        }
    }

    // 전체 게시글 수
    public int getTotalPostCount() {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getTotalPostCount();
        }
    }

    // 카테고리 별 게시글 수
    public int getCategoryPostCount(String category) {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getCategoryPostCount(category);
        }
    }
    
    // 추천수 증가
    public boolean increaseLikes(int no) {
        try (SqlSession session = factory.openSession()) {
            boolean result = session.getMapper(SqlMapperInter.class).increaseLikes(no);
            if (result) session.commit();
            return result;
        }
    }

    // 추천 취소
    public boolean decreaseLikes(int no) {
        try (SqlSession session = factory.openSession()) {
            boolean result = session.getMapper(SqlMapperInter.class).decreaseLikes(no);
            if (result) session.commit();
            return result;
        }
    }

    // 조회수 증가
    public void increaseViews(int no) {
        try (SqlSession session = factory.openSession()) {
            session.getMapper(SqlMapperInter.class).increaseViews(no);
            session.commit();
        }
    }

    // 전체 게시글 페이징 조회
    public List<PostDto> getPostsByPage(int start, int pageSize) {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getPostsByPage(start, pageSize);
        }
    }

    // 카테고리 별 페이징 조회
    public List<PostDto> getPostsByCategoryPage(String category, int start, int pageSize) {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).getPostsByCategoryPage(category, start, pageSize);
        }
    }

    // 전체 게시글 정렬, 페이징
    public List<PostDto> getPostsByPageSorted(int start, int pageSize, String sort) {
        try (SqlSession session = factory.openSession()) {
            String orderBy = getOrderByClause(sort);
            return session.getMapper(SqlMapperInter.class).getPostsByPageSorted(start, pageSize, orderBy);
        }
    }

    // 카테고리 정렬, 페이징
    public List<PostDto> getPostsByCategoryPageSorted(String category, int start, int pageSize, String sort) {
        try (SqlSession session = factory.openSession()) {
            String orderBy = getOrderByClause(sort);
            return session.getMapper(SqlMapperInter.class).getPostsByCategoryPageSorted(category, start, pageSize, orderBy);
        }
    }
    
    // 검색된 게시글 리스트 가져오기
    public List<PostDto> searchPosts(String type, String keyword, int start, int size, String sort) {
        try (SqlSession session = factory.openSession()) {
            String orderBy = getOrderByClause(sort);
            return session.getMapper(SqlMapperInter.class).searchPosts(type, keyword, start, size, orderBy);
        }
    }

    // 검색된 게시글 수 가져오기
    public int countSearchPosts(String type, String keyword) {
        try (SqlSession session = factory.openSession()) {
            return session.getMapper(SqlMapperInter.class).countSearchPosts(type, keyword);
        }
    }
}