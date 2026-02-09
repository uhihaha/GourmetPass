/**
 * 고메패스 맛집 상세 페이지 전용 스크립트 [v1.1.8]
 * 수정사항: 구문 오류(괄호 불일치) 해결 및 코드 구조 안정화
 */

// ================================================================
// [A] 전역 함수 영역
// ================================================================
var STORE_I18N = (window.I18N && window.I18N.storeDetail) ? window.I18N.storeDetail : {};
var COMMON_I18N = (window.I18N && window.I18N.common) ? window.I18N.common : {};

window.loadAvailableSlots = function () {
    const app = document.getElementById('storeDetailApp');
    if (!app) return;

    const contextPath = app.dataset.context;
    const storeId = app.dataset.storeId;
    const openTime = app.dataset.openTime;
    const closeTime = app.dataset.closeTime;
    const resUnit = parseInt(app.dataset.resUnit) || 30;

    const bookDate = $("#bookDate").val();
    const container = $("#timeSlotContainer");

    if (!bookDate || !container.length) return;

    const now = new Date();
    const todayStr = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');
    const bufferTime = new Date(now.getTime() + 10 * 60000);
    const currentTimeStr = String(bufferTime.getHours()).padStart(2, '0') + ":" + String(bufferTime.getMinutes()).padStart(2, '0');

    var loadingMsg = STORE_I18N.loading || "조회 중...";
    container.html("<p class='status-text'>" + loadingMsg + "</p>");
    $("#selectedTime").val("");

    $.ajax({
        url: contextPath + "/store/api/timeSlots",
        type: "GET",
        data: {store_id: storeId, book_date: bookDate},
        dataType: "json",
        success: function (availableList) {
            const allSlots = window.generateAllSlots(openTime, closeTime, resUnit);
            let html = "";

            allSlots.forEach(time => {
                const isBooked = !availableList.includes(time);
                const isPast = (bookDate === todayStr && time <= currentTimeStr);

                if (isBooked || isPast) {
                    const reason = isPast
                        ? (STORE_I18N.reasonClosed || "마감")
                        : (STORE_I18N.reasonBooked || "예약됨");
                    html += `<button type="button" class="time-btn disabled" disabled title="${reason}">${time}</button>`;
                } else {
                    html += `<button type="button" class="time-btn" data-time="${time}">${time}</button>`;
                }
            });
            var noHoursMsg = STORE_I18N.noHours || "영업 시간이 설정되지 않았습니다.";
            container.html(html || "<p>" + noHoursMsg + "</p>");
        },
        error: function () {
            var loadFail = STORE_I18N.loadFail || "정보 로드 실패";
            container.html("<p class='error-text'>" + loadFail + "</p>");
        }
    });
};

window.generateAllSlots = function (open, close, unit) {
    const slots = [];
    let current = open;
    if (!current || !close) return slots;

    while (current <= close) {
        slots.push(current);
        let [h, m] = current.split(':').map(Number);
        m += unit;
        if (m >= 60) {
            h++;
            m -= 60;
        }
        current = String(h).padStart(2, '0') + ":" + String(m).padStart(2, '0');
        if (current > close) break;
    }
    return slots;
};

window.showInteraction = function (type) {
    $(".interaction-card").hide();
    const target = $("#" + type + "-area");
    if (target.length) {
        target.fadeIn();
        $('html, body').animate({scrollTop: target.offset().top - 100}, 500);
    }
    $(".btn-main-wire").removeClass("active");
    $(".btn-" + type).addClass("active");
};

window.checkAccount = function () {
    const app = document.getElementById("storeDetailApp");
    if (!app) return true;
    const ownerId = app.dataset.ownerId || "";

    if (!loginUserInfo || !loginUserInfo.loginUserId) {
        var loginRequired = COMMON_I18N.loginRequired || "로그인이 필요합니다";
        alert(loginRequired);
        return false;
    }
    if (loginUserInfo.isOwner) {
        var ownerBlock = STORE_I18N.ownerBlock || "점주 계정은 예약/웨이팅을 할 수 없습니다.";
        alert(ownerBlock);
        return false;
    }
    if (loginUserInfo.loginUserId === ownerId) {
        var selfBlock = STORE_I18N.selfBlock || "본인 매장은 예약/웨이팅을 할 수 없습니다.";
        alert(selfBlock);
        return false;
    }
    return true;
};

