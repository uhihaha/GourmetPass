/* src/main/webapp/resources/js/member-signup.js [v2.5.0] */
/* 수정사항: 빈 값 전송 방지 로직 강화, 이메일 인증 우회 차단, i18n 완전 동기화 */

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
    
    // 정규표현식 정의
    const ID_PATTERN = /^[a-zA-Z0-9_]{4,20}$/;
    const PASSWORD_PATTERN = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,20}$/;

    $(document).ready(function() {
        // [A] 가입 모드 및 소셜 여부 감지 (JSP hidden input의 value를 읽음)
        const isSocialSignup = $("#joinForm input[name='social_signup']").val() === "true";
        const skipEmailAuth = $("#joinForm input[name='skip_email_auth']").val() === "true";

        // [B] 초기 데이터 세팅 (수정 모드 대응)
        initialEmail = $("#user_email").val() || ""; 

        // 수정 모드(ID가 readonly) 혹은 소셜 가입일 경우 초기 검증 패스
        if($("#user_id").prop("readonly") || isSocialSignup) {
            isIdChecked = true;
            isPwMatched = true;
            isEmailChecked = true; 
        }
        
        // skip_email_auth가 명시적으로 true인 경우 인증 생략
        if (skipEmailAuth) {
            isEmailChecked = true;
            $("#btnEmailAuth").prop("disabled", true);
            $("#auth_code").prop("disabled", true);
        }

        // [C] 로그인/로그아웃 알림 처리
        // [교체] 44~51행: 화면 렌더링 후 alert 실행 보장 로직
const authMsgBox = $("#auth-msg");
if(authMsgBox.length > 0) {
    const error = authMsgBox.data("error");
    const logout = authMsgBox.data("logout");

    // setTimeout을 사용하여 브라우저가 HTML을 모두 그리도록 기회를 줍니다.
    setTimeout(function() {
        if (error) {
            alert(t("member.loginError", "로그인 정보가 불일치합니다."));
        }
        if (logout) {
            alert(t("member.logoutSuccess", "로그아웃되었습니다."));
        }
    }, 100); // 0.1초의 지연으로 화면 렌더링 우선순위 확보
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

        // 아이디 재입력 시 검증 초기화
        $("#user_id").on("input", function() {
            if(!$(this).prop("readonly")) {
                isIdChecked = false; 
                $("#idCheckMsg").text("");
            }
        });

        // 2. 비밀번호 실시간 확인
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

        // [추가] 이메일 주소 변경 시 재인증 강제
        $("#user_email").on("input", function() {
            if (!isSocialSignup && !$("#user_id").prop("readonly")) {
                isEmailChecked = false;
                $("#emailMsg").html("<span class='msg-no'>" + 
                    t("member.emailChangeAuth", "이메일 변경 시 재인증이 필요합니다.") + 
                    "</span>");
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

        // 4. 인증코드 실시간 검증
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

        // 인증 타이머 함수
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

        // 5. [핵심] 최종 폼 전송 검증 (빈 값 제출 및 엔터 차단 로직)
        $("#joinForm").on("submit", function(e) {
            // HTML5 기본 유효성(required 등) 검사 우선 실행
            if (!this.checkValidity()) {
                return true; // 브라우저 에러를 노출하게 둠
            }

            // 소셜 가입은 추가 검증 생략
            if (isSocialSignup) return true;

            // 중복 확인 여부 체크
            if(!isIdChecked) { 
                alert(t("member.idCheckPrompt", "아이디 중복확인을 해주세요.")); 
                $("#user_id").focus();
                e.preventDefault(); return false; 
            }
            // 비밀번호 일치 여부 체크
            if(!isPwMatched) { 
                alert(t("member.pwMismatchAlert", "비밀번호를 확인해주세요.")); 
                $("#user_pw").focus();
                e.preventDefault(); return false; 
            }
            // 이메일 인증 여부 체크 (skip_email_auth가 아닐 때만)
            if(!skipEmailAuth && !isEmailChecked) { 
                alert(t("member.emailAuthRequired", "이메일 인증이 필요합니다.")); 
                $("#user_email").focus();
                e.preventDefault(); return false; 
            }

            return true; 
        });

        // 6. 점주 가입 2단계 좌표 검증
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

    // 7. 회원 탈퇴 (전역 노출)
    window.dropUser = function(userId) {
        if (confirm(t("member.withdrawConfirmSimple", "정말 탈퇴하시겠습니까?"))) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = APP_CONFIG.contextPath + '/member/delete';
            
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