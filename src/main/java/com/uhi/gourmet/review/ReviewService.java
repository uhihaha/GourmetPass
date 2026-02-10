/* com/uhi/gourmet/review/ReviewService.java */
package com.uhi.gourmet.review;

import java.util.List;
import java.util.Map;
import com.github.pagehelper.PageInfo;

public interface ReviewService {
	
    // 1. 리뷰 등록
    void registerReview(ReviewVO vo, String userId);

    // 2. 특정 가게의 리뷰 목록 조회 (페이징 적용)
    PageInfo<ReviewVO> getStoreReviews(int store_id, int pageNum, int pageSize);

    // 3. 내가 작성한 리뷰 목록 조회 (페이징 적용)
    // 기존 List<ReviewVO> getMyReviews(String user_id)를 대체하거나 함께 사용할 수 있음
    PageInfo<ReviewVO> getMyReviewsPaginated(String user_id, int pageNum, int pageSize);

    // 4. 가게별 리뷰 통계 (평균 별점, 총 리뷰 수)
    Map<String, Object> getReviewStats(int store_id);
    
    // 5. 리뷰 삭제 권한 확인
    // 본인이 작성한건지 검증
    boolean canDeleteReview(int review_id, String user_id);

    // 6. 리뷰 삭제
    void removeReview(int review_id);

    // 7. 리뷰 작성 자격 확인
    // 특정 사용자의 특정 가게 방문 완료 여부 체크
    boolean checkReviewEligibility(String user_id, int store_id);

    // 8. 리뷰 작성에 필요한 모든 데이터를 한번에 조회하여 반환함
    Map<String, Object> getReviewWriteContext(String userId, int storeId, Integer bookId, Integer waitId);
}