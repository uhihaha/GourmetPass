/* GourmetPass 통합 회원 관리 스크립트 (가입/수정/탈퇴/알림/가게정보) */

(function($) {
    const MEMBER_I18N = (window.I18N && window.I18N.member) ? window.I18N.member : {};
    // 1. 전역 상태 변수 설정
    let isIdChecked = false; 
    let isPwMatched = false;
    let isEmailChecked = false; 
    let authCode = "";         
    let timerInterval;
    let initialEmail = ""; 
    const ID_PATTERN = /^[a-zA-Z0-9_]{4,20}$/;
    const PASSWORD_PATTERN = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]).{8,20}$/;

    $(document).ready(function() {
        const isSocialSignup = $("#joinForm input[name='social_signup']").length > 0;
        const skipEmailAuth = $("#joinForm input[name='skip_email_auth']").length > 0;
        
        // [A] 로그인/로그아웃 알림 (기존 member.js 이관)
        const authMsgBox = $("#auth-msg");
        if(authMsgBox.length > 0) {
            const error = authMsgBox.data("error");
            const logout = authMsgBox.data("logout");
            if (error) alert(MEMBER_I18N.loginError || "");
            if (logout) alert(MEMBER_I18N.logoutSuccess || "");
        }

        // [B] 초기 데이터 세팅 및 수정 모드 감지
        initialEmail = $("#user_email").val() || ""; 
        
        // 수정 페이지 대응: 아이디가 readonly라면 중복확인 및 이메일인증 초기값 통과
        if($("#user_id").prop("readonly")) {
            isIdChecked = true;
            isEmailChecked = true; 
            console.log("Mode: Edit Mode Detected (Validation Adjusted)");
        }
        if (isSocialSignup) {
            isIdChecked = true;
            isPwMatched = true;
            isEmailChecked = true;
        }
        if (skipEmailAuth) {
            isEmailChecked = true;
            $("#btnEmailAuth").prop("disabled", true);
            $("#auth_code").prop("disabled", true);
            $("#timer").text("");
            $("#authMsg").text("");
        }

        // 1. 아이디 중복 확인 (AJAX)
        $("#btnIdCheck").click(function() {
            if($("#user_id").prop("readonly")) return;

            const userId = $("#user_id").val();
            if(!ID_PATTERN.test(userId)) {
                var idRule = MEMBER_I18N.idRule || "";
                $("#idCheckMsg").html("<span class='msg-no'>" + idRule + "</span>");
                isIdChecked = false;
                return;
            }

            const ajaxData = { user_id: userId };
            if (typeof APP_CONFIG !== 'undefined') {
                ajaxData[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;
            }

            $.ajax({
                url: (typeof APP_CONFIG !== 'undefined' ? APP_CONFIG.contextPath : "") + "/member/idCheck",
                type: "POST",
                data: ajaxData,
                success: function(res) {
                    if(res === "success") { 
                        var idAvailable = MEMBER_I18N.idAvailable || "";
                        $("#idCheckMsg").html("<span class='msg-ok'>" + idAvailable + "</span>"); 
                        isIdChecked = true; 
                    } else if (res === "invalid") {
                        var idInvalid = MEMBER_I18N.idInvalid || "";
                        $("#idCheckMsg").html("<span class='msg-no'>" + idInvalid + "</span>");
                        isIdChecked = false;
                    } else { 
                        var idInUse = MEMBER_I18N.idInUse || "";
                        $("#idCheckMsg").html("<span class='msg-no'>" + idInUse + "</span>");
                        isIdChecked = false; 
                    }
                },
                error: function() { alert(MEMBER_I18N.serverError || ""); }
            });
        });

        // 아이디 입력 시 상태 초기화 (가입 모드 전용)
        $("#user_id").on("input", function() {
            if(!$(this).prop("readonly")) {
                isIdChecked = false; 
                const userId = $(this).val();
                if (userId.length === 0) {
                    $("#idCheckMsg").text("");
                    return;
                }
                if (!ID_PATTERN.test(userId)) {
                    var idRule = MEMBER_I18N.idRule || "";
                    $("#idCheckMsg").html("<span class='msg-no'>" + idRule + "</span>");
                } else {
                    $("#idCheckMsg").text("");
                }
            }
        });

        // 2. 비밀번호 일치 확인 (실시간)
        $("#user_pw, #user_pw_confirm").on("keyup change input", function() {
            const pw = $("#user_pw").val();
            const pwConfirm = $("#user_pw_confirm").val();
            
            // 수정 시: 변경하지 않을 경우(둘 다 공백) 통과
            if(pw === "" && pwConfirm === "") { 
                $("#pwCheckMsg").text(""); 
                if($("#user_id").prop("readonly")) isPwMatched = true; 
                return; 
            }

            if (!PASSWORD_PATTERN.test(pw)) {
                var pwRule = MEMBER_I18N.pwRule || "";
                $("#pwCheckMsg").html("<span class='msg-no'>" + pwRule + "</span>");
                isPwMatched = false;
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

        // 3. 이메일 변경 감지 (수정 모드 대응)
        $("#user_email").on("input change", function() {
            const currentEmail = $(this).val();
            if (currentEmail === initialEmail) {
                $("#emailMsg").text("");
                isEmailChecked = true; 
            } else {
                var emailChangeAuth = MEMBER_I18N.emailChangeAuth || "";
                $("#emailMsg").html("<span class='msg-no'>" + emailChangeAuth + "</span>");
                isEmailChecked = false;
            }
        });

        // 4. 이메일 인증코드 발송
        $("#btnEmailAuth").click(function() {
            const email = $("#user_email").val();
            if(!email) { alert(MEMBER_I18N.emailRequired || ""); return; }

            const ajaxData = { email: email };
            if (typeof APP_CONFIG !== 'undefined') {
                ajaxData[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;
            }

            $.ajax({
                url: (typeof APP_CONFIG !== 'undefined' ? APP_CONFIG.contextPath : "") + "/member/emailAuth",
                type: "POST",
                data: ajaxData,
                success: function(res) {
                    alert(MEMBER_I18N.emailAuthSent || "");
                    authCode = res; 
                    $("#auth_code").prop("disabled", false).val("").focus();
                    startTimer();
                },
                error: function() { alert(MEMBER_I18N.emailSendFail || ""); }
            });
        });

        // 5. 인증번호 실시간 확인
        $("#auth_code").on("keyup", function() {
            const inputCode = $(this).val();
            if(inputCode.length === 6) {
                if(Number(inputCode) === authCode) { 
                    var authSuccess = MEMBER_I18N.authSuccess || "";
                    $("#authMsg").html("<span class='msg-ok'>" + authSuccess + "</span>");
                    clearInterval(timerInterval);
                    $("#timer").text("");
                    $("#btnEmailAuth, #auth_code").prop("disabled", true);
                    $("#user_email").prop("readonly", true);
                    isEmailChecked = true;
                    initialEmail = $("#user_email").val(); // 인증된 이메일을 기준값으로 갱신
                } else {
                    var authMismatch = MEMBER_I18N.authMismatch || "";
                    $("#authMsg").html("<span class='msg-no'>" + authMismatch + "</span>");
                    isEmailChecked = false;
                }
            }
        });

        // 타이머 기능
        function startTimer() {
            let time = 180;
            clearInterval(timerInterval);
            timerInterval = setInterval(function() {
                let min = Math.floor(time / 60);
                let sec = time % 60;
                $("#timer").text((min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec));
                if (time-- <= 0) {
                    clearInterval(timerInterval);
                    $("#timer").text(MEMBER_I18N.timerExpired || "");
                    $("#auth_code").prop("disabled", true);
                }
            }, 1000);
        }

        // 6. 폼 전송 최종 검증 (가입 / 수정 공통)
        $("#joinForm").on("submit", function(e) {
            // 수정 모드일 경우 제출 직전 플래그 최종 동기화
            if($("#user_id").prop("readonly")) {
                isIdChecked = true; 
                if($("#user_pw").val() === "" && $("#user_pw_confirm").val() === "") isPwMatched = true;
                if($("#user_email").val() === initialEmail) isEmailChecked = true;
            }

            if (isSocialSignup) {
                return true;
            }
            if(!isIdChecked) { 
                alert(MEMBER_I18N.idCheckRequired || ""); 
                $("#user_id").focus();
                e.preventDefault(); return false; 
            }
            if(!isPwMatched) { 
                alert(MEMBER_I18N.pwCheckRequired || ""); 
                $("#user_pw").focus();
                e.preventDefault(); return false; 
            }
            if(!skipEmailAuth && !isEmailChecked) { 
                alert(MEMBER_I18N.emailAuthRequired || ""); 
                $("#user_email").focus();
                e.preventDefault(); return false; 
            }
            
            return true; 
        });

        // 7. 점주 가입 2단계 최종 검증
        $("#ownerStep2Form").on("submit", function(e) {
            const lat = $("#store_lat").val();
            const lon = $("#store_lon").val();

            // 주소 검색을 통한 좌표 설정 여부 확인
            if(!lat || lat === "0.0" || !lon || lon === "0.0") {
                alert(MEMBER_I18N.storeCoordRequired || "");
                e.preventDefault();
                return false;
            }
            return true;
        });
    });

    // [C] 회원 탈퇴 함수 (전역 노출 - JSP onclick 대응)
    window.dropUser = function(userId) {
        var withdrawConfirm = MEMBER_I18N.withdrawConfirm || "";
        if (confirm(withdrawConfirm)) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = (typeof APP_CONFIG !== 'undefined' ? APP_CONFIG.contextPath : "") + '/member/delete';
            
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = APP_CONFIG.csrfName;
            csrfInput.value = APP_CONFIG.csrfToken;
  
            const userIdInput = document.createElement('input');
            userIdInput.type = 'hidden';
            userIdInput.name = 'user_id';
            userIdInput.value = userId;
            
            form.appendChild(csrfInput);
            form.appendChild(userIdInput);
            document.body.appendChild(form);
            form.submit();
        }
    };

})(jQuery);
