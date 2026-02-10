/* com/uhi/gourmet/wait/WaitServiceImpl.java */
package com.uhi.gourmet.wait;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.uhi.gourmet.book.BookService; // 추가
import com.uhi.gourmet.book.BookVO;

@Service
@Transactional
public class WaitServiceImpl implements WaitService {

    @Autowired
    private WaitMapper wait_mapper;

    @Autowired
    private BookService book_service; // 도메인 간 협력을 위한 서비스 주입
    
    // 당일 중복 웨이팅 체크
    @Override
    public boolean hasWaitingToday(String user_id, int store_id) {
        return wait_mapper.existsWaitingToday(user_id, store_id) > 0;
    }
    
    // 웨이팅 등록(동시성 제어)
    @Override
    public synchronized void register_wait(WaitVO vo) {

        //  지금 진행 중인 웨이팅이 있으면 금지
        if (wait_mapper.existsUserActiveWaiting(vo.getUser_id()) > 0) {
            throw new IllegalStateException("이미 진행 중인 웨이팅이 있습니다.");
        }

        // 가게별 오늘 번호는 그대로
        Integer maxNum = wait_mapper.selectMaxWaitNum(vo.getStore_id());
        int nextNum = (maxNum == null) ? 1 : maxNum + 1;
        vo.setWait_num(nextNum);

        wait_mapper.insertWait(vo);
    }


    // 매장의 현재 대기 팀 수 조회
    @Override
    public int get_current_wait_count(int store_id) {
        return wait_mapper.selectCurrentWaitCount(store_id);
    }

    // 내 웨이팅 내역 조회
    @Override
    public List<WaitVO> get_my_wait_list(String user_id) {
        return wait_mapper.selectMyWaitList(user_id);
    }

    // 특정 매장의 웨이팅 목록 조회(점주용)
    @Override
    public List<WaitVO> get_store_wait_list(int store_id) {
        return wait_mapper.selectStoreWaitList(store_id);
    }

    // 웨이팅 상태 업데이트
    @Override
    public void update_wait_status(int wait_id, String status) {
        wait_mapper.updateWaitStatus(wait_id, status);
    }
    
    // 내 앞의 대기 팀 수
    // 실시간 대기 현황 표시
    @Override
    public int getTeamsAheadToday(int store_id, int wait_num) {
        return wait_mapper.selectTeamsAhead(store_id, wait_num);
    }
    
     // 특정 웨이팅의 상세 정보를 가져오는 메서드
     // DB에서 wait_id로 정보를 조회하여 Mapper로부터 VO를 전달받음
    // 상태 변경 시 WebSocket 알림을 위해 store_id를 파악하는 용도
    @Override
    public WaitVO get_wait_detail(int wait_id) {
        return wait_mapper.selectWaitDetail(wait_id);
    }
}