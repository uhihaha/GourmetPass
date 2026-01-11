package com.uhi.gourmet.book;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;
import com.uhi.gourmet.wait.WaitService;

@Controller
@RequestMapping("/book")
public class BookController {

    @Autowired
    private BookService book_service;

    // 실시간 관리를 위해 대기 서비스와 매장 매퍼 추가 주입
    @Autowired
    private WaitService wait_service;

    @Autowired
    private StoreMapper store_mapper;

    // [추가] 점주용 실시간 관리 페이지 로드 로직
    @GetMapping("/manage")
    public String manage_page(Principal principal, Model model) {
        String user_id = principal.getName();
        StoreVO store = store_mapper.getStoreByUserId(user_id);
        
        if (store != null) {
            int store_id = store.getStore_id();
            // JSP에서 사용하는 변수명(store_book_list, store_wait_list)과 일치시킴
            model.addAttribute("store_book_list", book_service.get_store_book_list(store_id));
            model.addAttribute("store_wait_list", wait_service.get_store_wait_list(store_id));
            model.addAttribute("store", store);
        }
        return "book/manage";
    }

    @PostMapping("/register")
    public String register_book(BookVO vo, Principal principal,
                                @RequestParam("store_id") int store_id,
                                @RequestParam("book_date") String date,
                                @RequestParam("book_time") String time,
                                @RequestParam(value="people_cnt", defaultValue="1") int people_cnt) {
        
        // [디버깅 로그] 400 에러 발생 여부를 확인하기 위해 반드시 콘솔을 확인하세요.
        System.out.println("====== [BOOK DEBUG START] ======");
        System.out.println("USER_ID: " + (principal != null ? principal.getName() : "Guest"));
        System.out.println("STORE_ID: " + store_id);
        System.out.println("DATE: " + date);
        System.out.println("TIME: " + time);
        System.out.println("PEOPLE: " + people_cnt);
        System.out.println("================================");

        try {
            // 1. 사용자 ID 수동 주입 (로그인 필수)
            if (principal == null) return "redirect:/member/login";
            vo.setUser_id(principal.getName());
            vo.setStore_id(store_id);
            vo.setPeople_cnt(people_cnt);

            // 2. 날짜와 시간을 합쳐서 Date 객체로 변환
            String full_date = date + " " + time; // yyyy-MM-dd HH:mm
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date combined_date = sdf.parse(full_date);
            vo.setBook_date(combined_date);
            
            // 3. 서비스 호출
            book_service.register_book(vo);
            
        } catch (Exception e) {
            System.err.println("!!! [BOOK ERROR] : " + e.getMessage());
            e.printStackTrace();
            return "redirect:/store/detail?store_id=" + store_id;
        }
        
        return "redirect:/member/mypage";
    }

    // [추가] 예약 상태 업데이트 처리 (방문/노쇼)
    @PostMapping("/updateStatus")
    public String update_status(@RequestParam("book_id") int book_id, 
                                @RequestParam("status") String status) {
        book_service.update_book_status(book_id, status);
        return "redirect:/book/manage";
    }
}