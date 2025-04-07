package pack.board;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentDto {
    private int no;
    private int post_no;
    private String id;
    private String content;
    private java.sql.Timestamp createdAt;
    private int likes;
    private int gno;
    private int ono;
    private int nested;
    private String nickname;
}