window.updateFavoriteButton = function (isFavorite) {
    const btn = $("#favoriteBtn");
    if (!btn.length) return;
    if (isFavorite) {
        var favoriteOn = STORE_I18N.favoriteOn || "즐겨찾기 해제";
        btn.addClass("active").text("❤️ " + favoriteOn);
    } else {
        var favoriteOff = STORE_I18N.favoriteOff || "즐겨찾기";
        btn.removeClass("active").text("🤍 " + favoriteOff);
    }
};

window.updateFavoriteCount = function (count) {
    const countEl = $("#favoriteCount");
    if (!countEl.length) return;
    const safeCount = typeof count === "number" ? count : parseInt(count, 10) || 0;
    var countPrefix = STORE_I18N.favoriteCountPrefix || "❤️";
    countEl.text(countPrefix + " " + safeCount);
};

window.showToast = function (message) {
    let toast = document.getElementById("toast");
    if (!toast) {
        toast = document.createElement("div");
        toast.id = "toast";
        toast.className = "toast";
        document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.classList.add("show");
    setTimeout(() => toast.classList.remove("show"), 1500);
};

window.loadFavoriteStatus = function () {
    const app = document.getElementById("storeDetailApp");
    if (!app || !loginUserInfo || !loginUserInfo.loginUserId) {
        window.updateFavoriteButton(false);
        return;
    }
    const storeId = app.dataset.storeId;
    const contextPath = (typeof APP_CONFIG !== "undefined" && APP_CONFIG.contextPath) ? APP_CONFIG.contextPath : app.dataset.context;

    $.ajax({
        url: contextPath + "/favorite/status",
        type: "GET",
        data: {store_id: storeId},
        dataType: "json"
    }).done(function (res) {
        window.updateFavoriteButton(!!res.favorite);
        window.updateFavoriteCount(res.count);
    }).fail(() => window.updateFavoriteButton(false));
};

// ================================================================
// [B] 문서 로드 완료 후 실행 영역
// ================================================================

$(document).ready(function () {
    const app = document.getElementById('storeDetailApp');
    if (!app) return;

    // 1. 날짜 초기값
    const now = new Date();
    const today = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');
    $("#bookDate").val(today).attr("min", today);

    // 2. 지도 초기화
    if (app.dataset.lat && app.dataset.lng && typeof kakao !== 'undefined') {
        const container = document.getElementById('map');
        if (container) {
            const options = { center: new kakao.maps.LatLng(app.dataset.lat, app.dataset.lng), level: 3 };
            const map = new kakao.maps.Map(container, options);
            new kakao.maps.Marker({position: options.center}).setMap(map);
        }
    }

    // 3. 시간 버튼 클릭 이벤트
    $(document).on("click", ".time-btn:not([disabled])", function () {
        $(".time-btn").removeClass("active");
        $(this).addClass("active");
        $("#selectedTime").val($(this).data("time"));
    });

    // 4. 모바일 결제 복귀 처리
    const urlParams = new URLSearchParams(window.location.search);
    const paymentStatus = urlParams.get('status');
    const payId = urlParams.get('pay_id');
    const bDate = urlParams.get('book_date');
    const bTime = urlParams.get('book_time');
    const pCnt = urlParams.get('people_cnt');
	
	
    if (paymentStatus === 'success' && payId && bDate && bTime) {
        $("#payIdField").val(payId);
        $("#bookDate").val(bDate);
        $("#selectedTime").val(bTime);
        $("#people_cnt").val(pCnt || '1');
        var paySuccessBooking = STORE_I18N.paySuccessBooking || "결제가 완료되었습니다! 예약을 진행합니다.";
		alert(paySuccessBooking);
        $("#bookForm").submit();
        
    } else if (paymentStatus === 'fail') {
        var payFail = STORE_I18N.payFail || "결제가 실패했습니다.";
        alert(payFail);
        window.history.replaceState({}, document.title, window.location.pathname + '?storeId=' + app.dataset.storeId);
    }

    // 5. 예약 폼 제출 핸들러
    $("#bookForm").on("submit", function (e) {
        e.preventDefault();
        if (!window.checkAccount()) return;

        const form = this;
        const selectedTime = $("#selectedTime").val();
        const bookDate = $("#bookDate").val();
		const peopleCnt = $("select[name='people_cnt']").val() || 1;        
		const storeId = $("input[name='store_id']").val();
        const contextPath = app.dataset.context;

        if ($("#payIdField").val().trim() !== "") {
            form.submit();
            return;
        }

        if (!selectedTime) {
            var selectVisitTime = STORE_I18N.selectVisitTime || "방문 시간을 선택해 주세요!";
            alert(selectVisitTime);
            return;
        }

        $.ajax({
            url: contextPath + "/book/api/checkDuplicate",
            type: "GET",
            data: {store_id: storeId, book_date: bookDate, book_time: selectedTime},
            success: async function (result) {
                if (result === "AVAILABLE") {
                    var confirmSuffix = STORE_I18N.confirmPaymentSuffix || "예약을 위해 결제를 진행하시겠습니까?";
                    if (!confirm(bookDate + " " + selectedTime + " " + confirmSuffix)) return;
                    try {
                        const paymentId = "pay-" + new Date().getTime();
                        const response = await PortOne.requestPayment({
                            storeId: loginUserInfo.portOneStoreId,
                            channelKey: loginUserInfo.portOneChannelKey,
                            paymentId: paymentId,
                            orderName: (STORE_I18N.orderName || "예약 보증금"),
                            totalAmount: 1000,
                            currency: "CURRENCY_KRW",
                            payMethod: "CARD",
                            customer: { fullName: loginUserInfo.name, phoneNumber: loginUserInfo.tel, email: loginUserInfo.email },
                            redirectUrl: window.location.origin + contextPath + "/pay/api/v2/payment/complete/mobile?paymentId=" + paymentId + "&storeId=" + storeId + "&book_date=" + encodeURIComponent(bookDate) + "&book_time=" + encodeURIComponent(selectedTime) + "&people_cnt=" + peopleCnt
                        });

                        if (response.code == null) {
                            $.ajax({
                                url: contextPath + '/pay/api/v2/payment/complete',
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify({paymentId: response.paymentId}),
                                beforeSend: function (xhr) {
                                    if (typeof APP_CONFIG !== 'undefined') xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
                                }
                            }).done(function (pId) {
                                $("#payIdField").val(pId);
                                var paySuccess = STORE_I18N.paySuccess || "결제가 완료되었습니다!";
                                alert(paySuccess);
                                form.submit();
                            }).fail(() => {
                                var payVerifyFail = STORE_I18N.payVerifyFail || "결제 검증에 실패했습니다.";
                                alert(payVerifyFail);
                            });
                        } else {
                            var payCancelledPrefix = STORE_I18N.payCancelledPrefix || "결제가 취소되었습니다:";
                            alert(payCancelledPrefix + " " + response.message);
                        }
                    } catch (err) {
                        var payPopupError = STORE_I18N.payPopupError || "결제창 호출 중 오류가 발생했습니다.";
                        alert(payPopupError);
                    }
                } else {
                    var unavailablePrefix = STORE_I18N.bookUnavailablePrefix || "예약이 불가능합니다. (사유:";
                    var unavailableSuffix = STORE_I18N.bookUnavailableSuffix || ")";
                    alert(unavailablePrefix + " " + result + unavailableSuffix);
                }
            }
        });
    });

    // 6. 즐겨찾기 버튼
    $("#favoriteBtn").on("click", function () {
        if (!loginUserInfo || !loginUserInfo.loginUserId) {
            var loginRequired = COMMON_I18N.loginRequired || "로그인이 필요합니다";
            alert(loginRequired);
            return;
        }
        const storeId = app.dataset.storeId;
        const contextPath = (typeof APP_CONFIG !== "undefined" && APP_CONFIG.contextPath) ? APP_CONFIG.contextPath : app.dataset.context;

        $.ajax({
            url: contextPath + "/favorite/toggle",
            type: "POST",
            data: {store_id: storeId},
            beforeSend: function (xhr) {
                if (typeof APP_CONFIG !== "undefined") xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
            }
        }).done(function (res) {
            window.updateFavoriteButton(!!res.favorite);
            window.updateFavoriteCount(res.count);
        });
    });

    // 7. 슬라이더 및 초기화 실행
    window.loadFavoriteStatus();
    window.loadAvailableSlots();

    // 8. WebSocket (선택사항)
    if (typeof SockJS !== "undefined" && typeof Stomp !== "undefined") {
        const socket = new SockJS(app.dataset.context + "/ws_waiting");
        const stomp = Stomp.over(socket);
        stomp.connect({}, function () {
            stomp.subscribe("/topic/store/" + app.dataset.storeId + "/viewers", (msg) => {
                var viewerPrefix = STORE_I18N.viewerPrefix || "👥";
                var viewerSuffix = STORE_I18N.viewerSuffix || "명";
                $("#viewerCount").text(viewerPrefix + " " + msg.body + viewerSuffix);
            });
        });
    }
}); 
