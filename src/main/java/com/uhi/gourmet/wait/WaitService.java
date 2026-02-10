/* com/uhi/gourmet/wait/WaitService.java */
package com.uhi.gourmet.wait;

import java.util.List;
import java.util.Map;

public interface WaitService {
	
	// 웨이팅 등록
    void register_wait(WaitVO vo);
    
    // 매장의 현재 대기 팀 수 조회
    int get_current_wait_count(int store_id);
    
    // 내 웨이팅 내역 조회
    // 최신순으로 정렬
    List<WaitVO> get_my_wait_list(String user_id);
    
    // 특정 매장의 웨이팅 목록 조회(점주)
    List<WaitVO> get_store_wait_list(int store_id);
    
    // 웨이팅 상애 업데이트
    void update_wait_status(int wait_id, String status);

    // 특정 웨이팅 상세 정보 조회 (Controller에서 호출)
    WaitVO get_wait_detail(int wait_id); 
    
    // 오늘 중복 웨이팅 체크
   boolean hasWaitingToday(String user_id, int store_id);
   
   // 내 앞 대기팀 수 알기 위해
   int getTeamsAheadToday(int store_id, int wait_num);
}