/* src/main/webapp/resources/js/wait_status.js */
$(document).ready(function() {
    // i18n 유틸리티 함수 초기화
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    const wrapper = document.querySelector(".wait-status-wrapper");
    if (wrapper) {
        const userId = wrapper.dataset.userId || "";
        const activeStoreId = wrapper.dataset.activeStoreId || "";

        if (typeof APP_CONFIG !== "undefined") {
            APP_CONFIG.userId = userId;
            APP_CONFIG.activeStoreId = activeStoreId;
        }

        if (userId) {
            connectRealtime(userId, activeStoreId);
        }
    }

    $(".user-cancel-btn").on("click", function() {
        const pay_id = $(this).data("payid");
        const form = $(this).closest("form");

        // [변경] wait.book.cancelConfirmRefund -> wait.bookCancelConfirmRefund
        var confirmRefund = t("wait.bookCancelConfirmRefund", "예약을 취소하시겠습니까? 결제 금액이 환불됩니다.");
        if (confirm(confirmRefund)) {
            cancelPay(pay_id, form);
        }
    });

    $(".wait-cancel-btn").on("click", function() {
        const waitId = $(this).data("wait-id");
        if (waitId) {
            cancelWait(waitId);
        }
    });

    $(".js-alert").on("click", function() {
        const message = $(this).data("message");
        if (message) {
            alert(message);
        }
    });

    $(".js-review-link").on("click", function() {
        const url = $(this).data("url");
        if (url) {
            location.href = url;
        }
    });
});

function connectRealtime(userId, activeStoreId) {
    if (typeof SockJS === "undefined" || typeof Stomp === "undefined") {
        return;
    }

    const socket = new SockJS(APP_CONFIG.contextPath + "/ws_waiting");
    const stompClient = Stomp.over(socket);
    stompClient.debug = null;

    stompClient.connect({}, function() {
        stompClient.subscribe("/topic/wait/" + userId, function() { location.reload(); });
        if (activeStoreId) {
            stompClient.subscribe("/topic/store/" + activeStoreId + "/waitUpdate", function() { location.reload(); });
        }
    }, function() { setTimeout(function() { connectRealtime(userId, activeStoreId); }, 5000); });
}

// 사용자의 예약 취소시의 환불 로직 JAVASCRIPT
function cancelPay(pay_id, form) {
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    $.ajax({
        "url": APP_CONFIG.contextPath+"/pay/api/v2/payment/refund",
        "type": "POST",
        "contentType": "application/json",
        "data": JSON.stringify({
            "pay_id" : pay_id,
        }),
        beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
        },
        success: function () {
            // [변경] wait.refund.success -> wait.refundSuccess
            var refundSuccess = t("wait.refundSuccess", "환불이 완료되었습니다.");
            alert(refundSuccess);

            $('<input>').attr({
                type: 'hidden',
                name: 'status', 
                value: 'CANCELED'  
            }).appendTo(form);
            form.submit();
        },
        error: function (xhr, status, error) {
            // [변경] wait.refund.fail -> wait.refundFail
            var refundFail = t("wait.refundFail", "환불 처리 중 오류가 발생했습니다.");
            alert(refundFail);
            console.error(xhr.responseText);
        }	
    });
}

function cancelWait(waitId) {
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    // [변경] wait.cancel.confirm -> wait.cancelConfirm
    var waitConfirm = t("wait.cancelConfirm", "웨이팅을 취소하시겠습니까?");
    if (!confirm(waitConfirm)) return;

    const url = APP_CONFIG.contextPath + "/wait/cancel";

    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRF-TOKEN": APP_CONFIG.csrfToken
        },
        credentials: 'include',
        body: new URLSearchParams({ wait_id: String(waitId) })
    })
    .then(res => {
        // [변경] common.server.error -> common.serverError
        var serverError = t("common.serverError", "서버 오류가 발생했습니다.");
        if (!res.ok) throw new Error(serverError);
        return res.json();
    })
    .then(data => {
        if (data.success) {
            // [변경] wait.cancel.success -> wait.cancelSuccess
            var cancelSuccess = t("wait.cancelSuccess", "웨이팅이 취소되었습니다.");
            alert(cancelSuccess);
            location.reload();
        } else if (data.error_type === 'SQL_ERROR') {
            // [변경] wait.cancel.fail -> wait.cancelFail
            var cancelFail = t("wait.cancelFail", "취소 실패");
            alert(cancelFail);
        } else {
            // [변경] wait.fail.prefix -> wait.failPrefix
            var failPrefix = t("wait.failPrefix", "실패:");
            alert(failPrefix + " " + data.message);
        }
    })
    .catch(() => {
        // [변경] wait.cancel.success -> wait.cancelSuccess
        var cancelSuccess = t("wait.cancelSuccess", "웨이팅이 취소되었습니다.");
        alert(cancelSuccess);
    });
}