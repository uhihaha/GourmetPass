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
    <title><spring:message code="common.logo" text="Gourmet Pass" /></title>

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
            loginRequired: "<spring:message code='common.msg.login_required' text='로그인이 필요합니다' />",
            favoriteError: "<spring:message code='common.msg.favorite_error' text='즐겨찾기 처리 중 오류가 발생했습니다.' />",
            serverError: "<spring:message code='common.msg.server_error' text='서버 오류' />"
        };
        window.I18N.address = {
            coordSuccess: "<spring:message code='address.coord.success' text='좌표 추출 완료!' />",
            coordFail: "<spring:message code='address.coord.fail' text='좌표 추출 실패' />"
        };
        window.I18N.storeDetail = {
            loading: "<spring:message code='store.detail.loading' text='조회 중...' />",
            reasonClosed: "<spring:message code='store.detail.reason.closed' text='마감' />",
            reasonBooked: "<spring:message code='store.detail.reason.booked' text='예약됨' />",
            noHours: "<spring:message code='store.detail.no_hours' text='영업 시간이 설정되지 않았습니다.' />",
            loadFail: "<spring:message code='store.detail.load_fail' text='정보 로드 실패' />",
            ownerBlock: "<spring:message code='store.detail.owner.block' text='점주 계정은 예약/웨이팅을 할 수 없습니다.' />",
            selfBlock: "<spring:message code='store.detail.self.block' text='본인 매장은 예약/웨이팅을 할 수 없습니다.' />",
            favoriteOn: "<spring:message code='store.detail.favorite.on' text='즐겨찾기 해제' />",
            favoriteOff: "<spring:message code='store.detail.favorite.off' text='즐겨찾기' />",
            favoriteCountPrefix: "<spring:message code='store.detail.favorite.count_prefix' text='❤️' />",
            paySuccessBooking: "<spring:message code='store.detail.pay.success_booking' text='결제가 완료되었습니다! 예약을 진행합니다.' />",
            payFail: "<spring:message code='store.detail.pay.fail' text='결제가 실패했습니다.' />",
            selectVisitTime: "<spring:message code='store.detail.visit_time.select' text='방문 시간을 선택해 주세요!' />",
            confirmPaymentSuffix: "<spring:message code='store.detail.confirm_payment_suffix' text='예약을 위해 결제를 진행하시겠습니까?' />",
            orderName: "<spring:message code='store.detail.order_name' text='예약 보증금' />",
            paySuccess: "<spring:message code='store.detail.pay.success' text='결제가 완료되었습니다!' />",
            payVerifyFail: "<spring:message code='store.detail.pay.verify_fail' text='결제 검증에 실패했습니다.' />",
            payCancelledPrefix: "<spring:message code='store.detail.pay.cancelled_prefix' text='결제가 취소되었습니다:' />",
            payPopupError: "<spring:message code='store.detail.pay.popup_error' text='결제창 호출 중 오류가 발생했습니다.' />",
            bookUnavailablePrefix: "<spring:message code='store.detail.book.unavailable_prefix' text='예약이 불가능합니다. (사유:' />",
            bookUnavailableSuffix: "<spring:message code='store.detail.book.unavailable_suffix' text=')' />",
            viewerPrefix: "<spring:message code='store.detail.viewer.prefix' text='👥' />",
            viewerSuffix: "<spring:message code='store.detail.viewer.suffix' text='명' />"
        };
        window.I18N.wait = {
            bookCancelConfirm: "<spring:message code='wait.book.cancel.confirm' text='예약을 취소하시겠습니까? 결제된 금액이 전액 환불됩니다.' />",
            bookCancelConfirmRefund: "<spring:message code='wait.book.cancel.confirm_refund' text='예약 취소 처리하시겠습니까? 결제된 금액이 환불됩니다.' />",
            payMissing: "<spring:message code='wait.pay.missing' text='결제 정보가 확인되지 않아 환불이 불가능합니다. 고객센터에 문의해주세요.' />",
            refundSuccess: "<spring:message code='wait.refund.success' text='환불 성공' />",
            refundFail: "<spring:message code='wait.refund.fail' text='환불 실패' />",
            refundDone: "<spring:message code='wait.refund.done' text='환불 처리가 완료되었습니다.' />",
            refundFailPrefix: "<spring:message code='wait.refund.fail_prefix' text='환불 실패:' />",
            refundFailFallback: "<spring:message code='wait.refund.fail_fallback' text='관리자에게 문의하세요.' />",
            cancelConfirm: "<spring:message code='wait.cancel.confirm' text='웨이팅을 취소하시겠습니까?' />",
            cancelSuccess: "<spring:message code='wait.cancel.success' text='웨이팅이 취소되었습니다!' />",
            cancelFail: "<spring:message code='wait.cancel.fail' text='취소 실패' />",
            failPrefix: "<spring:message code='wait.fail.prefix' text='실패:' />"
        };
        window.I18N.manage = {
            confirmNoShow: "<spring:message code='manage.confirm.noshow' text='노쇼 처리하시겠습니까? 결제된 금액이 환불됩니다.' />",
            confirmFinish: "<spring:message code='manage.confirm.finish' text='식사완료 처리하시겠습니까? 결제된 금액이 환불됩니다.' />",
            refundSuccess: "<spring:message code='manage.refund.success' text='환불 성공' />",
            refundFail: "<spring:message code='manage.refund.fail' text='환불 실패' />"
        };
        window.I18N.mypage = {
            menuDeleteConfirm: "<spring:message code='mypage.menu.delete.confirm' text='이 메뉴를 삭제하시겠습니까?' />",
            menuDeleteConfirmStrong: "<spring:message code='mypage.menu.delete.confirm_strong' text='정말로 이 메뉴를 삭제하시겠습니까?\\n삭제 후에는 복구할 수 없습니다.' />",
            waitCancelConfirm: "<spring:message code='mypage.wait.cancel.confirm' text='웨이팅을 취소하시겠습니까?' />",
            reviewDeleteConfirm: "<spring:message code='mypage.review.delete.confirm' text='이 리뷰를 삭제하시겠습니까?' />",
            userDropConfirm: "<spring:message code='mypage.user.drop.confirm' text='정말로 탈퇴하시겠습니까? 모든 정보가 삭제됩니다.' />",
            userDropSuccess: "<spring:message code='mypage.user.drop.success' text='정상적으로 탈퇴되었습니다.' />",
            historyClose: "<spring:message code='mypage.history.close' text='내역 닫기 ▲' />",
            historyCollapse: "<spring:message code='mypage.history.collapse' text='이용 내역 접기 ▲' />",
            historyOpen: "<spring:message code='mypage.history.open' text='전체 이용 내역 보기 ▼' />",
            notificationPrefix: "<spring:message code='mypage.notification.prefix' text='🔔 알림:' />"
        };
        window.I18N.review = {
            deleteConfirm: "<spring:message code='review.delete.confirm' text='이 리뷰를 삭제하시겠습니까?' />"
        };
        window.I18N.member = {
            loginError: "<spring:message code='member.login.msg.error' text='아이디 또는 비밀번호가 잘못되었습니다.' />",
            logoutSuccess: "<spring:message code='member.login.msg.logout' text='성공적으로 로그아웃되었습니다. 이용해 주셔서 감사합니다.' />",
            idRule: "<spring:message code='member.js.id_rule' text='아이디는 영문/숫자/언더바 4~20자만 가능합니다.' />",
            idAvailable: "<spring:message code='member.js.id_available' text='사용 가능한 아이디입니다.' />",
            idInvalid: "<spring:message code='member.js.id_invalid' text='아이디 형식이 올바르지 않습니다.' />",
            idInUse: "<spring:message code='member.js.id_in_use' text='이미 사용 중인 아이디입니다.' />",
            serverError: "<spring:message code='member.js.server_error' text='서버 통신 오류가 발생했습니다.' />",
            pwRule: "<spring:message code='member.js.pw_rule' text='영문/숫자/특수문자 포함 8~20자' />",
            pwMatch: "<spring:message code='member.js.pw_match' text='비밀번호가 일치합니다.' />",
            pwMismatch: "<spring:message code='member.js.pw_mismatch' text='비밀번호가 일치하지 않습니다.' />",
            emailChangeAuth: "<spring:message code='member.js.email_change_auth' text='이메일 변경 시 인증이 필요합니다.' />",
            emailRequired: "<spring:message code='member.js.email_required' text='이메일을 입력해주세요.' />",
            emailAuthSent: "<spring:message code='member.js.email_auth_sent' text='인증코드가 발송되었습니다.' />",
            emailSendFail: "<spring:message code='member.js.email_send_fail' text='메일 발송에 실패했습니다.' />",
            authSuccess: "<spring:message code='member.js.auth_success' text='인증 성공' />",
            authMismatch: "<spring:message code='member.js.auth_mismatch' text='인증번호가 일치하지 않습니다.' />",
            timerExpired: "<spring:message code='member.js.timer_expired' text='시간초과' />",
            idCheckRequired: "<spring:message code='member.js.id_check_required' text='아이디 중복확인이 필요합니다.' />",
            pwCheckRequired: "<spring:message code='member.js.pw_check_required' text='비밀번호 일치 여부를 확인해주세요.' />",
            emailAuthRequired: "<spring:message code='member.js.email_auth_required' text='이메일 인증을 완료해주세요.' />",
            storeCoordRequired: "<spring:message code='member.js.store_coord_required' text='주소 검색을 통해 가게 위치(좌표)를 확정해주세요.' />",
            withdrawConfirm: "<spring:message code='member.js.withdraw_confirm' text='정말로 탈퇴하시겠습니까?\\n모든 예약 및 웨이팅 데이터가 소멸됩니다.' />",
            idMinLength: "<spring:message code='member.js.id_min_length' text='아이디는 3글자 이상 입력해주세요.' />",
            idCheckPrompt: "<spring:message code='member.js.id_check_prompt' text='아이디 중복확인을 해주세요.' />",
            pwMismatchAlert: "<spring:message code='member.js.pw_mismatch_alert' text='비밀번호 확인이 일치하지 않습니다.' />",
            storeLocationRequired: "<spring:message code='member.js.store_location_required' text='가게 위치 검색을 통해 주소를 확정해주세요.' />",
            withdrawConfirmSimple: "<spring:message code='member.js.withdraw_confirm_simple' text='정말로 탈퇴하시겠습니까?\\n탈퇴 시 모든 예약 및 웨이팅 내역이 삭제됩니다.' />"
        };
        window.I18N.memberFind = {
            authMissing: "<spring:message code='member.find.auth.missing' text='아이디와 이메일을 입력해주세요.' />",
            authSent: "<spring:message code='member.find.auth.sent' text='인증코드를 발송했습니다.' />",
            authNotFound: "<spring:message code='member.find.auth.not_found' text='일치하는 계정을 찾을 수 없습니다.' />",
            authUnavailable: "<spring:message code='member.find.auth.unavailable' text='요청을 처리할 수 없습니다.' />",
            authServerError: "<spring:message code='member.find.auth.server_error' text='서버 통신 오류가 발생했습니다.' />"
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
                <a href="<c:url value='/'/>"><spring:message code="common.logo" text="GOURMET PASS" /></a>
            </h2>
            <div class="nav-links">
                <a href="<c:url value='/store/list'/>" class="nav-item">
                    <spring:message code="common.nav.search" text="Search" />
                </a>
                
                <sec:authorize access="isAnonymous()">
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/login'/>" class="nav-item">
                        <spring:message code="common.nav.login" text="Login" />
                    </a>
                    <span class="divider">|</span>
                    <a href="<c:url value='/member/signup/select'/>" class="nav-item">
                        <spring:message code="common.nav.signup" text="Sign Up" />
                    </a>
                </sec:authorize>
                
                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                    <span class="divider">|</span>
                    <span class="user-welcome"><b>${user.username}</b><spring:message code="common.user.suffix" text="님" /></span>
                    
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item owner-link">
                            <spring:message code="common.nav.owner" text="[Owner]" />
                        </a>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <a href="<c:url value='/member/mypage'/>" class="nav-item">
                            <spring:message code="common.nav.mypage" text="[My Page]" />
                        </a>
                    </sec:authorize>
                    
                    <form action="<c:url value='/logout'/>" method="post" class="logout-form-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn-logout-text">
                            <spring:message code="common.nav.logout" text="Logout" />
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
