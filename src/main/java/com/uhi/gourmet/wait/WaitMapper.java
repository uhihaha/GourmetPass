/* com/uhi/gourmet/wait/WaitMapper.java */
package com.uhi.gourmet.wait;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WaitMapper {
    
    // 1. 웨이팅 등록 (WaitServiceImpl에서 호출)
    void insertWait(WaitVO vo);

    // 2. 현재 매장의 가장 높은 대기 번호 조회
    // 새로운 웨이팅 번호 발급시 사용함
    Integer selectMaxWaitNum(int store_id);

    // 3. 매장 현재 대기 팀수 조회 (오늘 기준)
    int selectCurrentWaitCount(int store_id);

    // 4. 일반 회원: 내 웨이팅 내역 조회 (MemberController 마이페이지용)
    List<WaitVO> selectMyWaitList(String user_id);

    // 5. 점주: 특정 매장의 전체 웨이팅 목록 조회 (BookController/manage용)
    // 당일 웨이팅만 조회 가능
    List<WaitVO> selectStoreWaitList(int store_id);
    
    // 6. 웨이팅 상태 업데이트 (호출, 입장완료, 취소 등)
    // 매개변수가 2개이므로 @Param을 사용하여 XML의 #{wait_id}, #{status}와 연결
    void updateWaitStatus(@Param("wait_id") int wait_id, @Param("status") String status);

    
    // 7. PK로 웨이팅 정보 단건 조회
    // 상태 변경 시 store_id를 파악해서 실시간 알림에 사용
    WaitVO selectWaitDetail(int wait_id);
    
    
    // 8. 당일 중복 웨이팅 체크
    // 같은 가게에 오늘 이미 대기중인지 확인
    int existsWaitingToday(
            @Param("user_id") String user_id,
            @Param("store_id") int store_id
        );
    
    // 9. 대 앞의 대기 팀 수 조회
    int selectTeamsAhead(
    		@Param("store_id") int store_id, 
    		@Param("wait_num") int wait_num);
    
    // 10. 현재 진행중인 웨이팅 존재 여후(다른가게 포함)
    // 여러가게 동시 웨이팅 방지
    int existsUserActiveWaiting(@Param("user_id") String user_id);

}