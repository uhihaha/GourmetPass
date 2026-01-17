/* com/uhi/gourmet/book/BookController.java */
package com.uhi.gourmet.book;

import java.security.Principal;
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

    @Autowired
    private WaitService wait_service;

    @Autowired
    private StoreMapper store_mapper;

    /**
     * [1] 점주용 실시간 매장 관리 센터
     * [404 해결] 리턴 경로를 실제 파일 위치인 "book/manage"로 수정했습니다.
     */
    @GetMapping("/manage")
    public String manage_page(Principal principal, Model model) {
        if (principal == null) return "redirect:/member/login";
        
        String user_id = principal.getName();
        StoreVO store = store_mapper.getStoreByUserId(user_id);
        
        if (store != null) {
            int store_id = store.getStore_id();
            model.addAttribute("store_book_list", book_service.get_store_book_list(store_id));
            model.addAttribute("store_wait_list", wait_service.get_store_wait_list(store_id));
            model.addAttribute("store", store);
        }
        
        // DispatcherServlet이 /WEB-INF/views/book/manage.jsp를 찾도록 경로 고정
        return "book/manage"; 
    }

    /**
     * [2] 예약 등록 프로세스
     * [교정] 예약 완료 시 웨이팅 현황(myStatus)이 아닌 마이페이지(mypage)로 리다이렉트합니다.
     */
    @PostMapping("/register")
    public String register_book(BookVO vo, Principal principal,
                                @RequestParam("store_id") int store_id,
                                @RequestParam("book_date") String date,
                                @RequestParam("book_time") String time,
                                @RequestParam(value="people_cnt", defaultValue="1") int people_cnt,
                                @RequestParam(value="book_price", required=false, defaultValue="0") int book_price) {
        
        if (principal == null) return "redirect:/member/login";

        try {
            // DDL 기반 VO 데이터 세팅
            vo.setUser_id(principal.getName());
            vo.setStore_id(store_id);
            vo.setPeople_cnt(people_cnt);
            vo.setBook_price(book_price);

            // 날짜(YYYY-MM-DD)와 시간(HH:mm)을 결합하여 TIMESTAMP로 파싱하는 로직은 서비스에서 수행
            book_service.register_book(vo, date, time);
            
            // 예약은 줄서기가 아니므로 마이페이지 내 예약 섹션으로 안내하는 것이 정석입니다.
            return "redirect:/member/mypage";
            
        } catch (Exception e) {
            System.err.println("!!! [BOOK REGISTER ERROR] : " + e.getMessage());
            return "redirect:/store/detail?storeId=" + store_id;
        }
    }

    /**
     * [3] 예약 상태 업데이트 (입장/노쇼)
     */
    @PostMapping("/updateStatus")
    public String update_status(@RequestParam("book_id") int book_id, 
                                @RequestParam("status") String status) {
        book_service.update_book_status(book_id, status);
        
        // 상태 변경 후 다시 점주용 관리 페이지로 복귀
        return "redirect:/book/manage";
    }
}