<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<jsp:include page="../common/header.jsp"/>

<%-- [愿?ъ궗 遺꾨━] 怨듭슜 留덉씠?섏씠吏 ?ㅽ???諛??듯빀 ?ㅽ겕由쏀듃 ?곌껐 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/mypage.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script>
    window.I18N = window.I18N || {};
    window.I18N.mypage = {
        menuDeleteConfirm: "<spring:message code='mypage.menu.delete.confirm' text='Delete this menu?' javaScriptEscape='true' />",
        menuDeleteConfirmStrong: "<spring:message code='mypage.menu.delete.confirm_strong' text='Delete this menu? This cannot be undone.' javaScriptEscape='true' />",
        waitCancelConfirm: "<spring:message code='mypage.wait.cancel.confirm' text='Cancel waiting?' javaScriptEscape='true' />",
        reviewDeleteConfirm: "<spring:message code='mypage.review.delete.confirm' text='Delete this review?' javaScriptEscape='true' />",
        userDropConfirm: "<spring:message code='mypage.user.drop.confirm' text='Delete your account? All data will be removed.' javaScriptEscape='true' />",
        userDropSuccess: "<spring:message code='mypage.user.drop.success' text='Account deleted.' javaScriptEscape='true' />",
        historyClose: "<spring:message code='mypage.history.close' text='Hide history' javaScriptEscape='true' />",
        historyCollapse: "<spring:message code='mypage.history.collapse' text='Collapse history' javaScriptEscape='true' />",
        historyOpen: "<spring:message code='mypage.history.open' text='Show all history' javaScriptEscape='true' />",
        notificationPrefix: "<spring:message code='mypage.notification.prefix' text='Notice:' javaScriptEscape='true' />"
    };
</script>
<script src="<c:url value='/resources/js/mypage.js'/>"></script>

