package pack.index;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import pack.movie.MovieDto;
import pack.mybatis.SqlMapConfig;
import pack.post.PostDto;

import java.io.IOException;
import java.util.List;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {
    private SqlSessionFactory sqlSessionFactory;

    @Override
    public void init() {
        sqlSessionFactory = SqlMapConfig.getSqlSession();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            IndexMapperInter mapper = session.getMapper(IndexMapperInter.class);
            List<PostDto> recentPosts = mapper.selectRecentFreePosts();
            List<PostDto> popularPosts = mapper.selectPopularFreePosts();
            
            List<MovieDto> movieSlides = mapper.selectMovieSlides();
            request.setAttribute("movieSlides", movieSlides);
            
            // 현재 표시할 영화 그룹 인덱스 (0부터 시작)
            int currentGroupIndex = 0;
            
            // 세션에 저장된 인덱스가 있으면 가져옴
            HttpSession session2 = request.getSession();
            Integer savedIndex = (Integer) session2.getAttribute("currentMovieGroup");
            if (savedIndex != null) {
                currentGroupIndex = savedIndex;
            }
            
            // 다음 그룹 인덱스 계산 (순환)
            int nextGroupIndex = (currentGroupIndex + 1) % 4; // 12개 영화 / 3 = 4개 그룹
            session2.setAttribute("currentMovieGroup", nextGroupIndex);
            
            // 현재 표시할 영화 3개 선택
            int startIdx = currentGroupIndex * 3;
            List<MovieDto> currentMovies = movieSlides.subList(startIdx, startIdx + 3);
            request.setAttribute("currentMovies", currentMovies);
            
            request.setAttribute("recentPosts", recentPosts);
            request.setAttribute("popularPosts", popularPosts);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}