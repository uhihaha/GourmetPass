/**
 * 마이페이지 공통 스크립트 (일반 회원 / 점주 공용)
 * 기능: 회원 탈퇴, 메뉴 삭제, 실시간 웹소켓 알림 수신
 */

// 1. 회원 탈퇴 요청 (MemberController.java의 @PostMapping("/delete")와 연동)
function dropUser(userId) {
    if (!confirm("정말로 탈퇴하시겠습니까? 모든 정보가 삭제됩니다.")) return;

    // fetch를 이용한 AJAX 요청
    fetch(APP_CONFIG.contextPath + '/member/delete', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken
        },
        body: "user_id=" + encodeURIComponent(userId)
    })
    .then(response => {
        if (response.redirected) {
            alert("정상적으로 탈퇴되었습니다.");
            location.href = response.url;
            return;
        }
        return response.text();
    })
    .catch(error => console.error('Error:', error));
}

// 2. 메뉴 삭제 요청 (점주용)
function deleteMenu(menuId) {
    if (!confirm("이 메뉴를 삭제하시겠습니까?")) return;

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = APP_CONFIG.contextPath + '/store/menu/delete';
    
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'menu_id';
    input.value = menuId;
    
    const csrf = document.createElement('input');
    csrf.type = 'hidden';
    csrf.name = APP_CONFIG.csrfName;
    csrf.value = APP_CONFIG.csrfToken;
    
    form.appendChild(input);
    form.appendChild(csrf);
    document.body.appendChild(form);
    form.submit();
}

// 3. 웹소켓 실시간 알림 설정 (로드맵 1단계 및 3, 4단계)
let stompClient = null;

function initMyPageWebSocket(userId, role, storeId) {
    const socket = new SockJS(APP_CONFIG.contextPath + '/ws_waiting');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log('WebSocket Connected: ' + frame);

        // [일반 회원] 본인 아이디 채널 구독: 입장 호출 알림 수신
        if (role === 'ROLE_USER') {
            stompClient.subscribe('/topic/wait/' + userId, function (message) {
                showNotification("🔔 알림: " + message.body);
            });
        }

        // [점주] 매장 채널 구독: 새로운 웨이팅/예약 접수 알림 수신
        if (role === 'ROLE_OWNER' && storeId) {
            stompClient.subscribe('/topic/store/' + storeId, function (message) {
                showNotification("📩 새 주문: " + message.body);
                // 실시간 리스트 갱신이 필요할 경우 여기서 reload 혹은 Ajax 호출
            });
        }
    });
}

// 알림 표시 함수 (디자인에 맞춰 토스트 메시지 등으로 확장 가능)
function showNotification(message) {
    alert(message);
    // 상태 변경을 시각적으로 보여주기 위해 페이지 리로드 가능
    location.reload();
}