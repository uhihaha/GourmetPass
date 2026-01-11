package com.uhi.gourmet.book;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface BookMapper {
    // 1. 예약 등록 (BookServiceImpl에서 호출)
    void insertBook(BookVO vo);

    // 2. 일반 회원: 내 예약 내역 조회 (MemberController 마이페이지용)
    List<BookVO> selectMyBookList(String user_id);

    // 3. 점주 회원: 매장별 예약자 명단 조회 (BookController/manage용)
    List<BookVO> selectStoreBookList(int store_id);

    // 4. 예약 상태 업데이트 (방문 완료, 노쇼 등)
    // 매개변수가 2개이므로 @Param 어노테이션을 사용하여 XML과 정확히 매핑함
    void updateBookStatus(@Param("book_id") int book_id, @Param("status") String status);
}