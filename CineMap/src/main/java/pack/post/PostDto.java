package pack.post;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;

import lombok.Data;

@Data
public class PostDto {
    private int no;
    private String id;
    private String category;
    private String title;
    private String content;
    private java.sql.Timestamp createdAt;
    private int views;
    private int likes;
    private String nickname;

    // 날짜 변환
    public String getDisplayDate() {
        LocalDate createdDate = createdAt.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate today = LocalDate.now();

        if (createdDate.equals(today)) {
            return new SimpleDateFormat("HH:mm").format(createdAt);
        } else {
            return new SimpleDateFormat("yy.MM.dd").format(createdAt);
        }
    }

}
