/* Find account email auth for password reset [v2.0.0] */
/* 수정사항: I18N_UTIL.t() 방식으로 통일 */

(function($) {
    // ✅ main.js 방식으로 통일: I18N_UTIL.t 사용
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    $(document).ready(function() {
        $("#btnPwAuth").on("click", function() {
            const userId = $("#pw_user_id").val();
            const email = $("#pw_user_email").val();

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