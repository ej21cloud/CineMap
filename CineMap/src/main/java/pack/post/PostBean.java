package pack.post;

import lombok.Data;

@Data
public class PostBean {
    private int no;
    private String id;
    private String category;
    private String title;
    private String content;
    private java.sql.Timestamp createdAt;
    private int views;
    private int likes;
    private String nickname;
}
