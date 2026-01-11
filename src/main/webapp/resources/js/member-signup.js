/* /resources/js/member-signup.js */

let isIdChecked = false; // 전역 플래그
let isPwMatched = false;

$(document).ready(function() {
    // 1. 아이디 중복 확인
    $("#btnIdCheck").click(function() {
        const userId = $("#user_id").val();
        if(userId.length < 3) { alert("아이디는 3글자 이상 입력해주세요."); return; }

        // [핵심] APP_CONFIG를 통해 ContextPath와 CSRF 토큰 접근
        const ajaxData = { user_id: userId };
        ajaxData[APP_CONFIG.csrfName] = APP_CONFIG.csrfToken;

        $.ajax({
            url: APP_CONFIG.contextPath + "/member/idCheck",
            type: "POST",
            data: ajaxData,
            success: function(res) {
                if(res === "success") { 
                    $("#idCheckMsg").html("<span class='msg-ok'>사용 가능한 아이디입니다.</span>"); 
                    isIdChecked = true; 
                } else { 
                    $("#idCheckMsg").html("<span class='msg-no'>이미 사용 중인 아이디입니다.</span>");
                    isIdChecked = false; 
                }
            },
            error: function() { alert("서버 통신 오류"); }
        });
    });

    // 아이디 입력 변경 시 플래그 초기화
    $("#user_id").on("input", function() { isIdChecked = false; $("#idCheckMsg").text(""); });

    // 2. 비밀번호 일치 확인
    $("#user_pw, #user_pw_confirm").on("keyup", function() {
        const pw = $("#user_pw").val();
        const pwConfirm = $("#user_pw_confirm").val();
        
        if(pw === "" && pwConfirm === "") { $("#pwCheckMsg").text(""); return; }
        
        if(pw === pwConfirm) { 
            $("#pwCheckMsg").html("<span class='msg-ok'>비밀번호가 일치합니다.</span>"); 
            isPwMatched = true; 
        } else { 
            $("#pwCheckMsg").html("<span class='msg-no'>비밀번호가 일치하지 않습니다.</span>"); 
            isPwMatched = false; 
        }
    });

    // 3. 폼 전송 검증
    $("#joinForm").submit(function() {
        // 수정 페이지일 경우(readonly) 아이디 체크 패스
        if($("#user_id").attr("readonly")) { isIdChecked = true; }

        if(!isIdChecked) { alert("아이디 중복확인을 해주세요."); $("#user_id").focus(); return false; }
        if(!isPwMatched) { alert("비밀번호가 일치하지 않습니다."); $("#user_pw").focus(); return false; }
        return true; 
    });
});