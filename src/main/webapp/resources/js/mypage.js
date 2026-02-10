/* src/main/webapp/resources/js/mypage.js [v2.0.0] */
/* 수정사항: I18N_UTIL.t() 방식으로 통일 */

// ✅ main.js 방식으로 통일: I18N_UTIL.t 사용
var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
    ? window.I18N_UTIL.t
    : function(key, fallback) { return fallback || key; };

/**
 * 1. 메뉴 삭제 처리 (점주 전용)
 * @param {number} menuId - 삭제할 메뉴의 고유 ID
 */
function deleteMenu(menuId) {
    // 키 일치 확인: mypage.menuDeleteConfirmStrong
    if(confirm(t("mypage.menuDeleteConfirmStrong", "정말 이 메뉴를 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다."))) {
        submitPostRequest('/store/menu/delete', {
            'menu_id': menuId
        });
    }
}

/**
 * 2. 리뷰 삭제 처리 (공용)
 * @param {string} reviewId - 삭제할 리뷰 ID
 * @param {string} storeId - 해당 맛집 ID
 */
function confirmDeleteReview(reviewId, storeId) {
    // 키 일치 확인: mypage.reviewDeleteConfirm
    if(confirm(t("mypage.reviewDeleteConfirm", "정말 이 리뷰를 삭제하시겠습니까?"))) {
        submitPostRequest('/review/delete', {
            'review_id': reviewId,
            'store_id': storeId
        });
    }
}

/**
 * [공통 로직] POST 요청 폼 생성 및 전송
 * @param {string} url - 요청 경로 (contextPath 제외)
 * @param {object} params - 전송할 데이터 파라미터
 */
function submitPostRequest(url, params) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = APP_CONFIG.contextPath + url;

    var fields = params || {};
    fields[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;

    for (var key in fields) {
        if (fields.hasOwnProperty(key)) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = fields[key];
            form.appendChild(input);
        }
    }

    document.body.appendChild(form);
    form.submit();
}