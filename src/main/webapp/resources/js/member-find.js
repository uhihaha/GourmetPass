/* src/main/webapp/resources/js/member-find.js [v2.5.5] */
/* 수정사항: 1. 브라우저 말풍선 완전 대체 (Manual Validation) / 2. 아이디 찾기 AJAX 통합 */

(function($) {
    // ✅ i18n 유틸리티 초기화
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    $(document).ready(function() {
        
        /**
         * [A] 수동 유효성 검사 및 Alert 메시지 추출 함수
         * novalidate 설정으로 인해 제출 시 직접 호출하여 첫 번째 에러를 alert으로 띄웁니다.
         */
        const validateFormManual = (form) => {
            if (form.checkValidity()) return true;

            const invalidEl = $(form).find(":invalid").get(0);
            if (invalidEl) {
                let msgKey = "";
                let fallback = "입력값을 확인해주세요.";

                // 요소별 ID에 따른 다국어 키 매칭
                switch(invalidEl.id) {
                    case "find_id_nm": 
                        msgKey = "signup.nameRequired"; fallback = "이름을 입력해주세요."; break;
                    case "pw_user_id": 
                        msgKey = "signup.idRequired"; fallback = "아이디를 입력해주세요."; break;
                    case "find_id_email":
                    case "pw_user_email":
                        msgKey = invalidEl.validity.valueMissing ? "signup.emailRequired" : "signup.emailInvalid";
                        fallback = invalidEl.validity.valueMissing ? "이메일을 입력해주세요." : "올바른 이메일 형식이 아닙니다.";
                        break;
                    case "pw_auth_code": 
                        // 다국어 안됨을 해결하기 위해 반드시 properties 파일에 signup.authCodeRequired 키를 추가해야 합니다.
                        msgKey = "signup.authCodeRequired"; 
                        fallback = "인증코드를 입력해주세요."; 
                        break;
                }

                alert(t(msgKey, fallback));
                invalidEl.focus();
            }
            return false;
        };

        /**
         * [B] 아이디 찾기 - AJAX 검색
         */
        $("#findIdForm").on("submit", function(e) {
            e.preventDefault(); 
            if (!validateFormManual(this)) return false;

            $.ajax({
                url: APP_CONFIG.contextPath + "/member/find/id/ajax",
                type: "POST",
                data: { 
                    user_nm: $("#find_id_nm").val(), 
                    user_email: $("#find_id_email").val(),
                    [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken 
                },
                success: function(res) {
                    if(res.status === "success") {
                        alert(t("member.find.id.result", "회원님의 아이디는 [" + res.userId + "] 입니다.").replace("{0}", res.userId));
                    } else {
                        alert(t("memberFind.authNotFound", "일치하는 회원 정보가 없습니다."));
                    }
                },
                error: function() {
                    alert(t("common.serverError", "서버 오류가 발생했습니다."));
                }
            });
        });

        /**
         * [C] 비밀번호 재설정 폼 제출 제어
         * novalidate 속성 대응을 위해 제출 전 수동으로 검증을 수행합니다.
         */
        $(document).on("submit", "form[action*='/member/find/password']", function(e) {
            if (!validateFormManual(this)) {
                e.preventDefault();
                return false;
            }
        });

        /**
         * [D] 비밀번호 재설정 - 이메일 인증코드 발송 (AJAX)
         */
        $("#btnPwAuth").on("click", function() {
            const userId = $("#pw_user_id").val();
            const email = $("#pw_user_email").val();

            if (!userId || !email) {
                alert(t("memberFind.authMissing", "아이디와 이메일을 모두 입력해주세요."));
                return;
            }

            $.ajax({
                url: APP_CONFIG.contextPath + "/member/password/emailAuth",
                type: "POST",
                data: { 
                    user_id: userId, 
                    user_email: email,
                    [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken 
                },
                success: function(res) {
                    if (res === "success") {
                        $("#pwAuthMsg").html("<span class='msg-ok'>" + t("memberFind.authSent", "인증 코드가 발송되었습니다.") + "</span>");
                        $("#pw_auth_code").focus();
                    } else {
                        $("#pwAuthMsg").html("<span class='msg-no'>" + t("memberFind.authNotFound", "일치하는 회원 정보가 없습니다.") + "</span>");
                    }
                },
                error: function() {
                    alert(t("memberFind.authServerError", "서버 오류가 발생했습니다."));
                }
            });
        });
    });
})(jQuery);