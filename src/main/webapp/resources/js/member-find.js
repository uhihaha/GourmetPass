/* Find account email auth for password reset */
(function($) {
    $(document).ready(function() {
        $("#btnPwAuth").on("click", function() {
            const userId = $("#pw_user_id").val();
            const email = $("#pw_user_email").val();
            if (!userId || !email) {
                $("#pwAuthMsg").html("<span class='msg-no'>아이디와 이메일을 입력해주세요.</span>");
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
                        $("#pwAuthMsg").html("<span class='msg-ok'>인증코드를 발송했습니다.</span>");
                        $("#pw_auth_code").focus();
                    } else if (res === "not_found") {
                        $("#pwAuthMsg").html("<span class='msg-no'>일치하는 계정을 찾을 수 없습니다.</span>");
                    } else {
                        $("#pwAuthMsg").html("<span class='msg-no'>요청을 처리할 수 없습니다.</span>");
                    }
                },
                error: function() {
                    $("#pwAuthMsg").html("<span class='msg-no'>서버 통신 오류가 발생했습니다.</span>");
                }
            });
        });
    });
})(jQuery);
