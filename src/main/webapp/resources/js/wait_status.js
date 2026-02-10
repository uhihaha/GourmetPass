var WAIT_I18N = (window.I18N && window.I18N.wait) ? window.I18N.wait : {};
$(document).ready(function() {
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

        var confirmRefund = WAIT_I18N.bookCancelConfirmRefund || "";
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
function cancelPay(pay_id, form) {	// pay_id 를 매개변수로 가져와서
    $.ajax({
        "url": APP_CONFIG.contextPath+"/pay/api/v2/payment/refund",
        "type": "POST",
        "contentType": "application/json",
        "data": JSON.stringify({
            "pay_id" : pay_id, // Controller에 변수로 보낸다.
        }),
        //  post 수행하기위해 토큰만 주입
        beforeSend: function(xhr) {
            xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
        },
        success: function () {	// response를 괄호에 넣어서 controller에서 값을 가져올 수 있음
            var refundSuccess = WAIT_I18N.refundSuccess || "";
            alert(refundSuccess);
            
            // 폼 안에 hidden을 만들어서 값을 넣어줌
		    $('<input>').attr({
		        type: 'hidden',
		        name: 'status', 
		        value: 'CANCELED'  
		    }).appendTo(form);
            form.submit();	// book status cancel form submit
            // 필요하면 페이지 새로고침
            // location.reload();
        },

        error: function (xhr, status, error) {
            var refundFail = WAIT_I18N.refundFail || "";
            alert(refundFail);
            console.error(xhr.responseText);
        }	
    });
}

    
function cancelWait(waitId) {
    var waitConfirm = WAIT_I18N.cancelConfirm || "";
    if (!confirm(waitConfirm)) return;
    
    const url = APP_CONFIG.contextPath + "/wait/cancel";
    
    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRF-TOKEN": APP_CONFIG.csrfToken
        },
        credentials: 'include',  // 쿠키 포함
        body: new URLSearchParams({ wait_id: String(waitId) })
    })
    .then(res => {
        var serverError = (window.I18N && window.I18N.common && window.I18N.common.serverError)
            ? window.I18N.common.serverError
            : "";
        if (!res.ok) throw new Error(serverError);
        return res.json();
    })
    .then(data => {
         if (data.success) {
        var cancelSuccess = WAIT_I18N.cancelSuccess || "";
        alert(cancelSuccess);
        location.reload();
    } else if (data.error_type === 'SQL_ERROR') {
        // SQL 에러일 때만 경고
        var cancelFail = WAIT_I18N.cancelFail || "";
        alert(cancelFail);
    } else {
        // 일반적인 실패 (이미 취소됨, 권한 없음 등)
        var failPrefix = WAIT_I18N.failPrefix || "";
        alert(failPrefix + " " + data.message);
    }
	})
	.catch(() => {
        var cancelSuccess = WAIT_I18N.cancelSuccess || "";
        alert(cancelSuccess);
    }); // 네트워크 에러는 조용히 무시
}
