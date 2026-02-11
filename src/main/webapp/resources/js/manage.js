/**
 * 점주 관리 센터 스크립트 [v2.0.0]
 * 수정사항: I18N_UTIL.t() 방식으로 통일
 */

// ✅ main.js 방식으로 통일: I18N_UTIL.t 사용
var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
    ? window.I18N_UTIL.t
    : function(key, fallback) { return fallback || key; };

$(document).ready(function() {

    APP_CONFIG.userId = "<sec:authentication property='principal.username'/>";
    APP_CONFIG.role = "ROLE_OWNER";
    console.log("현재 설정:", APP_CONFIG);

    if (typeof SockJS !== "undefined" && typeof Stomp !== "undefined" && APP_CONFIG.storeId) {
        var socket = new SockJS(APP_CONFIG.contextPath + "/ws_waiting");
        var stompClient = Stomp.over(socket);
        stompClient.connect({}, function () {
            stompClient.subscribe("/topic/store/" + APP_CONFIG.storeId + "/bookUpdate", function () {
                location.reload();
            });
            stompClient.subscribe("/topic/store/" + APP_CONFIG.storeId + "/waitUpdate", function () {
                location.reload();
            });
        });
    }

    // 노쇼 버튼 클릭 시 이벤트
    $(".noshow-btn").on("click", function() {
        const pay_id = $(this).data("payid");   // 버튼에 심어둔 pay_id 가져오기
        const form = $(this).closest("form");   // 부모 폼 요소

        if (confirm(t("manage.confirmNoShow", "노쇼 처리하시겠습니까? 결제 금액이 환불됩니다."))) {
            // 환불 함수 호출
            cancelPay(pay_id, form);
            
        }
    });

    $(".confirm-btn").on("click", function() {
        const pay_id = $(this).data("payid");   // 버튼에 심어둔 pay_id 가져오기
        const form = $(this).closest("form");   // 부모 폼 요소

        if (confirm(t("manage.confirmFinish", "식사 완료 처리하시겠습니까? 결제 금액이 환불됩니다."))) {
            // 환불 함수 호출
            cancelPay(pay_id, form);
        }
    });

});

/**
 * 식사완료, 노쇼시의 환불 로직
 */
function cancelPay(pay_id, form) {
    $.ajax({
        "url": APP_CONFIG.contextPath + "/pay/api/v2/payment/refund",
        "type": "POST",
        "contentType": "application/json",
        "data": JSON.stringify({ "pay_id": pay_id }),
        beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
        },
        success: function () {
            alert(t("manage.refundSuccess", "환불이 완료되었습니다."));
            
            // 성공 시 status 값을 넣고 폼 제출 (updateStatus 컨트롤러로 이동)
            const isNoShow = form.find(".noshow-btn").length > 0;
            $('<input>').attr({
                type: 'hidden',
                name: 'status', 
                value: isNoShow ? 'NOSHOW' : 'FINISH'
            }).appendTo(form);
            
            form.submit();
        },
        error: function (xhr) {
            // 서버 응답이 409(Conflict)이거나 이미 취소되었다는 메시지가 포함된 경우
            if (xhr.status === 409 || xhr.responseText.includes("PAYMENT_ALREADY_CANCELLED")) {
                alert(t("manage.alreadyCancelled", "이미 사용자가 취소를 완료한 예약입니다. 목록을 갱신합니다."));
            } else {
                alert(t("manage.refundFail", "환불 처리 중 오류가 발생했습니다."));
            }
            
            // ✅ 어떤 에러든 발생하면 화면을 새로고침하여 상태를 동기화함
            location.reload(); 
        }
    });
}