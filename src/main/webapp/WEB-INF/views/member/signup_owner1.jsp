<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="../common/header.jsp" />

<style>
    /* 프로젝트 공통 와이어프레임 스타일 적용 [cite: 18, 50] */
    .signup-wrapper { width: 80%; max-width: 700px; margin: 40px auto; padding: 40px; border: 2px solid #333; border-radius: 15px; background: #fff; }
    .signup-title { margin-bottom: 30px; font-size: 24px; font-weight: bold; text-align: center; }
    
    .signup-table { width: 100%; border-collapse: collapse; }
    .signup-table th { width: 25%; padding: 15px 10px; text-align: left; vertical-align: middle; border-bottom: 1px solid #eee; }
    .signup-table td { width: 75%; padding: 15px 10px; border-bottom: 1px solid #eee; }
    
    .signup-input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; box-sizing: border-box; }
    .input-row { display: flex; gap: 10px; align-items: center; }
    .btn-wire { padding: 12px 15px; border: 2px solid #333; border-radius: 8px; background: #fff; font-weight: bold; cursor: pointer; white-space: nowrap; }
    .btn-submit { width: 100%; padding: 15px; background: #333; color: #fff; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; margin-top: 30px; }
    .msg-box { font-size: 12px; margin-top: 5px; display: block; }
</style>

<div class="signup-wrapper">
    <div class="signup-title">👨‍🍳 점주 가입 - 1단계 (계정)</div>
    
    <form action="${pageContext.request.contextPath}/member/signup/ownerStep1" method="post" id="joinForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="0.0">
        <input type="hidden" name="user_lon" id="user_lon" value="0.0">

        <table class="signup-table">
            <tr>
                <th>아이디</th>
                <td>
                    <div class="input-row">
                        <input type="text" name="user_id" id="user_id" class="signup-input" required placeholder="3글자 이상">
                        <button type="button" id="btnIdCheck" class="btn-wire">중복확인</button>
                    </div>
                    <div id="idCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td><input type="password" name="user_pw" id="user_pw" class="signup-input" required></td>
            </tr>
            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <input type="password" id="user_pw_confirm" class="signup-input" required>
                    <div id="pwCheckMsg" class="msg-box"></div>
                </td>
            </tr>
            <tr>
                <th>성명</th>
                <td><input type="text" name="user_nm" class="signup-input" required></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td><input type="text" name="user_tel" class="signup-input" required placeholder="숫자만 입력" oninput="autoHyphen(this)" maxlength="13"></td>
            </tr>
            <tr>
                <th>거주지 주소</th>
                <td>
                    <div class="input-row">
                        <input type="text" name="user_zip" id="user_zip" class="signup-input" style="width:120px; flex:none;" readonly>
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-wire">주소검색</button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" class="signup-input" style="margin-top:8px;" readonly placeholder="기본주소">
                    <input type="text" name="user_addr2" id="user_addr2" class="signup-input" style="margin-top:8px;" placeholder="상세주소">
                    <div id="coordStatus" class="msg-box" style="color: #2f855a; margin-top: 8px;">주소를 검색하면 좌표가 자동 입력됩니다.</div>
                </td>
            </tr>
        </table>

        <button type="submit" class="btn-submit">다음 단계로 (가게 정보 입력)</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/address-api.js"></script>
<script>
    let isIdChecked = false; let isPwMatched = false;

    // 아이디 중복 확인 로직 복구 [cite: 41-45]
    $("#btnIdCheck").click(function() {
        const userId = $("#user_id").val();
        if(userId.length < 3) { alert("아이디는 3글자 이상 입력해주세요."); return; }
        $.ajax({
            url: "${pageContext.request.contextPath}/member/idCheck",
            type: "POST",
            data: { user_id: userId, "${_csrf.parameterName}": "${_csrf.token}" },
            success: function(res) {
                if(res === "success") { $("#idCheckMsg").html("<span style='color:green;'>사용 가능한 아이디입니다.</span>"); isIdChecked = true; }
                else { $("#idCheckMsg").html("<span style='color:red;'>이미 사용 중인 아이디입니다.</span>"); isIdChecked = false; }
            }
        });
    });

    // 비밀번호 일치 확인 [cite: 45]
    $("#user_pw, #user_pw_confirm").on("keyup", function() {
        const pw = $("#user_pw").val(); const pwConfirm = $("#user_pw_confirm").val();
        if(pw === pwConfirm && pw !== "") { $("#pwCheckMsg").html("<span style='color:green;'>비밀번호가 일치합니다.</span>"); isPwMatched = true; }
        else { $("#pwCheckMsg").html("<span style='color:red;'>비밀번호가 일치하지 않습니다.</span>"); isPwMatched = false; }
    });

    const autoHyphen = (target) => { target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, ""); }

    $("#joinForm").submit(function() {
        if(!isIdChecked) { alert("아이디 중복확인을 해주세요."); return false; }
        if(!isPwMatched) { alert("비밀번호를 확인해주세요."); return false; }
        return true;
    });
</script>

<jsp:include page="../common/footer.jsp" />