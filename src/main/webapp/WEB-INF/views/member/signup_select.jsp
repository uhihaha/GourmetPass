<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="select-wrapper">
    <h2 class="select-header"><spring:message code="member.signup.select.title" text="회원가입 유형을 선택해주세요" /></h2>
    <p class="select-subtext"><spring:message code="member.signup.select.sub" text="어떤 목적으로 Gourmet Pass를 이용하시나요?" /></p>
    <c:if test="${socialSignup}">
        <p class="social-note"><spring:message code="member.signup.select.social.note" text="소셜 로그인 정보를 기반으로 가입을 이어갑니다." /></p>
    </c:if>
    
    <div class="select-group">
        <%-- 일반 회원 선택 카드 --%>
        <a href="${pageContext.request.contextPath}/member/signup/general<c:if test='${socialSignup}'>?social=true</c:if>" class="select-card">
            <span class="select-icon">😊</span>
            <span class="select-title"><spring:message code="member.signup.role.user" text="일반 회원" /></span>
            <span class="select-desc">
                <spring:message code="member.signup.role.user.desc" text="맛집을 예약하고<br>웨이팅을 신청하고 싶어요." />
            </span>
        </a>

        <%-- 점주 회원 선택 카드 --%>
        <a href="${pageContext.request.contextPath}/member/signup/owner1<c:if test='${socialSignup}'>?social=true</c:if>" class="select-card">
            <span class="select-icon">👨‍🍳</span>
            <span class="select-title"><spring:message code="member.signup.role.owner" text="점주 회원" /></span>
            <span class="select-desc">
                <spring:message code="member.signup.role.owner.desc" text="우리 가게를 등록하고<br>손님을 받고 싶어요." />
            </span>
        </a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