<div class="edit-wrapper" style="max-width: 1200px;">
    <div class="profile-card">
        <div class="profile-info">
            <span class="profile-label" style="color: #2f855a;"><spring:message code="mypage.owner.profile.label" text="OWNER PROFILE" /></span>
            <h2 class="user-name">${member.user_nm} <small><spring:message code="mypage.owner.suffix" text="?먯＜?? /></small></h2>
            <p class="user-meta"><spring:message code="mypage.owner.meta" arguments="${member.user_id},${member.user_tel}" text="ID: {0} | TEL: {1}" /></p>
        </div>
        <div class="btn-group" style="margin: 0; width: auto;">
            <a href="<c:url value='/member/edit'/>" class="btn-wire"
               style="height: 45px; padding: 0 20px; font-size: 14px;"><spring:message code="common.btn.edit" text="?뺣낫 ?섏젙" /></a>
            <form action="<c:url value='/logout'/>" method="post" style="display: inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn-wire btn-logout"
                        style="height: 45px; padding: 0 20px; font-size: 14px; margin-left: 10px;"><spring:message code="common.nav.logout" text="濡쒓렇?꾩썐" />
                </button>
            </form>
        </div>
    </div>

    <c:set var="hasThumbnail" value="false"/>
    <c:forEach var="photo" items="${photo_list}">
        <c:if test="${photo.is_thumbnail == 'Y' && photo.is_active == 'Y'}">
            <c:set var="hasThumbnail" value="true"/>
        </c:if>
    </c:forEach>

    <c:choose>
        <c:when test="${not empty store}">
            <a href="<c:url value='/book/manage?store_id=${store.store_id}'/>" class="status-btn-full">
                <spring:message code="manage.title" text="?숋툘 ?ㅼ떆媛??덉빟 諛??⑥씠??愿由??쇳꽣" />
            </a>

            <div class="dashboard-grid">
                <aside class="dashboard-card store-info-card">
                    <div class="card-header">
                        <h3 class="card-title"><spring:message code="mypage.owner.manage.store" text="?룳 ??媛寃??뺣낫" /></h3>
                        <button class="btn-wire btn-mini" style="margin-left: auto;"
                                onclick="location.href='<c:url value='/store/update?store_id=${store.store_id}'/>'"><spring:message code="common.btn.edit" text="?섏젙" />
                        </button>
                    </div>
                    <div style="text-align: center; margin-bottom: 25px;">
                        <div style="border: 2px solid #333; border-radius: 12px; overflow: hidden; height: 210px; background: #f9f9f9; margin-bottom: 15px;">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="<c:url value='/upload/${store.store_img}'/>"
                                         style="width:100%; height:100%; object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div style="line-height:210px; color:#ccc; font-weight:900;"><spring:message code="common.msg.no_image" text="NO IMAGE" /></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h4 style="font-size: 22px; font-weight: 900; margin-bottom: 8px;">${store.store_name}</h4>
                        <span class="badge-wire">
                            <c:choose>
                                <c:when test="${store.store_category eq '?쒖떇'}"><c:set var="catKey" value="category.Korean" /></c:when>
                                <c:when test="${store.store_category eq '?쇱떇'}"><c:set var="catKey" value="category.Japanese" /></c:when>
                                <c:when test="${store.store_category eq '以묒떇'}"><c:set var="catKey" value="category.Chinese" /></c:when>
                                <c:when test="${store.store_category eq '?묒떇'}"><c:set var="catKey" value="category.Western" /></c:when>
                                <c:when test="${store.store_category eq '移댄럹'}"><c:set var="catKey" value="category.Cafe" /></c:when>
                                <c:otherwise><c:set var="catKey" value="category.Etc" /></c:otherwise>
                            </c:choose>
                            <spring:message code="${catKey}" text="${store.store_category}" />
                        </span>
                    </div>
                    <table class="edit-table" style="font-size: 14px;">
                        <tr>
                            <th style="width: 40%;"><spring:message code="store.label.hours" text="?곸뾽?쒓컙" /></th>
                            <td>${store.open_time} ~ ${store.close_time}</td>
                        </tr>
                        <tr>
                            <th><spring:message code="store.label.category" text="移댄뀒怨좊━" /></th>
                            <td>
                                <c:choose>
                                    <c:when test="${store.store_category eq '?쒖떇'}"><c:set var="catKey" value="category.Korean" /></c:when>
                                    <c:when test="${store.store_category eq '?쇱떇'}"><c:set var="catKey" value="category.Japanese" /></c:when>
                                    <c:when test="${store.store_category eq '以묒떇'}"><c:set var="catKey" value="category.Chinese" /></c:when>
                                    <c:when test="${store.store_category eq '?묒떇'}"><c:set var="catKey" value="category.Western" /></c:when>
                                    <c:when test="${store.store_category eq '移댄럹'}"><c:set var="catKey" value="category.Cafe" /></c:when>
                                    <c:otherwise><c:set var="catKey" value="category.Etc" /></c:otherwise>
                                </c:choose>
                                <spring:message code="${catKey}" text="${store.store_category}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="store.label.res_unit" text="?덉빟?⑥쐞" /></th>
                            <td>${store.res_unit}<spring:message code="store.unit.minute" text="遺??⑥쐞" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="store.label.tel" text="媛寃뚮쾲?? /></th>
                            <td>${store.store_tel}</td>
                        </tr>
                        <tr>
                            <th><spring:message code="store.label.capacity" text="理쒕? ?섏슜 ?몄썝" /></th>
                            <td>${store.max_capacity}</td>
                        </tr>

                    </table>
                </aside>

                <section class="dashboard-card photo-manage-card">
                    <div class="card-header">
                        <h3 class="card-title"><spring:message code="mypage.owner.photo.manage" text="?벜 留ㅼ옣 ?ъ쭊 愿由? /></h3>
                    </div>
                    <form action="<c:url value='/photo/upload'/>" method="post" enctype="multipart/form-data" style="margin-bottom: 20px;" id="photoUploadForm">
                        <input type="hidden" name="store_id" value="${store.store_id}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <button type="button" class="btn-submit" id="photoUploadBtn" style="width: auto; height: 38px; padding: 0 15px; font-size: 14px;"><spring:message code="mypage.owner.photo.upload" text="?ъ쭊 ?낅줈?? /></button>
                            <div id="photoUploadControls" class="is-hidden" style="display: none; gap: 10px; align-items: center;">
                                <input type="file" name="files" id="photoFiles" multiple required class="is-hidden">
                                <button type="button" class="btn-wire is-hidden" id="photoPreviewClear" style="display: none; height: 38px; padding: 0 15px; font-size: 14px;"><spring:message code="common.btn.cancel" text="?좏깮 痍⑥냼" /></button>
                            </div>
                        </div>
                    </form>
                    <div class="photo-preview is-hidden" id="photoPreviewWrap" style="margin-bottom: 20px;">
                        <div class="photo-section-title"><spring:message code="mypage.owner.photo.preview" text="?좏깮???ъ쭊 誘몃━蹂닿린" /></div>
                        <div id="photoPreview" class="favorite-grid"></div>
                    </div>
                    <c:if test="${!hasThumbnail}">
                        <div class="empty-status-box" style="margin-bottom: 20px; text-align: center; padding: 12px 0; color: #999; font-weight: 900;">
                            <spring:message code="mypage.owner.photo.no_thumbnail" text="* ?꾩옱 ?깅줉???몃꽕???ъ쭊???놁뒿?덈떎." />
                        </div>
                    </c:if>
                    <div class="photo-section-title"><spring:message code="mypage.owner.photo.list" text="?깅줉???ъ쭊" /></div>
                    <div class="favorite-grid">
                        <c:choose>
                            <c:when test="${not empty photo_list}">
                                <c:forEach var="photo" items="${photo_list}">
                                    <div class="favorite-card">
                                        <c:if test="${photo.is_thumbnail == 'Y'}">
                                            <span class="badge-wire" style="position:absolute; top:10px; left:10px;"><spring:message code="mypage.owner.photo.badge.thumbnail" text="?몃꽕?? /></span>
                                        </c:if>
                                        <c:if test="${photo.is_active != 'Y'}">
                                            <span class="badge-wire" style="position:absolute; top:10px; right:10px;"><spring:message code="mypage.owner.photo.badge.private" text="鍮꾧났媛? /></span>
                                        </c:if>
                                        <div class="favorite-thumb">
                                            <img src="<c:url value='/upload/${photo.file_path}'/>" alt="${photo.original_name}">
                                        </div>
                                        <div class="favorite-info">
                                            <div style="display:flex; gap:6px; justify-content: space-between; align-items:center;">
                                                <form action="<c:url value='/photo/thumbnail'/>" method="post">
                                                    <input type="hidden" name="store_id" value="${store.store_id}">
                                                    <input type="hidden" name="photo_id" value="${photo.photo_id}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn-wire" style="height: 30px; padding: 0 8px; font-size: 12px;" ${photo.is_thumbnail == 'Y' ? 'disabled' : ''}><spring:message code="mypage.owner.photo.set_thumbnail" text="?몃꽕??吏?? /></button>
                                                </form>
                                                <div class="photo-actions">
                                                    <c:choose>
                                                        <c:when test="${photo.is_active == 'Y'}">
                                                            <form action="<c:url value='/photo/delete'/>" method="post">
                                                                <input type="hidden" name="photo_id" value="${photo.photo_id}">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                                <button type="submit" class="btn-wire photo-deactivate"
                                                                        data-is-thumbnail="${photo.is_thumbnail == 'Y'}"
                                                                        style="height: 30px; padding: 0 8px; font-size: 12px; color:#dc3545; border-color:#dc3545;"><spring:message code="mypage.owner.photo.deactivate" text="?대━湲? /></button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="<c:url value='/photo/activate'/>" method="post">
                                                                <input type="hidden" name="photo_id" value="${photo.photo_id}">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                                <button type="submit" class="btn-wire" style="height: 30px; padding: 0 8px; font-size: 12px;"><spring:message code="mypage.owner.photo.activate" text="?щ━湲? /></button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <form action="<c:url value='/photo/remove'/>" method="post">
                                                        <input type="hidden" name="photo_id" value="${photo.photo_id}">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit" class="btn-wire photo-delete"
                                                                data-is-thumbnail="${photo.is_thumbnail == 'Y'}"
                                                                style="height: 30px; padding: 0 8px; font-size: 12px; color:#dc3545; border-color:#dc3545;"><spring:message code="common.btn.delete" text="??젣" /></button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-status-box" style="grid-column: 1/-1; text-align: center; padding: 40px 0; color: #ccc; font-weight: 900;">
                                    <spring:message code="mypage.owner.photo.empty" text="?깅줉??留ㅼ옣 ?ъ쭊???놁뒿?덈떎." />
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <section class="dashboard-card menu-manage-card">
                    <div class="card-header">
                        <h3 class="card-title"><spring:message code="mypage.owner.menu.manage" text="?뱥 硫붾돱 愿由? /> (${menuList.size()})</h3>
                        <button class="btn-submit" style="width: auto; height: 38px; padding: 0 15px; font-size: 14px;"
                                onclick="location.href='<c:url value='/store/menu/register?store_id=${store.store_id}'/>'">+ <spring:message code="menu.btn.register" text="硫붾돱 異붽?" />
                        </button>
                    </div>
                    <div class="menu-grid">
                        <c:forEach var="menu" items="${menuList}">
                            <div class="menu-card">
                                <div class="menu-thumb">
                                    <c:if test="${not empty menu.menu_img}">
                                        <img src="<c:url value='/upload/${menu.menu_img}'/>" alt="${menu.menu_name}">
                                    </c:if>
                                </div>
                                <div class="menu-info">
                                    <div class="menu-title">
                                        ${menu.menu_name}
                                        <c:if test="${menu.menu_sign == 'Y'}"><span class="badge-best"
                                                                                    style="background:#ff3d00; color:#fff; padding:2px 5px; border-radius:4px; font-size:11px; margin-left:5px;"><spring:message code="menu.label.best" text="??? /></span></c:if>
                                    </div>
                                    <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/><spring:message code="common.unit.won" text="?? /></div>
                                    <div class="menu-actions">
                                        <button class="btn-wire" style="height: 32px; padding: 0 10px; font-size: 12px;"
                                                onclick="location.href='<c:url value='/store/menu/update?menu_id=${menu.menu_id}'/>'"><spring:message code="common.btn.edit" text="?섏젙" />
                                        </button>
                                        <button class="btn-wire"
                                                style="height: 32px; padding: 0 10px; font-size: 12px; color: #dc3545; border-color: #dc3545;"
                                                onclick="deleteMenu(${menu.menu_id})"><spring:message code="common.btn.delete" text="??젣" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </div>

            <%-- [?듭떖 ?섏젙 ?뱀뀡] 由щ럭 ?붿빟 ?몄텧 諛??꾩껜蹂닿린 ?곕룞 --%>
            <div class="review-container" style="margin-top: 30px;">
                <div class="card-header"
                     style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 class="section-title" style="margin: 0;"><spring:message code="mypage.owner.review.title" text="?뮠 ?곕━ 媛寃?由щ럭" /> (${store_review_list.size()})</h3>
                        <%-- store_detail.jsp? ?숈씪??踰꾪듉 ?ㅽ???諛?寃쎈줈 ?곸슜 --%>
                    <a href="<c:url value='/review/list?store_id=${store.store_id}'/>" class="btn-wire-small"><spring:message code="store.review.viewall" text="?꾩껜蹂닿린" /> ??/a>
                </div>

                <div class="store-review-list">
                    <c:choose>
                        <c:when test="${not empty store_review_list}">
                            <%-- 理쒓렐 2媛쒕쭔 ?몄텧?섍린 ?꾪빐 end="1" ?ㅼ젙 (0, 1 ?몃뜳?? --%>
                            <c:forEach var="review" items="${store_review_list}" end="1">
                                <div class="item-card">
                                    <div style="display: flex; justify-content: space-between; margin-bottom: 15px; border-bottom: 1px dashed #ddd; padding-bottom: 10px;">
                                        <div>
                                            <strong style="font-size: 16px;"><spring:message code="mypage.owner.review.customer" arguments="${review.user_nm}" text="{0} 怨좉컼?? /></strong>
                                            <span style="color: #f1c40f; margin-left: 10px;">
                                                <c:forEach begin="1" end="${review.rating}">狩?/c:forEach>
                                            </span>
                                        </div>
                                        <span style="color: #999; font-size: 13px;">
                                            <fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd"/>
                                        </span>
                                    </div>
                                    <div style="display: flex; gap: 20px;">
                                        <c:if test="${not empty review.img_url}">
                                            <img src="<c:url value='/upload/${review.img_url}'/>" class="item-img-thumb"
                                                 style="width:120px; height:120px; object-fit: cover; border-radius: 8px;">
                                        </c:if>
                                        <p style="line-height: 1.6; font-size: 15px; flex: 1;">${review.content}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="dashboard-card" style="text-align: center; padding: 50px 0; color: #999;">
                                <spring:message code="store.review.empty" text="?꾩쭅 ?깅줉??由щ럭媛 ?놁뒿?덈떎." />
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="dashboard-card" style="text-align: center; padding: 100px 0;">
                <h3 style="font-size: 26px; font-weight: 900;"><spring:message code="mypage.owner.empty.title" text="?곌껐??留ㅼ옣 ?뺣낫媛 ?놁뒿?덈떎." /></h3>
                <p style="color: #666; margin-top: 15px;"><spring:message code="mypage.owner.empty.sub" text="媛寃??뺣낫瑜??깅줉?섏뿬 Gourmet Pass ?쒕퉬?ㅻ? ?쒖옉?섏꽭??" /></p>
                <button class="btn-submit" style="width: 300px; height: 55px; margin-top: 30px;"
                        onclick="location.href='<c:url value='/member/signup/owner2'/>'"><spring:message code="mypage.owner.empty.cta" text="吏湲?諛붾줈 ?깅줉?섍린" />
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    window.I18N = window.I18N || {};
    window.I18N.mypageOwner = {
        photoMax: "<spring:message code='mypage.owner.photo.max' text='?ъ쭊? 理쒕? 5?κ퉴吏留??좏깮?????덉뒿?덈떎.' javaScriptEscape='true' />",
        deleteCanceled: "<spring:message code='common.msg.delete_cancel' text='??젣媛 痍⑥냼?섏뿀?듬땲??' javaScriptEscape='true' />",
        photoDeactivateConfirm: "<spring:message code='mypage.owner.photo.confirm.deactivate' text='硫붿씤 ?섏씠吏??蹂댁씠???ъ쭊?낅땲?? ?뺣쭚 ?대━?쒓쿋?듬땲源?' javaScriptEscape='true' />",
        photoDeleteConfirm: "<spring:message code='mypage.owner.photo.confirm.delete' text='硫붿씤 ?섏씠吏??蹂댁씠???ъ쭊?낅땲?? ?뺣쭚 ??젣?섏떆寃좎뒿?덇퉴?' javaScriptEscape='true' />"
    };
    (function () {
        var form = document.getElementById("photoUploadForm");
        var uploadBtn = document.getElementById("photoUploadBtn");
        var controls = document.getElementById("photoUploadControls");
        var input = document.getElementById("photoFiles");
        var preview = document.getElementById("photoPreview");
        var previewWrap = document.getElementById("photoPreviewWrap");
        if (!uploadBtn || !controls || !input || !preview || !form) return;
        var clearBtn = document.getElementById("photoPreviewClear");
        if (clearBtn) {
            clearBtn.classList.add("is-hidden");
            clearBtn.style.display = "none";
        }

        input.addEventListener("change", function () {
            preview.innerHTML = "";
            var files = Array.from(input.files || []);
            if (files.length > 5) {
                alert(window.I18N.mypageOwner.photoMax);
                input.value = "";
                previewWrap.classList.add("is-hidden");
                if (clearBtn) {
                    clearBtn.classList.add("is-hidden");
                    clearBtn.style.display = "none";
                }
                return;
            }
            if (files.length) {
                previewWrap.classList.remove("is-hidden");
                if (clearBtn) {
                    clearBtn.classList.remove("is-hidden");
                    clearBtn.style.display = "inline-block";
                }
            } else {
                previewWrap.classList.add("is-hidden");
                if (clearBtn) {
                    clearBtn.classList.add("is-hidden");
                    clearBtn.style.display = "none";
                }
            }
            files.forEach(function (file) {
                if (!file.type || !file.type.startsWith("image/")) {
                    return;
                }
                var reader = new FileReader();
                reader.onload = function (e) {
                    var card = document.createElement("div");
                    card.className = "favorite-card";
                    var thumb = document.createElement("div");
                    thumb.className = "favorite-thumb";
                    var img = document.createElement("img");
                    img.src = e.target.result;
                    img.alt = file.name;
                    thumb.appendChild(img);
                    card.appendChild(thumb);
                    preview.appendChild(card);
                };
                reader.readAsDataURL(file);
            });
        });

        uploadBtn.addEventListener("click", function () {
            if (controls.classList.contains("is-hidden")) {
                controls.classList.remove("is-hidden");
                controls.style.display = "flex";
                if (clearBtn) {
                    clearBtn.classList.add("is-hidden");
                    clearBtn.style.display = "none";
                }
                input.click();
                return;
            }
            if (input.files && input.files.length > 0) {
                form.submit();
                return;
            }
            input.click();
        });
    })();

    (function () {
        var input = document.getElementById("photoFiles");
        var preview = document.getElementById("photoPreview");
        var clearBtn = document.getElementById("photoPreviewClear");
        var controls = document.getElementById("photoUploadControls");
        var previewWrap = document.getElementById("photoPreviewWrap");
        if (clearBtn && input && preview && controls && previewWrap) {
            clearBtn.addEventListener("click", function () {
                input.value = "";
                preview.innerHTML = "";
                previewWrap.classList.add("is-hidden");
                controls.classList.add("is-hidden");
                controls.style.display = "none";
                clearBtn.classList.add("is-hidden");
                clearBtn.style.display = "none";
            });
        }

        document.addEventListener("click", function (e) {
            if (!e.target.classList.contains("photo-deactivate")) return;
            var isThumbnail = e.target.dataset.isThumbnail === "true";
            if (!isThumbnail) return;
            var ok = confirm(window.I18N.mypageOwner.photoDeactivateConfirm);
            if (!ok) {
                e.preventDefault();
                alert(window.I18N.mypageOwner.deleteCanceled);
            }
        });

        document.addEventListener("click", function (e) {
            if (!e.target.classList.contains("photo-delete")) return;
            var isThumbnail = e.target.dataset.isThumbnail === "true";
            if (!isThumbnail) return;
            var ok = confirm(window.I18N.mypageOwner.photoDeleteConfirm);
            if (!ok) {
                e.preventDefault();
                alert(window.I18N.mypageOwner.deleteCanceled);
            }
        });
    })();
</script>

<jsp:include page="../common/footer.jsp"/>
