/**
 * 멤버 이용 현황 및 히스토리 공통 라이브러리 [v2.0.0]
 * 수정사항: I18N_UTIL.t() 방식으로 통일
 */

// ✅ main.js 방식으로 통일: I18N_UTIL.t 사용
var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
    ? window.I18N_UTIL.t
    : function(key, fallback) { return fallback || key; };

$(document).ready(function() {

    // 1. 예약 취소(환불 포함) 버튼 이벤트
    // .user-cancel-btn (이용현황), .history-cancel-btn (전체내역) 공통 대응
    $(document).on("click", ".user-cancel-btn, .history-cancel-btn", function() {
        const pay_id = $(this).data("payid");
        const $form = $(this).closest("form");

        if (!pay_id) {
            // 키 일치 확인: wait.payMissing
            alert(t("wait.payMissing", "결제 정보가 없습니다."));
            return;
        }

        // 키 일치 확인: wait.bookCancelConfirm
        if (confirm(t("wait.bookCancelConfirm", "예약을 취소하시겠습니까? 결제 금액이 환불됩니다."))) {
            cancelPay(pay_id, $form);
        }
    });

    // 2. 웨이팅 취소 버튼 이벤트
    $(document).on("click", ".wait-cancel-btn", function() {
        const waitId = $(this).data("wait-id");
        if (waitId) {
            cancelWait(waitId);
        }
    });

    // 3. 리뷰 작성 링크 이동
    $(document).on("click", ".js-review-link", function() {
        const url = $(this).data("url");
        if (url) {
            location.href = url;
        }
    });

    // 4. 일반 알림 처리
    $(document).on("click", ".js-alert", function() {
        const message = $(this).data("message");
        if (message) alert(message);
    });

});

/**
 * 아임포트/결제 환불 로직
 * @param {string} pay_id - 결제 고유 번호
 * @param {jQuery} $form - 제출할 폼 객체
 */
function cancelPay(pay_id, $form) {
    $.ajax({
        url: APP_CONFIG.contextPath + "/pay/api/v2/payment/refund",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({ "pay_id": pay_id }),
        beforeSend: function(xhr) {
            // 보안 정책: CSRF 토큰 주입
            xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
        },
        success: function() {
            // 키 일치 확인: wait.refundDone
            alert(t("wait.refundDone", "환불이 완료되었습니다."));
            // 상태값을 CANCELED로 변경하여 폼 제출
            if ($form.find('input[name="status"]').length === 0) {
                $('<input>').attr({
                    type: 'hidden',
                    name: 'status',
                    value: 'CANCELED'
                }).appendTo($form);
            }
            $form.submit();
        },
        error: function(xhr) {
            // 키 일치 확인: wait.refundFailPrefix, wait.refundFailFallback
            alert(t("wait.refundFailPrefix", "환불 실패:") + " " + 
                (xhr.responseText || t("wait.refundFailFallback", "알 수 없는 오류")));
            console.error(xhr.responseText);
        }
    });
}

/**
 * 웨이팅 취소 로직
 * @param {number} waitId - 웨이팅 번호
 */
function cancelWait(waitId) {
    // 키 일치 확인: wait.cancelConfirm
    if (!confirm(t("wait.cancelConfirm", "웨이팅을 취소하시겠습니까?"))) return;

    const url = APP_CONFIG.contextPath + "/wait/cancel";

    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRF-TOKEN": APP_CONFIG.csrfToken
        },
        body: new URLSearchParams({ wait_id: String(waitId) })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // 키 일치 확인: wait.cancelSuccess
            alert(t("wait.cancelSuccess", "웨이팅이 취소되었습니다."));
            location.reload();
        } else {
            // 키 일치 확인: wait.failPrefix
            alert(t("wait.failPrefix", "취소 실패:") + " " + data.message);
        }
    })
    .catch(err => {
        console.error("Error:", err);
        location.reload(); 
    });
}