/* src/main/webapp/resources/js/member-signup.js */

(function($) {
    // ✅ i18n 유틸리티 초기화
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    // 1. 전역 상태 변수 (검증 성공 여부 플래그)
    let isIdChecked = false; 
    let isPwMatched = false;
    let isEmailChecked = false; 
    let authCode = "";         
    let timerInterval;
    let initialEmail = ""; 
    
    // 정규표현식 수정 (JavaScript 리터럴 형식에 맞게 \ 하나로 조정)
    const ID_PATTERN = /^[a-zA-Z0-9_]{4,20}$/;
    const PASSWORD_PATTERN = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,20}$/;

    $(document).ready(function() {
        const isSocialSignup = $("#joinForm input[name='social_signup']").length > 0;
        const skipEmailAuth = $("#joinForm input[name='skip_email_auth']").length > 0;

        // [A] 로그인/로그아웃 알림 (기존 member.js 통합)
        const authMsgBox = $("#auth-msg");
        if(authMsgBox.length > 0) {
            const error = authMsgBox.data("error");
            const logout = authMsgBox.data("logout");
            if (error) alert(t("member.loginError", "로그인 중 오류가 발생했습니다."));
            if (logout) alert(t("member.logoutSuccess", "로그아웃되었습니다."));
        }

        // [B] 초기 데이터 세팅 및 모드 감지
        initialEmail = $("#user_email").val() || ""; 

        // 수정 모드 혹은 소셜 가입일 경우 초기 검증 패스 설정
        if($("#user_id").prop("readonly") || isSocialSignup) {
            isIdChecked = true;
            isPwMatched = true;
            isEmailChecked = true; 
            console.log("Validation: Pre-verified (Edit/Social Mode)");
        }
        
        if (skipEmailAuth) {
            isEmailChecked = true;
            $("#btnEmailAuth").prop("disabled", true);
            $("#auth_code").prop("disabled", true);
        }

        // 1. [AJAX] 아이디 중복 확인
        $("#btnIdCheck").click(function() {
            if($("#user_id").prop("readonly")) return;

            const userId = $("#user_id").val();
            if(!ID_PATTERN.test(userId)) {
                $("#idCheckMsg").html("<span class='msg-no'>" + 
                    t("signup.idPattern", "아이디 형식이 올바르지 않습니다.") + 
                    "</span>");
                isIdChecked = false;
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
                        $("#idCheckMsg").html("<span class='msg-ok'>" + 
                            t("member.idAvailable", "사용 가능한 아이디입니다.") + 
                            "</span>"); 
                        isIdChecked = true; 
                    } else { 
                        $("#idCheckMsg").html("<span class='msg-no'>" + 
                            t("member.idInUse", "이미 사용 중인 아이디입니다.") + 
                            "</span>");
                        isIdChecked = false; 
                    }
                },
                error: function() { 
                    alert(t("common.serverError", "서버 오류가 발생했습니다."));
                }
            });
        });

        // 아이디 재입력 시 중복체크 리셋
        $("#user_id").on("input", function() {
            if(!$(this).prop("readonly")) {
                isIdChecked = false; 
                $("#idCheckMsg").text("");
            }
        });

        // 2. 비밀번호 실시간 확인 (Match & Regex)
        $("#user_pw, #user_pw_confirm").on("keyup change input", function() {
            const pw = $("#user_pw").val();
            const pwConfirm = $("#user_pw_confirm").val();

            if(pw === "" && pwConfirm === "") { 
                $("#pwCheckMsg").text(""); 
                return; 
            }

            if (!PASSWORD_PATTERN.test(pw)) {
                $("#pwCheckMsg").html("<span class='msg-no'>" + 
                    t("signup.pwPattern", "비밀번호 형식이 올바르지 않습니다.") + 
                    "</span>");
                isPwMatched = false;
                return;
            }

            if(pw === pwConfirm) { 
                $("#pwCheckMsg").html("<span class='msg-ok'>" + 
                    t("member.pwMatch", "비밀번호가 일치합니다.") + 
                    "</span>"); 
                isPwMatched = true; 
            } else { 
                $("#pwCheckMsg").html("<span class='msg-no'>" + 
                    t("member.pwMismatch", "비밀번호가 일치하지 않습니다.") + 
                    "</span>"); 
                isPwMatched = false; 
            }
        });

        // 3. [AJAX] 이메일 인증코드 발송
        $("#btnEmailAuth").click(function() {
            const email = $("#user_email").val();
            if(!email) { 
                alert(t("signup.emailRequired", "이메일을 입력해 주세요."));
                return; 
            }

            $.ajax({
                url: APP_CONFIG.contextPath + "/member/emailAuth",
                type: "POST",
                data: { 
                    email: email, 
                    [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken 
                },
                success: function(res) {
                    alert(t("memberFind.authSent", "인증 코드가 발송되었습니다."));
                    authCode = res; 
                    $("#auth_code").prop("disabled", false).val("").focus();
                    startTimer();
                },
                error: function() { 
                    alert(t("memberFind.authUnavailable", "코드 발송에 실패했습니다."));
                }
            });
        });

        // 4. 인증코드 실시간 확인
        $("#auth_code").on("keyup", function() {
            const inputCode = $(this).val();
            if(inputCode.length === 6) {
                if(Number(inputCode) === Number(authCode)) { 
                    $("#authMsg").html("<span class='msg-ok'>" + 
                        t("member.authSuccess", "인증이 완료되었습니다.") + 
                        "</span>");
                    clearInterval(timerInterval);
                    $("#timer").text("");
                    $("#btnEmailAuth, #auth_code").prop("disabled", true);
                    $("#user_email").prop("readonly", true);
                    isEmailChecked = true;
                } else {
                    $("#authMsg").html("<span class='msg-no'>" + 
                        t("member.pwMismatch", "일치하지 않습니다.") + 
                        "</span>");
                    isEmailChecked = false;
                }
            }
        });

        // 타이머 엔진
        function startTimer() {
            let time = 180;
            clearInterval(timerInterval);
            timerInterval = setInterval(function() {
                let min = Math.floor(time / 60);
                let sec = time % 60;
                $("#timer").text((min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec));
                if (time-- <= 0) {
                    clearInterval(timerInterval);
                    $("#timer").text(t("member.timerExpired", "시간 만료"));
                    $("#auth_code").prop("disabled", true);
                }
            }, 1000);
        }

        // 5. [핵심] 최종 폼 전송 검증 로직
        $("#joinForm").on("submit", function(e) {
            if (isSocialSignup) return true;

            if(!isIdChecked) { 
                alert(t("member.idCheckPrompt", "아이디 중복확인을 해주세요.")); 
                $("#user_id").focus();
                e.preventDefault(); return false; 
            }
            if(!isPwMatched) { 
                alert(t("member.pwMismatchAlert", "비밀번호를 확인해주세요.")); 
                $("#user_pw").focus();
                e.preventDefault(); return false; 
            }
            if(!skipEmailAuth && !isEmailChecked) { 
                alert(t("member.emailAuthRequired", "이메일 인증이 필요합니다.")); 
                $("#user_email").focus();
                e.preventDefault(); return false; 
            }

            return true; 
        });

        // 6. 점주 2단계 위치 검증
        $("#ownerStep2Form").on("submit", function(e) {
            const lat = $("#store_lat").val();
            if(!lat || lat === "0.0" || lat === "0") {
                alert(t("member.storeLocationRequired", "주소 검색을 완료해 주세요."));
                e.preventDefault();
                return false;
            }
            return true;
        });
    });

    // 7. 회원 탈퇴 (전역)
    window.dropUser = function(userId) {
        if (confirm(t("member.withdrawConfirmSimple"))) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = APP_CONFIG.contextPath + '/member/delete';
            
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden'; csrfInput.name = APP_CONFIG.csrfName; csrfInput.value = APP_CONFIG.csrfToken;
            
            const userIdInput = document.createElement('input');
            userIdInput.type = 'hidden'; userIdInput.name = 'user_id'; userIdInput.value = userId;

            form.appendChild(csrfInput);
            form.appendChild(userIdInput);
            document.body.appendChild(form);
            form.submit();
        }
    };

})(jQuery);