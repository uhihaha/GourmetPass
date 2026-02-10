<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="menu.update.title" text="메뉴 정보 수정" /></div>

    <form action="${pageContext.request.contextPath}/store/menu/update?${_csrf.parameterName}=${_csrf.token}"
          method="post"
          enctype="multipart/form-data">

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="menu_id" value="${menu.menu_id}">
        <input type="hidden" name="store_id" value="${menu.store_id}">
        <input type="hidden" name="menu_img" value="${menu.menu_img}">

        <table class="edit-table">
            <tr>
                <th><spring:message code="menu.label.name" text="메뉴 이름" /></th>
                <td>
                    <input type="text" name="menu_name" value="${menu.menu_name}"
                           class="login-input" required placeholder="<spring:message code='menu.placeholder.name' text='메뉴 이름 입력' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="menu.label.price" text="가격" /></th>
                <td>
                    <input type="number" name="menu_price" value="${menu.menu_price}"
                           class="login-input" required placeholder="<spring:message code='menu.placeholder.price' text='금액 입력' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="menu.label.image" text="메뉴 이미지" /></th>
                <td>
                    <c:if test="${not empty menu.menu_img}">
                        <div style="margin-bottom: 15px;">
                            <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}"
                                 width="120" style="border: 2px solid #333; border-radius: 10px;">
                        </div>
                    </c:if>
                    <input type="file" name="file" class="login-input" style="padding-top: 10px;">
                    <div class="msg-box" style="color: #888;"><spring:message code="menu.msg.file_update_info" text="교체 시에만 파일을 선택해 주세요." /></div>
                </td>
            </tr>
            <tr>
                <th><spring:message code="menu.label.signature" text="대표" /></th>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px; height: 50px;">
                        <input type="checkbox" name="menu_sign" value="Y"
                               ${menu.menu_sign == 'Y' ? 'checked' : ''}
                               style="width: 20px; height: 20px; cursor: pointer;">
                        <span style="font-weight: 800; font-size: 14px;"><spring:message code="menu.label.signature.desc" text="대표 메뉴로 설정" /></span>
                    </div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit"><spring:message code="menu.btn.update_done" text="수정 완료" /></button>
            <button type="button" class="btn-cancel" onclick="history.back()"><spring:message code="common.btn.cancel" text="취소" /></button>
        </div>
    </form>
</div>

<script>
    (function () {
        var input = document.querySelector("input[type='file'][name='file']");
        if (!input) return;

        function resizeImageFile(file, maxWidth, maxHeight, quality) {
            return new Promise(function (resolve) {
                if (!file.type || !file.type.startsWith("image/")) {
                    resolve(file);
                    return;
                }
                var img = new Image();
                var url = URL.createObjectURL(file);
                img.onload = function () {
                    var width = img.width;
                    var height = img.height;
                    var ratio = Math.min(maxWidth / width, maxHeight / height, 1);
                    var canvas = document.createElement("canvas");
                    canvas.width = Math.round(width * ratio);
                    canvas.height = Math.round(height * ratio);
                    var ctx = canvas.getContext("2d");
                    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                    URL.revokeObjectURL(url);
                    canvas.toBlob(function (blob) {
                        if (!blob) {
                            resolve(file);
                            return;
                        }
                        var resized = new File([blob], file.name, {type: blob.type, lastModified: Date.now()});
                        resolve(resized);
                    }, file.type === "image/png" ? "image/png" : "image/jpeg", quality);
                };
                img.onerror = function () {
                    URL.revokeObjectURL(url);
                    resolve(file);
                };
                img.src = url;
            });
        }

        input.addEventListener("change", function () {
            if (!input.files || input.files.length === 0) return;
            var file = input.files[0];
            resizeImageFile(file, 400, 400, 0.7).then(function (resized) {
                var dataTransfer = new DataTransfer();
                dataTransfer.items.add(resized);
                input.files = dataTransfer.files;
            });
        });
    })();
</script>

<jsp:include page="../common/footer.jsp" />
