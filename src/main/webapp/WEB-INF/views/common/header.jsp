<%-- WEB-INF/views/common/header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%-- [필수 추가] 다국어 처리를 위한 Spring 태그 라이브러리 --%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gourmet Pass</title>

    <link rel="stylesheet" href="<c:url value='/resources/css/common.css'/>">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script>
        const APP_CONFIG = {
            contextPath : "${pageContext.request.contextPath}",
            csrfName : "${_csrf.parameterName}",
            csrfToken : "${_csrf.token}"
        };
    </script>
</head>
<body>
    <nav class="wire-nav">
        <div class="nav-inner">
            <h2 class="logo-text">
                <a href="<c:url value='/'/>">GOURMET PASS</a>
            </h2>
            <div class="nav-links">
                <%-- [변경] 하드코딩된 텍스트를 spring:message로 대체 --%>
                <a href="<c:url value='/store/list'/>" class="nav-item">
                    <spring:message code="common.nav.search" />
                </a>

                <sec:authorize access="isAnonymous()">
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/login'/>" class="nav-item">
                        <spring:message code="common.nav.login" />
                    </a>
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/signup/select'/>" class="nav-item">
                        <spring:message code="common.nav.signup" />
                    </a>
                </sec:authorize>

                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                    <span class="divider">|</span>
                    <%-- [변경] 유저 환영 문구 다국어화 --%>
                    <span class="user-welcome"><b>${user.username}</b><spring:message code="common.user.suffix" /></span>

                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item owner-link">
                            <spring:message code="common.nav.owner" />
                        </a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item">
                            <spring:message code="common.nav.mypage" />
                        </a>
                    </sec:authorize>

                    <form action="<c:url value='/logout'/>" method="post" class="logout-form-inline" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn-logout-text" style="background: none; border: none; cursor: pointer; text-decoration: underline;">
                            <spring:message code="common.nav.logout" />
                        </button>
                    </form>
                </sec:authorize>

                <%-- 언어 선택 메뉴 --%>
                <span class="divider">|</span>
                <div class="lang-selector" style="display: inline-block; margin-left: 10px;">
                    <a href="?lang=ko" class="lang-item ${pageContext.response.locale.language == 'ko' ? 'active-lang' : ''}"
                        style="text-decoration: none; color: ${pageContext.response.locale.language == 'ko' ? '#ff6b6b' : '#666'}; font-weight: ${pageContext.response.locale.language == 'ko' ? 'bold' : 'normal'};">
                        KO </a> 
                    <span style="margin: 0 2px; color: #ccc;">/</span>

                    <a href="?lang=en" class="lang-item ${pageContext.response.locale.language == 'en' ? 'active-lang' : ''}"
                        style="text-decoration: none; color: ${pageContext.response.locale.language == 'en' ? '#ff6b6b' : '#666'}; font-weight: ${pageContext.response.locale.language == 'en' ? 'bold' : 'normal'};">
                        EN </a> 
                    <span style="margin: 0 2px; color: #ccc;">/</span>

                    <a href="?lang=jp" class="lang-item ${pageContext.response.locale.language == 'ja' || pageContext.response.locale.language == 'jp' ? 'active-lang' : ''}"
                        style="text-decoration: none; color: ${(pageContext.response.locale.language == 'ja' || pageContext.response.locale.language == 'jp') ? '#ff6b6b' : '#666'}; font-weight: ${(pageContext.response.locale.language == 'ja' || pageContext.response.locale.language == 'jp') ? 'bold' : 'normal'};">
                        JP </a>
                </div>
            </div> <%-- nav-links 종결 --%>
        </div> <%-- [수정] nav-inner 종결 --%>
    </nav>

    <div class="page-wrapper">