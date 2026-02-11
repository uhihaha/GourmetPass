/* src/main/webapp/resources/js/main.js */
$(document).ready(function() {
    // i18n 유틸리티 함수 초기화 (전역 객체 확인)
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    /**
     * [추가] 브라우저 기본 검증 메시지를 다국어 메시지로 치환
     * required 속성에 의한 기본 툴팁 메시지를 프로젝트 i18n 메시지로 덮어씁니다.
     */
    const searchInput = document.querySelector(".search-input");
    if (searchInput) {
        // 사용자가 입력을 시작하면 에러 상태를 초기화
        searchInput.addEventListener("input", function() {
            this.setCustomValidity("");
        });
        // 필드가 비어있는 상태에서 제출 시도 시 다국어 메시지 주입
        searchInput.addEventListener("invalid", function() {
            this.setCustomValidity(t("storeList.searchRequired", "검색어를 입력해주세요."));
        });
    }

    /**
     * 공통 클릭 이벤트 핸들러
     */
    $(".clickable").on("click", function() {
        var url = $(this).data("url");
        if(url) {
            location.href = url;
        }
    });

    // 검색창 엔터키 입력 시 폼 제출
    $(".search-input").on("keypress", function(e) {
        if (e.which == 13) {
            // reportValidity()를 통해 HTML5 검증을 수행하고 설정된 커스텀 메시지를 출력함
            if (this.reportValidity()) {
                $(this).closest("form").submit();
            }
        }
    });

    // 즐겨찾기(Favorite) 로직
    var favoriteButtons = document.querySelectorAll(".favorite-toggle");
    if (favoriteButtons.length) {
        var contextPath = (typeof APP_CONFIG !== "undefined" && APP_CONFIG.contextPath)
            ? APP_CONFIG.contextPath
            : "";
        var isOwner = (typeof APP_CONFIG !== "undefined" && APP_CONFIG.isOwner === true);

        function updateFavoriteButton(btn, isFavorite) {
            if (isFavorite) {
                btn.classList.add("active");
                btn.textContent = "❤️";
            } else {
                btn.classList.remove("active");
                btn.textContent = "🤍";
            }
        }

        function loadFavorites() {
            if (isOwner) {
                favoriteButtons.forEach(function(btn) {
                    updateFavoriteButton(btn, false);
                });
                return;
            }
            $.ajax({
                url: contextPath + "/favorite/list",
                type: "GET",
                dataType: "json"
            }).done(function(res) {
                var storeIds = new Set((res.storeIds || []).map(String));
                favoriteButtons.forEach(function(btn) {
                    var storeId = btn.dataset.storeId;
                    updateFavoriteButton(btn, storeIds.has(String(storeId)));
                });
            });
        }

        favoriteButtons.forEach(function(btn) {
            btn.addEventListener("click", function(e) {
                e.preventDefault();
                e.stopPropagation();

                if (isOwner) {
                    alert(t("storeDetail.favoriteOwnerBlock", "점주 계정은 즐겨찾기를 할 수 없습니다."));
                    return;
                }

                $.ajax({
                    url: contextPath + "/favorite/toggle",
                    type: "POST",
                    data: { store_id: btn.dataset.storeId },
                    beforeSend: function(xhr) {
                        if (typeof APP_CONFIG !== "undefined") {
                            xhr.setRequestHeader("X-CSRF-TOKEN", APP_CONFIG.csrfToken);
                        }
                    }
                }).done(function(res) {
                    updateFavoriteButton(btn, !!res.favorite);
                }).fail(function(xhr) {
                    if (xhr.status === 401) {
                        // i18n 적용: 로그인 필요 메시지
                        alert(t("common.loginRequired", "로그인이 필요합니다."));
                    } else if (xhr.status === 403) {
                        alert(t("storeDetail.favoriteOwnerBlock", "점주 계정은 즐겨찾기를 할 수 없습니다."));
                    } else {
                        // i18n 적용: 즐겨찾기 오류 메시지
                        alert(t("common.favoriteError", "즐겨찾기 처리 중 오류가 발생했습니다."));
                    }
                });
            });
        });

        loadFavorites();
    }
});
