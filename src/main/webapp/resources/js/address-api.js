/* /resources/js/address-api.js */

// Geocoder 객체 전역 생성 (카카오 맵 API 로드 필수)
const geocoder = new kakao.maps.services.Geocoder();

/**
 * 주소 검색 및 좌표 추출 공통 함수
 * @param {string} prefix - 필드 ID의 접두사 ('user' 또는 'store')
 */
function execDaumPostcode(prefix = 'user') {
    new daum.Postcode({
        oncomplete: function(data) {
            // 1. 주소 조합 (도로명/지번)
            var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            
            // 2. 입력 필드 요소 가져오기 (prefix 결합) 
            const zipField = document.getElementById(prefix + '_zip');
            const addr1Field = document.getElementById(prefix + '_addr1');
            const addr2Field = document.getElementById(prefix + '_addr2');
            const latField = document.getElementById(prefix + '_lat');
            const lonField = document.getElementById(prefix + '_lon');

            // 3. 필드가 존재할 때만 값 주입 (에러 방지 및 팝업 닫힘 보장)
            if (zipField) zipField.value = data.zonecode;
            if (addr1Field) addr1Field.value = addr;

            // 4. 좌표 변환 로직 실행 
            geocoder.addressSearch(addr, function(results, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var result = results[0];
                    if (latField) latField.value = result.y; // 위도
                    if (lonField) lonField.value = result.x; // 경도
                    
                    // 성공 메시지 (jQuery 활용) [cite: 11, 34]
                    $("#coordStatus").html("<span class='msg-ok'>📍 좌표 추출 완료!</span>");
                } else {
                    $("#coordStatus").html("<span class='msg-no'>❌ 좌표 추출 실패</span>");
                }
            });
            
            // 5. 상세주소 포커스 (필드 존재 여부 확인)
            if (addr2Field) addr2Field.focus();
        }
    }).open();
}