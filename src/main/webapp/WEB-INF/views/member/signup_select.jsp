<%-- WEB-INF/views/member/signup_select.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="select-wrapper">
    <h2 class="select-header"><spring:message code="member.signup.select.title"/></h2>
    <p class="select-subtext"><spring:message code="member.signup.select.sub"/></p>
    
    <div class="select-group">
        <%-- 일반 회원 --%>
        <a href="${pageContext.request.contextPath}/member/signup/general" class="select-card">
            <span class="select-icon">😊</span>
            <span class="select-title"><spring:message code="member.signup.role.user"/></span>
            <span class="select-desc">
                <spring:message code="member.signup.role.user.desc"/>
            </span>
        </a>

        <%-- 점주 회원 --%>
        <a href="${pageContext.request.contextPath}/member/signup/owner1" class="select-card">
            <span class="select-icon">👨‍🍳</span>
            <span class="select-title"><spring:message code="member.signup.role.owner"/></span>
            <span class="select-desc">
                <spring:message code="member.signup.role.owner.desc"/>
            </span>
        </a>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />