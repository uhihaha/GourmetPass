/* store-detail.js */
let isExpanded = false;

// 1. 메뉴 토글 함수
function toggleMenus() {
    const area = $("#other-menu-area");
    const btn = $("#menu-toggle-btn");
    if (!isExpanded) {
        area.slideDown(400);
        btn.text("메뉴 접기 ↑");
        isExpanded = true;
    } else {
        area.slideUp(400);
        btn.text("전체 메뉴 보기 ↓");
        isExpanded = false;
    }
}

// 2. 예약/웨이팅 인터랙션 전환
function showInteraction(type) {
    if(type === 'booking') {
        $("#waiting-area").hide();
        $("#booking-area").fadeIn(300);
    } else {
        $("#booking-area").hide();
        $("#waiting-area").fadeIn(300);
    }
}

// 3. 타임슬롯 생성 로직
function loadSlots() {
    const open = STORE_CONF.openTime || "09:00";
    const close = STORE_CONF.closeTime || "22:00";
    const unit = parseInt(STORE_CONF.resUnit) || 30;
    const container = $("#timeSlotContainer");

    const toMin = (t) => { 
        let p = t.split(':'); 
        return parseInt(p[0]) * 60 + parseInt(p[1]); 
    };
    const toStr = (m) => { 
        let h = Math.floor(m / 60); 
        let min = m % 60; 
        return (h < 10 ? "0"+h : h) + ":" + (min < 10 ? "0"+min : min); 
    };

    const start = toMin(open);
    const end = toMin(close);
    const now = new Date();
    const nowMin = (now.getHours() * 60) + now.getMinutes();

    let html = "";
    for (let m = start; m < end; m += unit) {
        let s = toStr(m);
        let dis = m < (nowMin + 10) ? "disabled" : "";
        html += `<button type="button" class="time-btn" ${dis} onclick="setTime(this, '${s}')">${s}</button>`;
    }
    container.html(html || "<p style='color:gray;'>가능한 시간이 없습니다.</p>");
}

// 4. 시간 선택 핸들러
function setTime(btn, t) {
    $(".time-btn").removeClass("active");
    $(btn).addClass("active");
    $("#selectedTime").val(t);
}

// 5. 예약 폼 검증
function validateForm() {
    if(!$("#selectedTime").val()) {
        alert("시간을 선택해주세요!");
        return false;
    }
    return confirm($("#selectedTime").val() + "시에 예약하시겠습니까?");
}

// 6. 초기화
$(document).ready(function() {
    // 지도 초기화
    if (STORE_CONF.lat && STORE_CONF.lng) {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(STORE_CONF.lat, STORE_CONF.lng),
            level: 3
        };
        var map = new kakao.maps.Map(container, options);
        var marker = new kakao.maps.Marker({ position: options.center });
        marker.setMap(map);
    }

    // 오늘 날짜 세팅
    var dateObj = new Date();
    var dateStr = dateObj.getFullYear() + "-" + 
                  String(dateObj.getMonth() + 1).padStart(2, '0') + "-" + 
                  String(dateObj.getDate()).padStart(2, '0');
    $("#bookDate").val(dateStr);

    // 타임슬롯 생성
    loadSlots();
});