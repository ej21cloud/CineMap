package pack.theater;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TheaterDTO {
    private int id;
    private String name;
    private String address;
    private double latitude;
    private double longitude;
}