package pack.theater;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import pack.business.SqlMapperInter;
import pack.mybatis.SqlMapConfig;

public class TheaterDao {
    private SqlSessionFactory factory = SqlMapConfig.getSqlSession();

    // 영화관 이름(브랜드)으로 검색된 목록 반환 메소드
    public List<TheaterDto> getTheatersByName(String keyword) {
        SqlSession sqlSession = factory.openSession();
        List<TheaterDto> list = null;

        try {
            SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
            // "기타" 브랜드일 경우 제외 조건 쿼리 실행, 그 외에는 LIKE 검색
            if ("기타".equals(keyword)) {
                list = inter.getOtherTheaters();
            } else {
                list = inter.getTheatersByName("%" + keyword + "%");
            }
        } catch (Exception e) {
            System.out.println("getTheatersByName 오류: " + e);
        } finally {
            sqlSession.close();
        }

        return list;
    }
}
