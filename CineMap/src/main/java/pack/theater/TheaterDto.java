package pack.theater;

import lombok.Data;

@Data
public class TheaterDto {
    private int id;
    private String name, address;
    private double latitude, longitude;
    
}