package com.uhi.gourmet.common;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.uhi.gourmet.store.StoreService; // [수정] Mapper 대신 Service 임포트
import com.uhi.gourmet.store.StoreVO;

@Controller
public class MainController {

    // [수정] 프로젝트의 Service-oriented 아키텍처를 준수하여 StoreService 주입
    @Autowired
    private StoreService storeService;

    // 홈페이지 접속 시 실행되는 메서드
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String mainPage(Model model) {
        
        // [1] 인기 맛집 조회 (StoreService를 통해 조회수 높은 순으로 데이터 로드)
        // StoreService에 getStoreList(null, null, null) 등을 호출하거나 
        // 별도의 인기 매장 메서드를 연동합니다.
        List<StoreVO> storeList = storeService.getStoreList(null, null, null);
        
        // [2] 화면(main.jsp)으로 데이터 전달
        model.addAttribute("storeList", storeList);
        
        // [3] views/main.jsp 파일을 보여줌
        return "main"; 
    }
}