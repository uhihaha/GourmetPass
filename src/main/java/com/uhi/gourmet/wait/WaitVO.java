package com.uhi.gourmet.wait;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WaitVO {
    private int wait_id;          // 웨이팅 고유 ID
    private String user_id;       // 신청자 ID (FK)
    private int store_id;         // 가게 고유 ID (FK)
    private int people_cnt;       // 방문 인원
    private int wait_num;         // 대기 번호
    private String wait_status;   // 대기 상태 (WAITING, ADMITTED, CANCELLED 등)
    private Date wait_date;       // 신청 일시
}