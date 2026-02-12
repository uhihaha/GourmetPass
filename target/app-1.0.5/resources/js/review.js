/* /resources/js/review.js [v2.0.0] */
/* 수정사항: I18N_UTIL.t() 방식으로 통일 */

// ✅ main.js 방식으로 통일: I18N_UTIL.t 사용
var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
    ? window.I18N_UTIL.t
    : function(key, fallback) { return fallback || key; };

function confirmDeleteReview(reviewId, storeId) {
    // 키 일치 확인: review.deleteConfirm
    if(confirm(t("review.deleteConfirm", "정말 이 리뷰를 삭제하시겠습니까?"))) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = APP_CONFIG.contextPath + '/review/delete';

        const fields = {
            'review_id': reviewId,
            'store_id': storeId,
            [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken
        };

        for (const key in fields) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = fields[key];
            form.appendChild(input);
        }
        document.body.appendChild(form);
        form.submit();
    }
}