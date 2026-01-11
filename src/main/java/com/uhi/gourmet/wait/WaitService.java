package com.uhi.gourmet.wait;

import java.util.List;

public interface WaitService {
    // 웨이팅 등록
    void register_wait(WaitVO vo);
    
    // 현재 매장의 총 대기 팀 수 조회
    int get_current_wait_count(int store_id);
    
    // 일반 회원: 내 웨이팅 목록 조회
    List<WaitVO> get_my_wait_list(String user_id);
    
    // 점주: 매장별 웨이팅 목록 조회
    List<WaitVO> get_store_wait_list(int store_id);
    
    // 웨이팅 상태 업데이트 (호출, 입장, 취소 등)
    void update_wait_status(int wait_id, String status);
}