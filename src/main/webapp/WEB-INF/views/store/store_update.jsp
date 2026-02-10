<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script type="text/javascript">
    var msg = "${msg}";
    if (msg && msg !== "null" && msg !== "") {
        alert(msg);
    }
</script>

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="store.update.title" text="🛠️ 가게 정보 수정" /></div>

    <form action="${pageContext.request.contextPath}/store/update?${_csrf.parameterName}=${_csrf.token}"
          method="post" enctype="multipart/form-data">

        <input type="hidden" name="store_id" value="${store.store_id}">

        <table class="edit-table">
            <tr>
                <th><spring:message code="store.label.name" text="가게 이름" /></th>
                <td><input type="text" name="store_name" value="${store.store_name}" class="login-input" required></td>
            </tr>
            <tr>
                <th><spring:message code="store.label.category" text="카테고리" /></th>
                <td>
                    <select name="store_category" class="login-input" required>
                        <option value="한식" ${store.store_category == '한식' ? 'selected' : ''}><spring:message code="category.Korean" text="한식" /></option>
                        <option value="중식" ${store.store_category == '중식' ? 'selected' : ''}><spring:message code="category.Chinese" text="중식" /></option>
                        <option value="일식" ${store.store_category == '일식' ? 'selected' : ''}><spring:message code="category.Japanese" text="일식" /></option>
                        <option value="양식" ${store.store_category == '양식' ? 'selected' : ''}><spring:message code="category.Western" text="양식" /></option>
                        <option value="기타" ${store.store_category == '기타' ? 'selected' : ''}><spring:message code="category.Etc" text="기타" /></option>
                    </select>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.tel" text="전화번호" /></th>
                <td><input type="text" name="store_tel" value="${store.store_tel}" class="login-input"
                           oninput="autoHyphen(this)" maxlength="13"></td>
            </tr>
            <tr>
                <th><spring:message code="store.label.addr" text="가게 위치" /></th>
                <td>
                    <div class="input-row mb-10">
                        <input type="text" name="store_zip" id="store_zip" value="${store.store_zip}"
                               style="width: 120px;" readonly class="login-input">
                        <button type="button" onclick="execDaumPostcode('store')" class="btn-wire"><spring:message code="store.update.addr.change" text="위치 변경" /></button>
                    </div>
                    <input type="text" name="store_addr1" id="store_addr1" value="${store.store_addr1}"
                           class="login-input mb-10" readonly>
                    <input type="text" name="store_addr2" id="store_addr2" value="${store.store_addr2}"
                           class="login-input" placeholder="<spring:message code='member.placeholder.addr2' text='상세주소' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.hours" text="영업 시간" /></th>
                <td>
                    <div class="input-row">
                        <input type="time" name="open_time" value="${store.open_time}" class="login-input"
                               style="flex:1;">
                        <span style="padding:10px; font-weight:900;">~</span>
                        <input type="time" name="close_time" value="${store.close_time}" class="login-input"
                               style="flex:1;">
                    </div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="store.label.capacity" text="최대 수용 인원" /></th>
                <td>
                    <input type="number" name="max_capacity" value="${store.max_capacity}" class="login-input" min="1" required>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit"><spring:message code="common.btn.update" text="정보 수정 완료" /></button>
            <button type="button" class="btn-cancel" onclick="history.back()"><spring:message code="common.btn.cancel" text="취소" /></button>
        </div>
    </form>
</div>

<jsp:include page="../common/footer.jsp"/>
