<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> 

<jsp:include page="../common/header.jsp" />

<style>
    .signup-wrapper { width: 80%; max-width: 700px; margin: 40px auto; padding: 40px; border: 2px solid #333; border-radius: 15px; background: #fff; }
    .signup-title { margin-bottom: 20px; font-size: 24px; font-weight: bold; text-align: center; }
    
    .signup-table { width: 100%; border-collapse: collapse; }
    .signup-table th { width: 25%; padding: 15px 10px; text-align: left; vertical-align: middle; border-bottom: 1px solid #eee; font-size: 14px; }
    .signup-table td { width: 75%; padding: 15px 10px; border-bottom: 1px solid #eee; }
    
    .signup-input, .signup-select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; box-sizing: border-box; }
    .input-row { display: flex; gap: 10px; align-items: center; }
    .btn-wire { padding: 12px 15px; border: 2px solid #333; border-radius: 8px; background: #fff; font-weight: bold; cursor: pointer; }
    .btn-submit { width: 100%; padding: 18px; background: #333; color: #fff; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; margin-top: 30px; }
</style>

<div class="signup-wrapper">
    <div class="signup-title">🍱 점주 가입 - 2단계 (가게)</div>
    <p style="text-align:center; color:#666; margin-bottom:30px;">운영하실 매장 정보를 입력해주세요.</p>
    
    <form action="${pageContext.request.contextPath}/member/signup/ownerFinal" method="post" id="ownerStep2Form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table class="signup-table">
            <tr>
                <th>가게 이름</th>
                <td><input type="text" name="store_name" id="store_name" class="signup-input" placeholder="예: 구르메 식당" required></td>
            </tr>
            <tr>
                <th>카테고리</th>
                <td>
                    <select name="store_category" class="signup-select" required>
                        <option value="">카테고리 선택</option>
                        <option value="한식">한식</option>
                        <option value="일식">일식</option>
                        <option value="중식">중식</option>
                        <option value="양식">양식</option>
                        <option value="카페">카페/디저트</option>
                        <option value="기타">기타</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>가게 번호</th>
                <td><input type="text" name="store_tel" class="signup-input" required placeholder="02-123-4567" oninput="autoHyphen(this)" maxlength="13"></td>
            </tr>
            <tr>
                <th>가게 주소</th>
                <td>
                    <div class="input-row">
                        <input type="text" name="store_zip" id="store_zip" class="signup-input" style="width:120px; flex:none;" readonly placeholder="우편번호">
                        <button type="button" onclick="execDaumPostcode('store')" class="btn-wire">위치 검색</button>
                    </div>
                    <input type="text" name="store_addr1" id="store_addr1" class="signup-input" style="margin-top:8px;" readonly placeholder="기본 주소">
                    <input type="text" name="user_addr2" id="user_addr2" class="signup-input" style="margin-top:8px;" placeholder="상세 주소">
                    <div id="coordStatus" style="font-size:12px; color:#2f855a; margin-top:8px;">위치 검색을 완료해주세요.</div>
                </td>
            </tr>
            <tr>
                <th>영업 시간</th>
                <td>
                    <div class="input-row">
                        <select name="open_time" class="signup-select" style="flex:1;">
                            <c:forEach var="i" begin="0" end="23">
                                <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                                <option value="${hour}:00" ${i==9 ? 'selected':''}>${hour}:00</option>
                                <option value="${hour}:30">${hour}:30</option>
                            </c:forEach>
                        </select>
                        <span>~</span>
                        <select name="close_time" class="signup-select" style="flex:1;">
                            <c:forEach var="i" begin="0" end="23">
                                <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                                <option value="${hour}:00" ${i==22 ? 'selected':''}>${hour}:00</option>
                                <option value="${hour}:30">${hour}:30</option>
                            </c:forEach>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th>예약 단위</th>
                <td>
                    <select name="res_unit" class="signup-select">
                        <option value="30">30분 단위</option>
                        <option value="60">1시간 단위</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>가게 소개</th>
                <td><textarea name="store_desc" rows="5" class="signup-input" style="resize:none;" placeholder="매장의 특징을 간단히 소개해 주세요."></textarea></td>
            </tr>
        </table>

        <button type="submit" class="btn-submit">가입 완료 및 가게 등록</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/address-api.js"></script>
<script>
    const autoHyphen = (target) => { target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, ""); }
    
    $("#ownerStep2Form").submit(function() {
        if($("#store_lat").val() == "0.0") {
            alert("가게 위치 검색을 통해 주소를 입력해주세요.");
            return false;
        }
        return true;
    });
</script>

<jsp:include page="../common/footer.jsp" />