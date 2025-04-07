package pack.business;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import pack.post.PostBean;
import pack.post.PostDto;
import pack.theater.TheaterDto;

public interface SqlMapperInter {
    @Select("SELECT * FROM theaters WHERE name LIKE #{name} ORDER BY name ASC")
    List<TheaterDto> getTheatersByName(String name);

    @Select("SELECT * FROM theaters WHERE name NOT LIKE '%CGV%' AND name NOT LIKE '%메가박스%' AND name NOT LIKE '%롯데시네마%' ORDER BY name ASC")
    List<TheaterDto> getOtherTheaters();
    
    
    @Select("SELECT * FROM posts ORDER BY created_at DESC")
    List<PostDto> getAllPosts();

    @Select("SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id WHERE p.no = #{no}")
    PostDto getPostByNo(int no);

    @Insert("INSERT INTO posts (id, category, title, content, created_at, views, likes) " +
            "VALUES (#{id}, #{category}, #{title}, #{content}, NOW(), #{views}, #{likes})")
    boolean insertPost(PostBean bean);

    @Update("UPDATE posts SET title = #{title}, category = #{category}, content = #{content} WHERE no = #{no}")
    boolean updatePost(PostBean bean);

    @Delete("DELETE FROM posts WHERE no = #{no}")
    boolean deletePost(int no);

    @Delete("DELETE FROM comments WHERE post_no = #{no}")
    void deleteCommentsByPostNo(int no);

    @Select("SELECT * FROM posts WHERE category = #{category} ORDER BY created_at DESC")
    List<PostDto> getPostsByCategory(String category);

    @Select("SELECT COUNT(*) FROM posts")
    int getTotalPostCount();

    @Select("SELECT COUNT(*) FROM posts WHERE category = #{category}")
    int getCategoryPostCount(String category);

    @Update("UPDATE posts SET likes = likes + 1 WHERE no = #{no}")
    boolean increaseLikes(int no);

    @Update("UPDATE posts SET likes = likes - 1 WHERE no = #{no} AND likes > 0")
    boolean decreaseLikes(int no);

    @Update("UPDATE posts SET views = views + 1 WHERE no = #{no}")
    void increaseViews(int no);

    // 페이징 + 닉네임 포함
    @Select("SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id " +
            "ORDER BY p.created_at DESC LIMIT #{start}, #{pageSize}")
    List<PostDto> getPostsByPage(@Param("start") int start, @Param("pageSize") int pageSize);

    @Select("SELECT * FROM posts WHERE category = #{category} ORDER BY created_at DESC LIMIT #{start}, #{pageSize}")
    List<PostDto> getPostsByCategoryPage(@Param("category") String category, @Param("start") int start, @Param("pageSize") int pageSize);

    // 정렬 옵션 포함 게시글 조회
    @Select("""
        SELECT p.*, m.nickname FROM posts p
        JOIN member m ON p.id = m.id
        ORDER BY ${orderBy} LIMIT #{start}, #{pageSize}
    """)
    List<PostDto> getPostsByPageSorted(@Param("start") int start, @Param("pageSize") int pageSize, @Param("orderBy") String orderBy);

    @Select("""
        SELECT p.*, m.nickname FROM posts p
        JOIN member m ON p.id = m.id
        WHERE p.category = #{category}
        ORDER BY ${orderBy} LIMIT #{start}, #{pageSize}
    """)
    List<PostDto> getPostsByCategoryPageSorted(@Param("category") String category, @Param("start") int start, @Param("pageSize") int pageSize, @Param("orderBy") String orderBy);
    
    // xml 문법은 어노테이션에서 작동 X (PostMapper.xml 사용)
    List<PostDto> searchPosts(@Param("type") String type, @Param("keyword") String keyword,
            @Param("start") int start, @Param("size") int size,
            @Param("orderBy") String orderBy);
    
    // xml 문법은 어노테이션에서 작동 X (PostMapper.xml 사용)
    int countSearchPosts(@Param("type") String type, @Param("keyword") String keyword);
}
