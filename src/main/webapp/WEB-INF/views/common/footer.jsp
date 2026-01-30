<%-- WEB-INF/views/common/footer.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%-- [추가] --%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

    </div> <div class="footer-spacer"></div> 

    <footer class="wire-footer">
        <div class="footer-inner">
            <a href="<c:url value='/'/>" class="foot-btn">
                <span class="foot-icon">🏠</span>
                <span class="foot-label"><spring:message code="common.footer.home"/></span>
            </a>
            
            <a href="<c:url value='/store/list'/>" class="foot-btn">
                <span class="foot-icon">🔍</span>
                <span class="foot-label"><spring:message code="common.footer.search"/></span>
            </a>
            
            <%-- 이용현황 섹션 --%>
            <sec:authorize access="isAnonymous()">
                <a href="<c:url value='/member/login'/>" class="foot-btn">
                    <span class="foot-icon">📅</span>
                    <span class="foot-label"><spring:message code="common.footer.status"/></span>
                </a>
            </sec:authorize>
            
            <sec:authorize access="isAuthenticated()">
                <sec:authorize access="hasRole('ROLE_USER')">
                    <a href="<c:url value='/member/wait_status'/>" class="foot-btn">
                        <span class="foot-icon">📅</span>
                        <span class="foot-label"><spring:message code="common.footer.status"/></span>
                    </a>
                </sec:authorize>
                <sec:authorize access="hasRole('ROLE_OWNER')">
                    <a href="<c:url value='/book/manage'/>" class="foot-btn">
                        <span class="foot-icon">⚙️</span>
                        <span class="foot-label"><spring:message code="common.footer.manage"/></span>
                    </a>
                </sec:authorize>
            </sec:authorize>
            
            <%-- 마이페이지/로그인 섹션 --%>
            <sec:authorize access="isAnonymous()">
                <a href="<c:url value='/member/login'/>" class="foot-btn">
                    <span class="foot-icon">👤</span>
                    <span class="foot-label"><spring:message code="common.footer.login"/></span>
                </a>
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <a href="<c:url value='/member/mypage'/>" class="foot-btn active-my">
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <span class="foot-icon">🏪</span>
                        <span class="foot-label"><spring:message code="common.footer.store"/></span>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <span class="foot-icon">👤</span>
                        <span class="foot-label"><spring:message code="common.footer.my"/></span>
                    </sec:authorize>
                </a>
            </sec:authorize>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>