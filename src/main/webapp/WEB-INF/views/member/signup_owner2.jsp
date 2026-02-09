<%-- WEB-INF/views/member/signup_owner2.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="member.signup.owner.step2.title" text="🍱 점주 가입 - 2단계 (가게 정보)" /></div>
    <p class="text-center mb-20"><spring:message code="member.signup.owner.step2.sub" text="운영하실 매장의 정보를 상세히 입력해주세요." /></p>

    <form action="${pageContext.request.contextPath}/member/signup/ownerFinal" method="post" id="ownerStep2Form">
        <spring:message code="common.unit.person" var="unitPerson" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <%-- 좌표 정보 저장용 숨김 필드: DB 스키마 NUMBER(10, 7) 대응 [cite: 2] --%>
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table class="edit-table">
            <tr>
                <th><spring:message code="store.label.name" text="가게 이름" /></th>
                <td><input type="text" name="store_name" id="store_name" placeholder="<spring:message code='store.placeholder.name' text='예: 구르메 식당' />" required></td>
            </tr>
            <tr>
                <th><spring:message code="store.label.category" text="카테고리" /></th>
                <td>
                    <select name="store_category" required>
                        <option value=""><spring:message code="store.category.select" text="카테고리 선택" /></option>
                        <option value="한식"><spring:message code="category.Korean" text="한식" /></option>
                        <option value="일식"><spring:message code="category.Japanese" text="일식" /></option>
                        <option value="중식"><spring:message code="category.Chinese" text="중식" /></option>
                        <option value="양식"><spring:message code="category.Western" text="양식" /></option>
                        <option value="카페"><spring:message code="category.Cafe" text="카페/디저트" /></option>
                        <option value="기타"><spring:message code="category.Etc" text="기타" /></option>
                    </select>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.tel" text="가게 번호" /></th>
                <td><input type="text" name="store_tel" required placeholder="<spring:message code='store.placeholder.tel' text='02-123-4567' />" oninput="autoHyphen(this)"
                           maxlength="13"></td>
            </tr>
            <tr>
                <th><spring:message code="store.label.addr" text="가게 위치" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="store_zip" id="store_zip" style="width:120px; flex:none;" readonly
                               placeholder="<spring:message code='member.zip_code' text='우편번호' />">
                        <button type="button" onclick="execDaumPostcode('store')" class="btn-wire"><spring:message code="member.btn.addr_search" text="주소검색" /></button>
                    </div>
                    <input type="text" name="store_addr1" id="store_addr1" class="mb-10" readonly placeholder="<spring:message code='member.addr1' text='기본 주소' />">
                    <%-- [교정] name 속성을 user_addr2에서 store_addr2로 수정하여 DB 컬럼과 일치시킴 [cite: 2] --%>
                    <input type="text" name="store_addr2" id="store_addr2" placeholder="<spring:message code='member.placeholder.addr2' text='상세 주소를 입력하세요' />">
                    <div id="coordStatus" class="msg-box msg-ok"><spring:message code="store.msg.coord_info" text="정확한 위치 정보가 필요합니다." /></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.hours" text="영업 시간" /></th>
                <td>
                    <div class="btn-group" style="margin-top:0; align-items:center; gap:8px;">
                        <select name="open_time" style="flex:1;">
                            <c:forEach var="i" begin="0" end="23">
                                <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                                <option value="${hour}:00" ${i==9 ? 'selected':''}>${hour}:00</option>
                                <option value="${hour}:30">${hour}:30</option>
                            </c:forEach>
                        </select>
                        <span style="font-weight:bold;">~</span>
                        <select name="close_time" style="flex:1;">
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
                <th><spring:message code="store.label.res_unit" text="예약 단위" /></th>
                <td>
                    <select name="res_unit">
                        <option value="30">30<spring:message code="store.unit.minute" text="분 단위" /></option>
                        <option value="60">1<spring:message code="store.unit.hour" text="시간 단위" /></option>
                    </select>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.capacity" text="최대 수용 인원" /></th>
                <td>
                    <input type="number" name="max_capacity" required placeholder="0 ${unitPerson}"
                           oninput="autoHyphen(this)" minlength="1">
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.desc" text="가게 소개" /></th>
                <td><textarea name="store_desc" rows="5" style="resize:none;"
                              placeholder="<spring:message code='store.placeholder.desc' text='매장의 특징을 간단히 소개해 주세요.' />"></textarea></td>
            </tr>
        </table>

        <button type="submit" class="btn-submit" style="width:100%; margin-top:30px;"><spring:message code="store.btn.final_submit" text="가입 완료 및 가게 등록" /></button>
    </form>
</div>

<%-- 외부 API 및 공통 스크립트 연동 --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/common.js'/>"></script>

<%-- [교정] APP_CONFIG 선언 추가 (AJAX 및 경로 참조용) [cite: 16, 33] --%>
<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<%-- [교정] member.js를 제거하고 통합된 member-signup.js 연결 --%>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
