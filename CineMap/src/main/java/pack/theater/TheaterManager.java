package pack.theater;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TheaterManager {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private DataSource ds;

    public TheaterManager() {
        try {
            Context context = new InitialContext();
            ds = (DataSource) context.lookup("java:comp/env/jdbc_maria");
        } catch (Exception e) {
            System.out.println("DataSource 연결 실패: " + e.getMessage());
        }
    }
    
    // 이름 일부로 검색
    public ArrayList<TheaterDTO> getTheatersByName(String keyword) {
        ArrayList<TheaterDTO> list = new ArrayList<>();
        String sql;

        // "기타"인 경우 주요 브랜드 제외
        if ("기타".equals(keyword)) {
            sql = "SELECT * FROM theaters WHERE name NOT LIKE '%CGV%' AND name NOT LIKE '%메가박스%' AND name NOT LIKE '%롯데시네마%' ORDER BY name ASC";
        } else {
            sql = "SELECT * FROM theaters WHERE name LIKE ? ORDER BY name ASC";
        }

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);

            if (!"기타".equals(keyword)) {
                pstmt.setString(1, "%" + keyword + "%");
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                TheaterDTO dto = new TheaterDTO();
                dto.setId(rs.getInt("id"));
                dto.setName(rs.getString("name"));
                dto.setAddress(rs.getString("address"));
                dto.setLatitude(rs.getDouble("latitude"));
                dto.setLongitude(rs.getDouble("longitude"));
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getTheatersByName 오류: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return list;
    }
}