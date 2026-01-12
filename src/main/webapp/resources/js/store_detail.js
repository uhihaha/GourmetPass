/* /resources/js/store_detail.js */

// 1. 메뉴 토글
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

// 2. 예약/웨이팅 섹션 노출
function showInteraction(type) {
    $(".interaction-card").hide();
    $("#" + type + "-area").fadeIn();
    $('html, body').animate({
        scrollTop: $("#" + type + "-area").offset().top - 100
    }, 500);
}

// 3. 타임슬롯 생성
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
    container.html(html || "<p style='color:gray;'>예약 가능한 시간이 없습니다.</p>");
}

function setTime(btn, t) {
    $(".time-btn").removeClass("active");
    $(btn).addClass("active");
    $("#selectedTime").val(t);
}

function validateForm() {
    if(!$("#selectedTime").val()) {
        alert("방문 시간을 선택해 주세요!");
        return false;
    }
    return confirm($("#selectedTime").val() + "시에 예약을 진행할까요?");
}

// 4. 지도 및 기초 초기화
$(document).ready(function() {
    // 카카오 지도 로드
    if (STORE_CONF.lat && STORE_CONF.lng) {
        const container = document.getElementById('map');
        const options = {
            center: new kakao.maps.LatLng(STORE_CONF.lat, STORE_CONF.lng),
            level: 3
        };
        const map = new kakao.maps.Map(container, options);
        const marker = new kakao.maps.Marker({ position: options.center });
        marker.setMap(map);
    }

    // 오늘 날짜 기본 세팅
    const dateObj = new Date();
    const dateStr = dateObj.getFullYear() + "-" + 
                  String(dateObj.getMonth() + 1).padStart(2, '0') + "-" + 
                  String(dateObj.getDate()).padStart(2, '0');
    $("#bookDate").val(dateStr);

    loadSlots();
});