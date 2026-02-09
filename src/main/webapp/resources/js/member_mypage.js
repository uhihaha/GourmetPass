/* src/main/webapp/resources/js/member_mypage.js [v1.0.6] */
var MYPAGE_I18N = (window.I18N && window.I18N.mypage) ? window.I18N.mypage : {};

/**
 * [공통 함수] POST 폼 생성 및 전송 (CSRF 자동 포함)
 * 405 에러 방지 및 코드 중복 제거를 위해 모든 POST 요청을 이 함수로 통합합니다.
 */
function submitPostForm(url, params) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = APP_CONFIG.contextPath + url;

    // 파라미터 구성 (CSRF 토큰 필수 포함)
    var fields = params || {};
    fields[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;

    for (var key in fields) {
        if (fields.hasOwnProperty(key)) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = fields[key];
            form.appendChild(input);
        }
    }

    document.body.appendChild(form);
    form.submit();
}

/**
 * 메뉴 삭제 (점주용)
 */
function deleteMenu(menuId) {
    var menuDeleteConfirm = MYPAGE_I18N.menuDeleteConfirm || "";
    if (!confirm(menuDeleteConfirm)) return;
    submitPostForm('/store/menu/delete', { 'menu_id': menuId });
}

/**
 * 웨이팅 취소 (사용자용)
 */
function cancelWait(waitId) {
    var waitCancelConfirm = MYPAGE_I18N.waitCancelConfirm || "";
    if (!confirm(waitCancelConfirm)) return;
    submitPostForm('/wait/cancel', { 'wait_id': waitId });
}

/**
 * 리뷰 삭제 (공통)
 */
function confirmDeleteReview(reviewId, storeId, returnUrl) {  // ← returnUrl 파라미터 추가
    var reviewDeleteConfirm = MYPAGE_I18N.reviewDeleteConfirm || "";
    if (!confirm(reviewDeleteConfirm)) return;
    
    var params = { 
        'review_id': reviewId, 
        'store_id': storeId 
    };
    
    // returnUrl이 있으면 추가
    if (returnUrl) {
        params['returnUrl'] = returnUrl;
    }
    
    submitPostForm('/review/delete', params);
}

/**
 * 회원 탈퇴 (Fetch API 사용)
 */
function dropUser(userId) {
    var userDropConfirm = MYPAGE_I18N.userDropConfirm || "";
    if (!confirm(userDropConfirm)) return;

    fetch(APP_CONFIG.contextPath + '/member/delete', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken
        },
        body: "user_id=" + encodeURIComponent(userId)
    })
    .then(function(response) {
        if (response.redirected) {
            var userDropSuccess = MYPAGE_I18N.userDropSuccess || "";
            alert(userDropSuccess);
            location.href = response.url;
            return;
        }
        return response.text();
    })
    .catch(function(error) {
        console.error('Error:', error);
    });
}

/**
 * 전체 이용 내역 토글 (wait_status.jsp)
 */
function toggleHistory() {
    var area = document.getElementById('full-history-area') || document.getElementById('history-area');
    var btn = document.getElementById('history-toggle-btn') || document.getElementById('toggle-history');
    
    if (!area || !btn) return;

    if (area.style.display === 'none' || area.style.display === '') {
        area.style.display = 'block';
        var historyClose = MYPAGE_I18N.historyClose || "";
        var historyCollapse = MYPAGE_I18N.historyCollapse || "";
        btn.innerText = (btn.id === 'history-toggle-btn') ? historyClose : historyCollapse;
    } else {
        area.style.display = 'none';
        var historyOpen = MYPAGE_I18N.historyOpen || "";
        btn.innerText = historyOpen;
    }
}

/**
 * 웹소켓 실시간 알림 설정
 */
var stompClient = null;

function initMyPageWebSocket(userId, role, storeId) {
    if (typeof SockJS === 'undefined' || typeof Stomp === 'undefined') return;

    var socket = new SockJS(APP_CONFIG.contextPath + '/ws_waiting');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log('WebSocket Connected: ' + frame);

        // 일반 유저: 개인 채널 구독 (/topic/wait/{userId})
        if (role === 'ROLE_USER' && userId) {
            stompClient.subscribe('/topic/wait/' + userId, function (message) {
                showNotification(message.body);
            });
        }

        // 점주: 가게 채널 구독
        if (role === 'ROLE_OWNER' && storeId) {
            stompClient.subscribe('/topic/store/' + storeId, function (message) {
                showNotification(message.body);
            });
        }
    }, function(error) {
        console.error('WebSocket Error:', error);
    });
}

function showNotification(message) {
    var notificationPrefix = MYPAGE_I18N.notificationPrefix || "";
    alert(notificationPrefix + " " + message);
    location.reload(); // 상태 변경 즉시 반영을 위해 새로고침
}

/**
 * 페이지 로드 시 공통 실행 로직
 */
document.addEventListener("DOMContentLoaded", function() {
    // 1. 스크롤 위치 복원
    var savedScrollPos = sessionStorage.getItem("manageScrollPos");
    if (savedScrollPos) {
        window.scrollTo(0, parseInt(savedScrollPos));
        sessionStorage.removeItem("manageScrollPos");
    }

    // 2. 폼 제출 시 스크롤 위치 저장 (점주 관리 페이지 편의성)
    var forms = document.querySelectorAll('form');
    for (var i = 0; i < forms.length; i++) {
        forms[i].addEventListener('submit', function() {
            sessionStorage.setItem("manageScrollPos", window.scrollY);
        });
    }

    // 3. 웹소켓 자동 초기화
    if (typeof APP_CONFIG !== 'undefined') {
        var userId = APP_CONFIG.userId || null;
        var role = APP_CONFIG.role || null;
        var storeId = APP_CONFIG.storeId || null;

        initMyPageWebSocket(userId, role, storeId);
    }
});
