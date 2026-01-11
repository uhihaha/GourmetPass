<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/address-api.js"></script>

<div style="width: 80%; margin: 0 auto; text-align: center;">
    <h2 style="margin-top: 30px;">점주 회원가입 - 1단계 (계정 정보)</h2>
    
    <form action="${pageContext.request.contextPath}/member/signup/ownerStep1" method="post" id="joinForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="0.0">
        <input type="hidden" name="user_lon" id="user_lon" value="0.0">

        <table class="info-table" style="width: 100%; text-align: left;">
            <tr>
                <th style="width: 20%;">아이디</th>
                <td>
                    <input type="text" name="user_id" id="user_id" placeholder="아이디" required style="width: 200px;">
                    <button type="button" id="btnIdCheck" class="btn-primary">중복확인</button>
                    <div id="idCheckMsg"></div>
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td><input type="password" name="user_pw" id="user_pw" placeholder="비밀번호" required style="width: 100%;"></td>
            </tr>
            <tr>
                <th>비밀번호 확인</th>
                <td>
                   <input type="password" id="user_pw_confirm" placeholder="비밀번호 재입력" required style="width: 100%;">
                    <div id="pwCheckMsg"></div>
                </td>
            </tr>
            <tr>
                <th>이름</th>
                <td><input type="text" name="user_nm" required style="width: 100%;"></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td>
                   <input type="text" name="user_tel" required placeholder="숫자만 입력하세요" maxlength="13" oninput="autoHyphen(this)" style="width: 100%;">
                </td>
            </tr>
            <tr>
                <th>거주지 주소</th>
                <td>
                    <input type="text" name="user_zip" id="user_zip" placeholder="우편번호" readonly style="width: 100px;">
                    <button type="button" onclick="execDaumPostcode('user')" class="btn-action">주소검색</button><br>
                    <input type="text" name="user_addr1" id="user_addr1" placeholder="기본주소" readonly style="width: 100%; margin: 5px 0;"><br>
                    <input type="text" name="user_addr2" id="user_addr2" placeholder="상세주소 입력" style="width: 100%;">
                    <div id="coordStatus" class="msg-ok" style="margin-top: 5px;">주소를 검색하면 자동으로 좌표가 입력됩니다.</div>
                </td>
            </tr>
        </table>
        
        <div style="margin: 30px 0;">
            <input type="submit" value="다음 단계로 (가게 정보 입력)" class="btn-success" style="padding: 10px 40px;">
        </div>
    </form>
</div>

<script>
    let isIdChecked = false;
    let isPwMatched = false;

    $("#btnIdCheck").click(function() {
        const userId = $("#user_id").val();
        if(userId.length < 3) { alert("아이디는 3글자 이상 입력해주세요."); return; }
        $.ajax({
            url: "${pageContext.request.contextPath}/member/idCheck", 
            type: "POST",
            data: { user_id: userId, "${_csrf.parameterName}": "${_csrf.token}" },
            success: function(res) {
                if(res === "success") { 
                    $("#idCheckMsg").html("<span class='msg-ok'>사용 가능한 아이디입니다.</span>");
                    isIdChecked = true; 
                } else { 
                    $("#idCheckMsg").html("<span class='msg-no'>이미 사용 중인 아이디입니다.</span>");
                    isIdChecked = false; 
                }
            }
        });
    });

    $("#user_id").on("input", function() { isIdChecked = false; $("#idCheckMsg").text(""); });

    $("#user_pw, #user_pw_confirm").on("keyup", function() {
        const pw = $("#user_pw").val();
        const pwConfirm = $("#user_pw_confirm").val();
        if(pw === pwConfirm && pw !== "") { 
            $("#pwCheckMsg").html("<span class='msg-ok'>비밀번호가 일치합니다.</span>"); 
            isPwMatched = true; 
        } else { 
            $("#pwCheckMsg").html("<span class='msg-no'>비밀번호가 일치하지 않습니다.</span>"); 
            isPwMatched = false; 
        }
    });

    $("#joinForm").submit(function() {
        if(!isIdChecked) { alert("아이디 중복확인을 해주세요."); return false; }
        if(!isPwMatched) { alert("비밀번호가 일치하지 않습니다."); return false; }
        return true;
    });

    const autoHyphen = (target) => {
        target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
    }
</script>

<jsp:include page="../common/footer.jsp" />