<%-- WEB-INF/views/member/find_account.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="member.find.title" text="🔎 아이디/비밀번호 찾기" /></div>

    <%-- [1] 아이디 찾기 섹션: novalidate 추가로 브라우저 기본 말풍선 차단 --%>
    <div class="find-section">
        <h3><spring:message code="member.find.id.title" text="아이디 찾기" /></h3>
        <%-- AJAX 연동을 위해 id="findIdForm"과 novalidate를 적용했습니다. --%>
        <form id="findIdForm" method="post" novalidate>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <div class="form-group">
                <label><spring:message code="member.user_nm" text="성명" /></label>
                <input type="text" name="user_nm" id="find_id_nm" required 
                       placeholder="<spring:message code='member.find.placeholder.name' text='가입 시 입력한 이름' />">
            </div>
            
            <div class="form-group">
                <label><spring:message code="member.user_email" text="이메일" /></label>
                <input type="email" name="user_email" id="find_id_email" required 
                       placeholder="<spring:message code='member.placeholder.email' text='example@mail.com' />">
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn-submit">
                    <spring:message code="member.find.btn.id" text="아이디 찾기" />
                </button>
            </div>
        </form>
    </div>

    <%-- [2] 비밀번호 재설정 섹션 --%>
    <div class="find-section">
        <h3><spring:message code="member.find.pw.title" text="비밀번호 재설정" /></h3>
        <%-- [교정] 수동 검증 로직 연동을 위해 novalidate 속성을 추가했습니다. --%>
        <form action="<c:url value='/member/find/password'/>" method="post" novalidate>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <div class="form-group">
                <label><spring:message code="member.user_id" text="아이디" /></label>
                <input type="text" name="user_id" id="pw_user_id" required 
                       placeholder="<spring:message code='member.find.placeholder.id' text='아이디 입력' />">
            </div>
            
            <div class="form-group">
                <label><spring:message code="member.user_email" text="이메일" /></label>
                <input type="email" name="user_email" id="pw_user_email" required 
                       placeholder="<spring:message code='member.placeholder.email' text='example@mail.com' />">
            </div>
            
            <div class="form-group">
                <button type="button" id="btnPwAuth" class="btn-wire">
                    <spring:message code="member.btn.email_auth" text="인증코드 발송" />
                </button>
                <div id="pwAuthMsg" class="msg-box"></div>
            </div>
            
            <div class="form-group">
                <label><spring:message code="member.auth_code" text="인증코드" /></label>
                <input type="text" name="auth_code" id="pw_auth_code" required 
                       placeholder="<spring:message code='member.find.placeholder.auth' text='이메일로 받은 인증코드' />">
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn-submit">
                    <spring:message code="member.find.btn.temp_pw" text="임시 비밀번호 발급" />
                </button>
            </div>
        </form>

        <c:if test="${not empty pwResult}">
            <div class="find-result msg-ok">
                ${pwResult}
                <div class="mt-10"><spring:message code="member.find.pw.after" text="로그인 후 반드시 비밀번호를 변경해주세요." /></div>
            </div>
        </c:if>
        <c:if test="${not empty pwError}">
            <div class="find-result msg-no">${pwError}</div>
        </c:if>
    </div>

    <div class="btn-group">
        <a href="<c:url value='/member/login'/>" class="btn-cancel">
            <spring:message code="member.find.btn.back_login" text="로그인으로 돌아가기" />
        </a>
    </div>
</div>

<script type="text/javascript">
    var APP_CONFIG = APP_CONFIG || {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}"
    };
</script>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="<c:url value='/resources/js/member-find.js'/>"></script>

<jsp:include page="../common/footer.jsp" />