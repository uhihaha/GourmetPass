<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="../common/header.jsp" />

<%-- [원칙 1] 고메패스 통합 스타일시트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script type="text/javascript">
    var msg = "${msg}";
    if (msg && msg !== "null" && msg !== "") {
        alert(msg);
    }
</script>

<div class="edit-wrapper">
    <div class="edit-title">➕ 메뉴 등록</div>

    <%-- 
        [기능 보존] 
        enctype="multipart/form-data" 사용 시 CSRF 필터 대응을 위해 
        action URL 뒤에 직접 토큰을 쿼리 스트링으로 포함합니다. 
    --%>
    <form action="${pageContext.request.contextPath}/store/menu/register?${_csrf.parameterName}=${_csrf.token}"
          method="post"
          enctype="multipart/form-data">

        <%-- CSRF 토큰 및 스토어 ID 유지 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="store_id" value="${param.store_id}">

        <%-- [교정] 표준 edit-table 구조 적용 --%>
        <table class="edit-table">
            <tr>
                <th>메뉴명</th>
                <td>
                    <input type="text" name="menu_name" class="login-input" 
                           required placeholder="메뉴 이름을 입력하세요">
                </td>
            </tr>
            <tr>
                <th>가격</th>
                <td>
                    <input type="number" name="menu_price" class="login-input" 
                           min="0" required placeholder="판매 가격을 입력하세요">
                </td>
            </tr>
            <tr>
                <th>메뉴 이미지</th>
                <td>
                    <%-- 파일 선택창도 표준 규격 높이에 맞춰 정렬 --%>
                    <input type="file" name="file" class="login-input" 
                           style="padding-top: 10px;">
                </td>
            </tr>
            <tr>
                <th>대표 메뉴 설정</th>
                <td>
                    <div style="display: flex; align-items: center; gap: 10px; height: 50px;">
                        <input type="checkbox" name="menu_sign" value="Y" 
                               style="width: 20px; height: 20px; cursor: pointer;">
                        <span style="font-weight: 800; font-size: 14px;">이 메뉴를 우리 가게 대표 메뉴로 설정합니다.</span>
                    </div>
                </td>
            </tr>
        </table>

        <%-- [교정] 하단 버튼 그룹: 대칭 및 표준 디자인 적용 --%>
        <div class="btn-group">
            <button type="submit" class="btn-submit">메뉴 등록 완료</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
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
