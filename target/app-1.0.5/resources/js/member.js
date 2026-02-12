/* src/main/webapp/resources/js/member.js */
$(document).ready(function() {
    // i18n 유틸리티 함수 초기화
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };


    // [2] 새 로직: 회원가입 상태 관리 변수
    let isIdChecked = false;
    let isPwMatched = false;


    // [3] 새 로직: 아이디 중복 확인 (AJAX)
    $("#btnIdCheck").click(function() {
        const userId = $("#user_id").val();

        if(userId.length < 3) {
            alert(t("member.idMinLength", "아이디는 최소 3자 이상이어야 합니다."));
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
                    var idAvailable = t("member.idAvailable", "사용 가능한 아이디입니다.");
                    $("#idCheckMsg").html("<span class='msg-ok'>" + idAvailable + "</span>");
                    isIdChecked = true;
                } else {
                    var idInUse = t("member.idInUse", "이미 사용 중인 아이디입니다.");
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
            var pwMatch = t("member.pwMatch", "비밀번호가 일치합니다.");
            $("#pwCheckMsg").html("<span class='msg-ok'>" + pwMatch + "</span>");
            isPwMatched = true;
        } else {
            var pwMismatch = t("member.pwMismatch", "비밀번호가 일치하지 않습니다.");
            $("#pwCheckMsg").html("<span class='msg-no'>" + pwMismatch + "</span>");
            isPwMatched = false;
        }
    });


    // [5] 새 로직: 회원가입 및 단계별 폼 최종 검증
    $("#joinForm, #ownerStep2Form").submit(function() {
        // 아이디 중복확인 여부 체크
        if($("#user_id").length > 0 && !isIdChecked) {
            alert(t("member.idCheckPrompt", "아이디 중복확인을 해주세요."));
            return false;
        }

        // 비밀번호 일치 여부 체크
        if($("#user_pw").length > 0 && !isPwMatched) {
            alert(t("member.pwMismatchAlert", "비밀번호가 일치하지 않습니다."));
            return false;
        }

        // 점주 가입 2단계: 위치 정보 체크
        if($("#store_lat").length > 0 && $("#store_lat").val() == "0.0") {
            alert(t("member.storeLocationRequired", "주소 검색을 통해 위치 정보를 입력해주세요."));
            return false;
        }

        return true;
    });
});