/* src/main/webapp/resources/js/store_detail.js */

/**
 * 고메패스 맛집 상세 페이지 전용 스크립트 [v1.0.8]
 * 기능: 메뉴 토글, 동적 타임슬롯(중복 방지), 예약/웨이팅 섹션 제어, 카카오 지도 연동
 */

$(document).ready(function() {
    // [1] 초기 설정: JSP의 #storeDetailApp 요소에서 데이터 속성 읽기
    const app = document.getElementById('storeDetailApp');
    if (!app) return;

    const STORE_CONF = {
        id: app.dataset.storeId, // JSP에서 추가된 store_id
        lat: app.dataset.lat,
        lng: app.dataset.lng,
        name: app.dataset.name,
        contextPath: app.dataset.context
    };

    // [2] 지도 초기화
    if (STORE_CONF.lat && STORE_CONF.lng) {
        const container = document.getElementById('map');
        if (container) {
            const options = {
                center: new kakao.maps.LatLng(STORE_CONF.lat, STORE_CONF.lng),
                level: 3
            };
            const map = new kakao.maps.Map(container, options);
            const marker = new kakao.maps.Marker({ position: options.center });
            marker.setMap(map);
        }
    }

    /**
     * [교정] 3. 오늘 날짜 자동 설정 및 히든 필드 주입
     */
    function setInitialDate() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const todayStr = year + "-" + month + "-" + day;
        
        $("#bookDate").val(todayStr);
    }

    /**
     * [핵심 리팩토링] 4. 실시간 예약 가능 시간 슬롯 로드 (중복 예약 차단)
     * 서버의 API(/store/api/timeSlots)를 호출하여 이미 예약된 시간을 제외한 목록만 표시합니다.
     */
    function loadAvailableSlots() {
        const bookDate = $("#bookDate").val();
        const container = $("#timeSlotContainer");

        if (!bookDate || !container.length) return;

        // 로딩 중 표시
        container.html("<p style='color:gray; padding:10px;'>예약 가능 시간을 확인 중입니다...</p>");
        $("#selectedTime").val(""); // 날짜 변경 시 이전 선택값 초기화

        $.ajax({
            url: STORE_CONF.contextPath + "/store/api/timeSlots",
            type: "GET",
            data: { 
                store_id: STORE_CONF.id, 
                book_date: bookDate 
            },
            dataType: "json",
            success: function(list) {
                let html = "";
                if (list && list.length > 0) {
                    list.forEach(time => {
                        // 현재 시간 기준 10분 이후 슬롯인지 체크하는 로직은 서버에서 처리하여 전달받는 것이 안전함
                        html += '<button type="button" class="time-btn" data-time="' + time + '">' + time + '</button>';
                    });
                } else {
                    html = "<p style='color:gray; padding:20px;'>해당 날짜는 모든 예약이 마감되었습니다.</p>";
                }
                container.html(html);
            },
            error: function() {
                container.html("<p style='color:red; padding:10px;'>시간 정보를 불러오지 못했습니다.</p>");
            }
        });
    }

    // [5] 이벤트 바인딩: 타임 버튼 클릭
    $(document).on("click", ".time-btn", function() {
        $(".time-btn").removeClass("active");
        $(this).addClass("active");
        $("#selectedTime").val($(this).data("time"));
    });

    // [6] 예약 폼 검증
    $("#bookForm").on("submit", function() {
        const selectedTime = $("#selectedTime").val();
        if(!selectedTime) {
            alert("방문 시간을 선택해 주세요!");
            return false;
        }
        return confirm(selectedTime + "시에 예약을 진행할까요?\n(한 타임당 한 팀만 선착순 예약이 가능합니다.)");
    });

    // [7] 초기 실행 로직
    setInitialDate();
    loadAvailableSlots();
});

/**
 * 전역 함수: 메뉴 토글 (JSP 인라인 onclick 대응)
 */
function toggleMenus() {
    const area = $("#other-menu-area");
    const btn = $("#menu-toggle-btn");
    if(area.is(":hidden")) {
        area.slideDown();
        btn.text("메뉴 접기 ↑");
    } else {
        area.slideUp();
        btn.text("전체 메뉴 보기 ↓");
    }
}

/**
 * 전역 함수: 예약/웨이팅 섹션 전환 (JSP 인라인 onclick 대응)
 */
function showInteraction(type) {
    $(".interaction-card").hide();
    const target = $("#" + type + "-area");
    
    if (target.length) {
        target.fadeIn();
        $('html, body').animate({
            scrollTop: target.offset().top - 100
        }, 500);
    }

    $(".btn-main-wire").removeClass("active");
    $(".btn-" + type).addClass("active");
}