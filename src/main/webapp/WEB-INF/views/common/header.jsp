<%-- WEB-INF/views/common/header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<c:set var="currentLang" value="${pageContext.response.locale.language}" />
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="common.logo" text="Gourmet Pass"  /></title>

    <meta name="app-context-path" content="${pageContext.request.contextPath}">
    <meta name="csrf-name" content="${_csrf.parameterName}">
    <meta name="csrf-token" content="${_csrf.token}">

    <link rel="stylesheet" href="<c:url value='/resources/css/common.css'/>">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="<c:url value='/resources/js/app-config.js'/>"></script>
    
    <%-- [Font] Japanese header font (applied via common.css when lang=ja/jp) --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
                <script>
        window.I18N = window.I18N || {};
        window.I18N.common = {
            loginRequired: "<spring:message code='common.msg.login_required' text='Login required.' javaScriptEscape='true' />",
            favoriteError: "<spring:message code='common.msg.favorite_error' text='Failed to process favorite.' javaScriptEscape='true' />",
            serverError: "<spring:message code='common.msg.server_error' text='Server error.' javaScriptEscape='true' />"
        };
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".lang-selector [data-lang]").forEach(function (link) {
                var lang = link.getAttribute("data-lang");
                if (!lang) {
                    return;
                }
                var url = new URL(window.location.href);
                url.searchParams.set("lang", lang);
                link.setAttribute("href", url.toString());
            });
        });
    </script>
</head>
<body>
    <nav class="wire-nav">
        <div class="nav-inner">
            <h2 class="logo-text">
                <a href="<c:url value='/'/>"><spring:message code="common.logo" text="GOURMET PASS"  /></a>
            </h2>
            <div class="nav-links">
                <a href="<c:url value='/store/list'/>" class="nav-item">
                    <spring:message code="common.nav.search" text="Search"  />
                </a>
                
                <sec:authorize access="isAnonymous()">
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/login'/>" class="nav-item">
                        <spring:message code="common.nav.login" text="Login"  />
                    </a>
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/signup/select'/>" class="nav-item">
                        <spring:message code="common.nav.signup" text="Sign Up"  />
                    </a>
                </sec:authorize>
                
                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                    <span class="divider">|</span>
                    <span class="user-welcome"><b>${user.username}</b><spring:message code="common.user.suffix" text="님" /></span>
                    
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item owner-link">
                            <spring:message code="common.nav.owner" text="[Owner]"  />
                        </a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item">
                            <spring:message code="common.nav.mypage" text="[My Page]"  />
                        </a>
                    </sec:authorize>
                    
                    <form action="<c:url value='/logout'/>" method="post" class="logout-form-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn-logout-text">
                            <spring:message code="common.nav.logout" text="Logout"  />
                        </button>
                    </form>
                </sec:authorize>

                <span class="divider">|</span>
                <div class="lang-selector">
                    <a href="?lang=ko" data-lang="ko" class="lang-item ${pageContext.response.locale.language == 'ko' ? 'active-lang' : ''}">KO</a>
                    <span style="margin: 0 2px; color: #ccc;">/</span>
                    <a href="?lang=en" data-lang="en" class="lang-item ${pageContext.response.locale.language == 'en' ? 'active-lang' : ''}">EN</a>
                    <span style="margin: 0 2px; color: #ccc;">/</span>
                    <a href="?lang=jp" data-lang="jp" class="lang-item ${pageContext.response.locale.language == 'ja' || pageContext.response.locale.language == 'jp' ? 'active-lang' : ''}">JP</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="page-wrapper">




