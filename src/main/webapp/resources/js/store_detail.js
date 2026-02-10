/**
 * 고메패스 맛집 상세 페이지 전용 통합 스크립트 [v2.2.0]
 * 수정사항: 링크 복사 로직 통합, i18n 키셋 동기화, 보안 필터(CSRF) 강화
 */

(function($) {
    // ✅ i18n 유틸리티 함수 초기화
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    // ================================================================
    // [A] 전역 함수 영역
    // ================================================================

    // 1. 예약 가능 시간 슬롯 로드
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

        container.html("<p class='status-text'>" + 
            t("storeDetail.loading", "예약 가능 시간 조회 중...") + 
            "</p>");
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
                            ? t("storeDetail.reasonClosed", "마감")
                            : t("storeDetail.reasonBooked", "예약완료");
                        html += `<button type="button" class="time-btn disabled" disabled title="${reason}">${time}</button>`;
                    } else {
                        html += `<button type="button" class="time-btn" data-time="${time}">${time}</button>`;
                    }
                });

                container.html(html || "<p>" + 
                    t("storeDetail.noHours", "선택 가능한 시간이 없습니다.") + 
                    "</p>");
            },
            error: function () {
                container.html("<p class='error-text'>" + 
                    t("storeDetail.loadFail", "시간 로드 실패") + 
                    "</p>");
            }
        });
    };

    // 2. 시간 슬롯 배열 생성 엔진
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

    // 3. UI 인터랙션 제어 (예약/웨이팅 전환)
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

    // 4. 계정 권한 사전 검증
    window.checkAccount = function () {
        const app = document.getElementById("storeDetailApp");
        if (!app) return true;
        const ownerId = app.dataset.ownerId || "";

        if (!loginUserInfo || !loginUserInfo.loginUserId) {
            alert(t("common.loginRequired", "로그인이 필요합니다"));
            return false;
        }
        if (loginUserInfo.isOwner) {
            alert(t("storeDetail.ownerBlock", "점주 계정은 예약/웨이팅을 할 수 없습니다."));
            return false;
        }
        if (loginUserInfo.loginUserId === ownerId) {
            alert(t("storeDetail.selfBlock", "본인 매장은 예약/웨이팅을 할 수 없습니다."));
            return false;
        }
        return true;
    };

    // 5. 즐겨찾기 버튼 상태 업데이트
    window.updateFavoriteButton = function (isFavorite) {
        const btn = $("#favoriteBtn");
        if (!btn.length) return;

        if (isFavorite) {
            btn.addClass("active").text("❤️ " + t("storeDetail.favoriteOn", "즐겨찾기 해제"));
        } else {
            btn.removeClass("active").text("🤍 " + t("storeDetail.favoriteOff", "즐겨찾기 추가"));
        }
    };

    // 6. 즐겨찾기 카운트 갱신
    window.updateFavoriteCount = function (count) {
        const countEl = $("#favoriteCount");
        if (!countEl.length) return;
        const safeCount = typeof count === "number" ? count : parseInt(count, 10) || 0;
        countEl.text(t("storeDetail.favoriteCountPrefix", "즐겨찾기") + " " + safeCount);
    };

    // 7. 즐겨찾기 초기 로드
    window.loadFavoriteStatus = function () {
        const app = document.getElementById("storeDetailApp");
        if (!app || !loginUserInfo || !loginUserInfo.loginUserId) {
            window.updateFavoriteButton(false);
            return;
        }
        const storeId = app.dataset.storeId;
        const contextPath = APP_CONFIG.contextPath;

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

        // 1. 날짜 초기값 설정
        const now = new Date();
        const today = now.getFullYear() + "-" + 
            String(now.getMonth() + 1).padStart(2, '0') + "-" + 
            String(now.getDate()).padStart(2, '0');
        $("#bookDate").val(today).attr("min", today);
        $("#bookDate").on("input change", function () {
            this.setCustomValidity("");
        });

        // 2. 지도 초기화 (Kakao Map)
        if (app.dataset.lat && app.dataset.lng && typeof kakao !== 'undefined') {
            const container = document.getElementById('map');
            if (container) {
                const options = { 
                    center: new kakao.maps.LatLng(app.dataset.lat, app.dataset.lng), 
                    level: 3 
                };
                const map = new kakao.maps.Map(container, options);
                new kakao.maps.Marker({position: options.center}).setMap(map);
            }
        }

        // 3. 시간 버튼 클릭 이벤트 바인딩
        $(document).on("click", ".time-btn:not([disabled])", function () {
            $(".time-btn").removeClass("active");
            $(this).addClass("active");
            $("#selectedTime").val($(this).data("time"));
        });

        // 4. 링크 복사 기능 통합 [Cite: share inline 대응]
        $("#copyLinkBtn").on("click", function() {
            const currentUrl = window.location.href;
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(currentUrl).then(() => {
                    alert(t("storeDetail.copySuccess", "링크가 클립보드에 복사되었습니다."));
                }).catch(() => {
                    alert(t("storeDetail.copyFail", "링크 복사에 실패했습니다."));
                });
            } else {
                const textArea = document.createElement("textarea");
                textArea.value = currentUrl;
                document.body.appendChild(textArea);
                textArea.select();
                try {
                    document.execCommand('copy');
                    alert(t("storeDetail.copySuccess"));
                } catch (err) {
                    alert(t("storeDetail.copyFail"));
                }
                document.body.removeChild(textArea);
            }
        });

        // 5. 모바일 결제 복귀 처리
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('status') === 'success') {
            alert(t("storeDetail.paySuccessBooking", "결제가 완료되었습니다! 예약을 진행합니다."));
            $("#bookForm").submit();
        } else if (urlParams.get('status') === 'fail') {
            alert(t("storeDetail.payFail", "결제가 실패했습니다."));
            window.history.replaceState({}, document.title, 
                window.location.pathname + '?storeId=' + app.dataset.storeId);
        }

        // 6. 예약 폼 제출 핸들러 (PortOne 연동)
        $("#bookForm").on("submit", function (e) {
            e.preventDefault();
            if (!window.checkAccount()) return;

            const form = this;
            const selectedTime = $("#selectedTime").val();
            const bookDate = $("#bookDate").val();
            const peopleCnt = $("select[name='people_cnt']").val() || 1;
            const storeId = app.dataset.storeId;
            const contextPath = app.dataset.context;

            if (!bookDate) {
                const bookDateInput = document.getElementById("bookDate");
                bookDateInput.setCustomValidity(t("storeDetail.bookDateRequired", "예약 날짜를 선택해 주세요."));
                bookDateInput.reportValidity();
                return;
            }

            if ($("#payIdField").val().trim() !== "") {
                form.submit();
                return;
            }

            if (!selectedTime) {
                alert(t("storeDetail.selectVisitTime", "방문 시간을 선택해 주세요!"));
                return;
            }

            // 중복 예약 체크 AJAX
            $.ajax({
                url: contextPath + "/book/api/checkDuplicate",
                type: "GET",
                data: {store_id: storeId, book_date: bookDate, book_time: selectedTime},
                success: async function (result) {
                    if (result === "AVAILABLE") {
                        if (!confirm(bookDate + " " + selectedTime + " " + 
                            t("storeDetail.confirmPaymentSuffix", "예약을 위해 결제를 진행하시겠습니까?"))) {
                            return;
                        }

                        try {
                            const paymentId = "pay-" + new Date().getTime();
                            const response = await PortOne.requestPayment({
                                storeId: loginUserInfo.portOneStoreId,
                                channelKey: loginUserInfo.portOneChannelKey,
                                paymentId: paymentId,
                                orderName: t("storeDetail.orderName", "예약 보증금"),
                                totalAmount: 1000,
                                currency: "CURRENCY_KRW",
                                payMethod: "CARD",
                                customer: { 
                                    fullName: loginUserInfo.name, 
                                    phoneNumber: loginUserInfo.tel, 
                                    email: loginUserInfo.email 
                                },
                                redirectUrl: window.location.origin + contextPath + 
                                    "/pay/api/v2/payment/complete/mobile?paymentId=" + paymentId + 
                                    "&storeId=" + storeId + 
                                    "&book_date=" + encodeURIComponent(bookDate) + 
                                    "&book_time=" + encodeURIComponent(selectedTime) + 
                                    "&people_cnt=" + peopleCnt
                            });

                            if (response.code == null) {
                                $.ajax({
                                    url: contextPath + '/pay/api/v2/payment/complete',
                                    type: 'POST',
                                    contentType: 'application/json',
                                    data: JSON.stringify({paymentId: response.paymentId}),
                                    beforeSend: function (xhr) {
                                        xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
                                    }
                                }).done(function (pId) {
                                    $("#payIdField").val(pId);
                                    alert(t("storeDetail.paySuccess", "결제가 완료되었습니다!"));
                                    form.submit();
                                }).fail(() => {
                                    alert(t("storeDetail.payVerifyFail", "결제 검증에 실패했습니다."));
                                });
                            } else {
                                alert(t("storeDetail.payCancelledPrefix", "결제가 취소되었습니다:") + " " + response.message);
                            }
                        } catch (err) {
                            alert(t("storeDetail.payPopupError", "결제창 호출 중 오류가 발생했습니다."));
                        }
                    } else {
                        alert(t("storeDetail.bookUnavailablePrefix", "예약이 불가능합니다. (사유:") + 
                            " " + result + t("storeDetail.bookUnavailableSuffix", ")"));
                    }
                },
                error: function() {
                    alert(t("common.serverError", "서버 오류가 발생했습니다."));
                }
            });
        });

        // 7. 즐겨찾기 버튼 클릭 이벤트 (AJAX)
        $("#favoriteBtn").on("click", function () {
            if (!window.checkAccount()) return;
            const storeId = app.dataset.storeId;
            const contextPath = APP_CONFIG.contextPath;

            $.ajax({
                url: contextPath + "/favorite/toggle",
                type: "POST",
                data: {store_id: storeId},
                beforeSend: function (xhr) {
                    xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
                }
            }).done(function (res) {
                window.updateFavoriteButton(!!res.favorite);
                window.updateFavoriteCount(res.count);
            }).fail(function() {
                alert(t("common.favoriteError", "즐겨찾기 처리 중 오류가 발생했습니다."));
            });
        });

        // 8. 초기 상태 실행
        window.loadFavoriteStatus();
        window.loadAvailableSlots();

        // 9. WebSocket (실시간 조회 인원)
        if (typeof SockJS !== "undefined" && typeof Stomp !== "undefined") {
            const socket = new SockJS(app.dataset.context + "/ws_waiting");
            const stomp = Stomp.over(socket);
            stomp.debug = null;
            stomp.connect({}, function () {
                stomp.subscribe("/topic/store/" + app.dataset.storeId + "/viewers", (msg) => {
                    const viewerCountEl = $("#viewerCount");
                    viewerCountEl.text(
                        t("storeDetail.viewerPrefix", "현재 조회 중:") + " " + 
                        msg.body + 
                        t("storeDetail.viewerSuffix", "명"));
                });
            });
        }
    });
})(jQuery);