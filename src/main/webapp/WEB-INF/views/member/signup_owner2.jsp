<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> 

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/address-api.js"></script>

<div style="width: 80%; margin: 0 auto; text-align: center;">
    <h2 style="margin-top: 30px;">점주 회원가입 - 2단계 (가게 정보)</h2>
    <p>운영하실 <b>가게 정보</b>를 입력해주세요.</p>
    
    <form action="${pageContext.request.contextPath}/member/signup/ownerFinal" method="post" id="ownerStep2Form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table class="info-table" style="width: 100%; text-align: left;">
            <tr>
                <th style="width: 20%;">가게 이름</th>
                <td><input type="text" name="store_name" id="store_name" placeholder="예: 구르메 식당" required style="width: 100%;"></td>
            </tr>
            <tr>
                <th>가게 전화번호</th>
                <td><input type="text" name="store_tel" required placeholder="02-123-4567" maxlength="13" oninput="autoHyphen(this)" style="width: 100%;"></td>
            </tr>
            <tr>
                <th>가게 주소</th>
                <td>
                    <input type="text" name="store_zip" id="store_zip" placeholder="우편번호" readonly style="width: 100px;">
                    <button type="button" onclick="execDaumPostcode('store')" class="btn-action">가게 위치 검색</button><br>
                    <input type="text" name="store_addr1" id="store_addr1" placeholder="가게 기본주소" readonly style="width: 100%; margin: 5px 0;"><br>
                    <input type="text" name="store_addr2" id="store_addr2" placeholder="상세주소" style="width: 100%;">
                    <div id="coordStatus" class="msg-ok" style="margin-top: 5px;">주소를 검색해주세요.</div>
                </td>
            </tr>
            <tr>
                <th>영업 시간</th>
                <td>
                    <select name="open_time">
                        <c:forEach var="i" begin="0" end="23">
                            <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                            <option value="${hour}:00" ${i==9 ? 'selected':''}>${hour}:00</option>
                            <option value="${hour}:30">${hour}:30</option>
                        </c:forEach>
                    </select>
                    &nbsp;~&nbsp;
                    <select name="close_time">
                        <c:forEach var="i" begin="0" end="23">
                            <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                            <option value="${hour}:00" ${i==22 ? 'selected':''}>${hour}:00</option>
                            <option value="${hour}:30">${hour}:30</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th>예약 단위</th>
                <td>
                    <select name="res_unit" style="width: 150px;">
                        <option value="30">30분 단위</option>
                        <option value="60">1시간 단위</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>가게 소개</th>
                <td><textarea name="store_desc" rows="5" style="width: 100%;" placeholder="가게 소개를 입력해주세요."></textarea></td>
            </tr>
        </table>
        
        <div style="margin: 30px 0;">
            <input type="submit" value="최종 가입 완료" class="btn-success" style="padding: 10px 40px;">
        </div>
    </form>
</div>

<script>
    const autoHyphen = (target) => {
        target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
    }

    $("#ownerStep2Form").submit(function() {
        if($("#store_lat").val() == "0.0") {
            alert("주소 검색을 통해 위치를 지정해주세요.");
            return false;
        }
        return true;
    });
</script>

<jsp:include page="../common/footer.jsp" />