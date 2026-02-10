/* src/main/webapp/resources/js/member.js */
$(document).ready(function() {
    var MEMBER_I18N = (window.I18N && window.I18N.member) ? window.I18N.member : {};
    
    // [1] 기존 로직: 로그인/로그아웃 알림 (사용자님 제공 코드)
    const error = $("#auth-msg").data("error");
    const logout = $("#auth-msg").data("logout");

    if (error) alert(MEMBER_I18N.loginError || "");
    if (logout) alert(MEMBER_I18N.logoutSuccess || "");


    // [2] 새 로직: 회원가입 상태 관리 변수
    let isIdChecked = false;
    let isPwMatched = false;


    // [3] 새 로직: 아이디 중복 확인 (AJAX)
    $("#btnIdCheck").click(function() {
        const userId = $("#user_id").val();
        
        if(userId.length < 3) {
            alert(MEMBER_I18N.idMinLength || "");
            return;
        }

        $.ajax({
            url: APP_CONFIG.contextPath + "/member/idCheck",
            type: "POST",
            data: { 
                user_id: userId, 
                [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken 
            },
            success: function(res) {
                if(res === "success") {
                    var idAvailable = MEMBER_I18N.idAvailable || "";
                    $("#idCheckMsg").html("<span class='msg-ok'>" + idAvailable + "</span>");
                    isIdChecked = true;
                } else {
                    var idInUse = MEMBER_I18N.idInUse || "";
                    $("#idCheckMsg").html("<span class='msg-no'>" + idInUse + "</span>");
                    isIdChecked = false;
                }
            }
        });
    });


    // [4] 새 로직: 비밀번호 일치 여부 실시간 확인
    $("#user_pw, #user_pw_confirm").on("keyup", function() {
        const pw = $("#user_pw").val();
        const pwConfirm = $("#user_pw_confirm").val();

        if(pw === "" || pwConfirm === "") {
            $("#pwCheckMsg").empty();
            return;
        }

        if(pw === pwConfirm) {
            var pwMatch = MEMBER_I18N.pwMatch || "";
            $("#pwCheckMsg").html("<span class='msg-ok'>" + pwMatch + "</span>");
            isPwMatched = true;
        } else {
            var pwMismatch = MEMBER_I18N.pwMismatch || "";
            $("#pwCheckMsg").html("<span class='msg-no'>" + pwMismatch + "</span>");
            isPwMatched = false;
        }
    });


    // [5] 새 로직: 회원가입 및 단계별 폼 최종 검증
    $("#joinForm, #ownerStep2Form").submit(function() {
        // 아이디 중복확인 여부 체크
        if($("#user_id").length > 0 && !isIdChecked) {
            alert(MEMBER_I18N.idCheckPrompt || "");
            return false;
        }
        
        // 비밀번호 일치 여부 체크
        if($("#user_pw").length > 0 && !isPwMatched) {
            alert(MEMBER_I18N.pwMismatchAlert || "");
            return false;
        }

        // 점주 가입 2단계: 위치 정보 체크
        if($("#store_lat").length > 0 && $("#store_lat").val() == "0.0") {
            alert(MEMBER_I18N.storeLocationRequired || "");
            return false;
        }

        return true;
    });
    
    /**
 * 회원 탈퇴 처리
 */
function dropUser(userId) {
    var withdrawConfirm = MEMBER_I18N.withdrawConfirmSimple || "";
    if (confirm(withdrawConfirm)) {
        // 탈퇴 프로세스 호출 (CSRF 토큰 필요)
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = APP_CONFIG.contextPath + '/member/withdraw';
        
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = APP_CONFIG.csrfName;
        csrfInput.value = APP_CONFIG.csrfToken;
        
        form.appendChild(csrfInput);
        document.body.appendChild(form);
        form.submit();
    }
}

});
