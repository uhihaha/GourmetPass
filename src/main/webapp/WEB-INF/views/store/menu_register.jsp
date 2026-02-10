<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script type="text/javascript">
    var msg = "${msg}";
    if (msg && msg !== "null" && msg !== "") {
        alert(msg);
    }
</script>

<div class="edit-wrapper">
    <div class="edit-title"><spring:message code="menu.register.title" text="메뉴 등록" /></div>

    <form action="${pageContext.request.contextPath}/store/menu/register?${_csrf.parameterName}=${_csrf.token}"
          method="post"
          enctype="multipart/form-data">

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_id" value="${param.store_id}">

        <table class="edit-table">
            <tr>
                <th><spring:message code="menu.label.name" text="메뉴 이름" /></th>
                <td>
                    <input type="text" name="menu_name" class="login-input"
                           required placeholder="<spring:message code='menu.placeholder.name' text='메뉴 이름 입력' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="menu.label.price" text="가격" /></th>
                <td>
                    <input type="number" name="menu_price" class="login-input"
                           min="0" required placeholder="<spring:message code='menu.placeholder.price' text='금액 입력' />">
                </td>
            </tr>
            <tr>
                <th><spring:message code="menu.label.image" text="메뉴 이미지" /></th>
                <td>
                    <input type="file" name="file" class="login-input" style="padding-top: 10px;">
                </td>
            </tr>
            <tr>
                <th><spring:message code="menu.label.signature" text="대표" /></th>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px; height: 50px;">
                        <input type="checkbox" name="menu_sign" value="Y"
                               style="width: 20px; height: 20px; cursor: pointer;">
                        <span style="font-weight: 800; font-size: 14px;"><spring:message code="menu.label.signature.help" text="이 메뉴를 대표로 설정합니다." /></span>
                    </div>
                </td>
            </tr>
        </table>

        <div class="btn-group">
            <button type="submit" class="btn-submit"><spring:message code="menu.btn.register_done" text="메뉴 등록 완료" /></button>
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
