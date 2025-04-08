package pack.index;

import java.util.List;
import org.apache.ibatis.annotations.Select;

import pack.movie.MovieDto;
import pack.post.PostDto;

public interface IndexMapperInter {
    @Select("SELECT no, title FROM posts WHERE category='자유게시판' ORDER BY created_at DESC LIMIT 5")
    List<PostDto> selectRecentFreePosts();
    
    @Select("SELECT no, title FROM posts WHERE category='자유게시판' ORDER BY likes DESC LIMIT 5")
	List<PostDto> selectPopularFreePosts();

    @Select("SELECT no, title FROM posts WHERE category='자유게시판' AND title LIKE CONCAT('%', #{title}, '%') LIMIT 10")
    List<PostDto> selectSearchPosts(String title);

    @Select("SELECT*FROM movie WHERE title LIKE CONCAT('%', #{title}, '%')")
    List<MovieDto> selectSearchMovie(String title);

    @Select("SELECT id, title, image_url FROM movie ORDER BY id DESC LIMIT 12")
	List<MovieDto> selectMovieSlides();
}