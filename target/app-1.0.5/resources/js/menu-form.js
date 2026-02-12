/* src/main/webapp/resources/js/menu-form.js */
(function() {
    var t = (window.I18N_UTIL && typeof window.I18N_UTIL.t === "function")
        ? window.I18N_UTIL.t
        : function(key, fallback) { return fallback || key; };

    function applyRequiredMessage(inputEl, message) {
        if (!inputEl) return;
        inputEl.addEventListener("input", function() {
            inputEl.setCustomValidity("");
        });
        inputEl.addEventListener("invalid", function() {
            inputEl.setCustomValidity(message);
        });
    }

    function resizeImageFile(file, maxWidth, maxHeight, quality) {
        return new Promise(function(resolve) {
            if (!file.type || file.type.indexOf("image/") !== 0) {
                resolve(file);
                return;
            }

            var img = new Image();
            var url = URL.createObjectURL(file);
            img.onload = function() {
                var width = img.width;
                var height = img.height;
                var ratio = Math.min(maxWidth / width, maxHeight / height, 1);
                var canvas = document.createElement("canvas");
                canvas.width = Math.round(width * ratio);
                canvas.height = Math.round(height * ratio);
                var ctx = canvas.getContext("2d");
                ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                URL.revokeObjectURL(url);

                canvas.toBlob(function(blob) {
                    if (!blob) {
                        resolve(file);
                        return;
                    }

                    var resized = new File([blob], file.name, {
                        type: blob.type,
                        lastModified: Date.now()
                    });
                    resolve(resized);
                }, file.type === "image/png" ? "image/png" : "image/jpeg", quality);
            };

            img.onerror = function() {
                URL.revokeObjectURL(url);
                resolve(file);
            };

            img.src = url;
        });
    }

    function initMenuForm(form) {
        if (!form) return;

        var menuNameInput = form.querySelector("input[name='menu_name']");
        var menuPriceInput = form.querySelector("input[name='menu_price']");
        var menuImageInput = form.querySelector("input[type='file'][name='file']");

        applyRequiredMessage(menuNameInput, t("menu.validation.nameRequired", "메뉴 이름을 입력하세요."));
        applyRequiredMessage(menuPriceInput, t("menu.validation.priceRequired", "가격을 입력하세요."));

        form.addEventListener("submit", function(e) {
            if (!menuNameInput || !menuPriceInput) return;

            var name = menuNameInput.value ? menuNameInput.value.trim() : "";
            var price = menuPriceInput.value ? menuPriceInput.value.trim() : "";

            if (!name) {
                menuNameInput.setCustomValidity(t("menu.validation.nameRequired", "메뉴 이름을 입력하세요."));
                menuNameInput.reportValidity();
                e.preventDefault();
                return;
            }

            if (!price) {
                menuPriceInput.setCustomValidity(t("menu.validation.priceRequired", "가격을 입력하세요."));
                menuPriceInput.reportValidity();
                e.preventDefault();
                return;
            }

            if (Number(price) < 0) {
                menuPriceInput.setCustomValidity(t("menu.validation.priceNonNegative", "가격은 0원 이상이어야 합니다."));
                menuPriceInput.reportValidity();
                e.preventDefault();
                return;
            }

            menuNameInput.setCustomValidity("");
            menuPriceInput.setCustomValidity("");
        });

        if (menuImageInput) {
            menuImageInput.addEventListener("change", function() {
                if (!menuImageInput.files || menuImageInput.files.length === 0) return;

                var file = menuImageInput.files[0];
                resizeImageFile(file, 400, 400, 0.7).then(function(resized) {
                    var dataTransfer = new DataTransfer();
                    dataTransfer.items.add(resized);
                    menuImageInput.files = dataTransfer.files;
                });
            });
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        initMenuForm(document.getElementById("menuForm"));
    });
})();
