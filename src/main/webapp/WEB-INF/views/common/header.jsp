<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gourmet Pass</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    body { text-align: center; font-family: sans-serif; margin: 0; padding: 0; }
    .nav-bar { background-color: #eee; padding: 15px; border-bottom: 2px solid #ddd; }
    /* 규격 고정용 래퍼 */
    .page-wrapper { width: 80%; margin: 0 auto; padding-top: 30px; min-height: 600px; text-align: left; }
    a { text-decoration: none; color: black; font-weight: bold; }
    a:hover { color: red; }
    .nav-inner { width: 80%; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
</style>
</head>
<body>
    <div class="nav-bar">
        <div class="nav-inner">
            <h2 style="margin: 0;"><a href="<c:url value='/'/>">Gourmet Pass</a></h2>
            <div>
                <a href="<c:url value='/store/list'/>">맛집 검색</a>
                <sec:authorize access="isAnonymous()">
                    | <a href="<c:url value='/member/login'/>">로그인</a>
                    | <a href="<c:url value='/member/signup/select'/>">회원가입</a>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                    | <span><b>${user.username}</b>님</span>
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        | <a href="<c:url value='/member/mypage'/>" style="color: blue;">[매장관리]</a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        | <a href="<c:url value='/member/mypage'/>">[마이페이지]</a>
                    </sec:authorize>
                    | <form action="<c:url value='/logout'/>" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" style="background:none; border:none; cursor:pointer; font-weight:bold;">로그아웃</button>
                    </form>
                </sec:authorize>
            </div>
        </div>
    </div>
    <div class="page-wrapper">