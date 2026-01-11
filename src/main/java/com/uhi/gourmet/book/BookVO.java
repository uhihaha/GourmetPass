package com.uhi.gourmet.book;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookVO {
    private int book_id;          // 예약 고유 ID
    private String user_id;       // 예약자 ID (FK)
    private int store_id;         // 가게 고유 ID (FK)
    private Date book_date;       // 방문 예정 날짜 및 시간
    private int people_cnt;       // 예약 인원
    private Integer book_price;   // 예약 관련 금액 (Nullable)
    private String book_status;    // 예약 상태 (RESERVED, CANCELLED 등)
}