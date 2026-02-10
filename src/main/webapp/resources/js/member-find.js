/* src/main/webapp/resources/js/member-find.js [v2.5.0] */
/* 수정사항: 툴팁 다국어화(Validation Localization) 추가 및 AJAX 로직 최적화 */

(function($) {
    // ✅ i18n 유틸리티 초기화
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    $(document).ready(function() {
        
        /**
         * [A] 브라우저 기본 검증 메시지(Tooltip) 다국어화 함수
         */
        const applyI18nValidation = (id, key, fallback) => {
            const el = document.getElementById(id);
            if (el) {
                // 검증 실패 시 호출
                el.addEventListener("invalid", function() {
                    this.setCustomValidity(t(key, fallback));
                });
                // 입력 시 에러 초기화
                el.addEventListener("input", function() {
                    this.setCustomValidity("");
                });
            }
        };

        // 1. 아이디 찾기 섹션 툴팁 적용
        applyI18nValidation("find_id_nm", "signup.nameRequired", "이름을 입력해주세요.");
        applyI18nValidation("find_id_email", "signup.emailRequired", "이메일을 입력해주세요.");

        // 2. 비밀번호 재설정 섹션 툴팁 적용
        applyI18nValidation("pw_user_id", "signup.idRequired", "아이디를 입력해주세요.");
        applyI18nValidation("pw_user_email", "signup.emailRequired", "이메일을 입력해주세요.");
        applyI18nValidation("pw_auth_code", "memberFind.authMissing", "인증코드를 입력해주세요.");

        /**
         * [B] 비밀번호 재설정 - 이메일 인증코드 발송 (AJAX)
         */
        $("#btnPwAuth").on("click", function() {
            const userId = $("#pw_user_id").val();
            const email = $("#pw_user_email").val();

            // 유효성 체크
            if (!userId || !email) {
                $("#pwAuthMsg").html("<span class='msg-no'>" + 
                    t("memberFind.authMissing", "아이디와 이메일을 모두 입력해주세요.") + 
                    "</span>");
                return;
            }

            const ajaxData = { user_id: userId, user_email: email };
            if (typeof APP_CONFIG !== 'undefined') {
                ajaxData[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;
            }

            $.ajax({
                url: (typeof APP_CONFIG !== 'undefined' ? APP_CONFIG.contextPath : "") + "/member/password/emailAuth",
                type: "POST",
                data: ajaxData,
                success: function(res) {
                    if (res === "success") {
                        $("#pwAuthMsg").html("<span class='msg-ok'>" + 
                            t("memberFind.authSent", "인증 코드가 발송되었습니다.") + 
                            "</span>");
                        $("#pw_auth_code").focus();
                    } else if (res === "not_found") {
                        $("#pwAuthMsg").html("<span class='msg-no'>" + 
                            t("memberFind.authNotFound", "일치하는 회원 정보가 없습니다.") + 
                            "</span>");
                    } else {
                        $("#pwAuthMsg").html("<span class='msg-no'>" + 
                            t("memberFind.authUnavailable", "인증 코드 발송에 실패했습니다.") + 
                            "</span>");
                    }
                },
                error: function() {
                    $("#pwAuthMsg").html("<span class='msg-no'>" + 
                        t("memberFind.authServerError", "서버 오류가 발생했습니다.") + 
                        "</span>");
                }
            });
        });
    });
})(jQuery);