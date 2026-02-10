/* Find account email auth for password reset */
(function($) {
    $(document).ready(function() {
        var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
            ? window.I18N_UTIL.t
            : function(key, fallback) { return fallback || key; };
        $("#btnPwAuth").on("click", function() {
            const userId = $("#pw_user_id").val();
            const email = $("#pw_user_email").val();
            if (!userId || !email) {
                var authMissing = t("memberFind.authMissing", "아이디와 이메일을 입력해 주세요.");
                $("#pwAuthMsg").html("<span class='msg-no'>" + authMissing + "</span>");
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
                        var authSent = t("memberFind.authSent", "인증코드를 발송했습니다.");
                        $("#pwAuthMsg").html("<span class='msg-ok'>" + authSent + "</span>");
                        $("#pw_auth_code").focus();
                    } else if (res === "not_found") {
                        var authNotFound = t("memberFind.authNotFound", "일치하는 회원 정보를 찾을 수 없습니다.");
                        $("#pwAuthMsg").html("<span class='msg-no'>" + authNotFound + "</span>");
                    } else {
                        var authUnavailable = t("memberFind.authUnavailable", "인증 요청을 처리할 수 없습니다.");
                        $("#pwAuthMsg").html("<span class='msg-no'>" + authUnavailable + "</span>");
                    }
                },
                error: function() {
                    var authServerError = t("memberFind.authServerError", "서버 오류가 발생했습니다.");
                    $("#pwAuthMsg").html("<span class='msg-no'>" + authServerError + "</span>");
                }
            });
        });
    });
})(jQuery);
