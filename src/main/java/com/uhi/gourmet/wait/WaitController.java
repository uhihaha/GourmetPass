package com.uhi.gourmet.wait;

import java.security.Principal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/wait")
public class WaitController {

    @Autowired
    private WaitService wait_service;

    // 실시간 알림 전송을 위한 템플릿 주입
    @Autowired
    private SimpMessagingTemplate messaging_template;

    // 일반 회원: 내 이용현황 페이지 조회
    @GetMapping("/myStatus")
    public String my_status(Principal principal, Model model) {
        // [수정] 로그인하지 않은 사용자가 접근할 경우 NPE 방지 및 로그인 페이지 리다이렉트
        if (principal == null) {
            return "redirect:/member/login";
        }
        
        String user_id = principal.getName();
        List<WaitVO> my_wait_list = wait_service.get_my_wait_list(user_id);
        model.addAttribute("my_wait_list", my_wait_list);
        return "wait/myStatus";
    }

    @PostMapping("/register")
    public String register_wait(WaitVO vo, Principal principal) {
        // [수정] 로그인 체크 방어 코드 추가
        if (principal == null) {
            return "redirect:/member/login";
        }
        
        vo.setUser_id(principal.getName());
        
        // 1. DB에 웨이팅 등록
        wait_service.register_wait(vo);
        
        // 2. 점주에게 실시간 웨이팅 접수 알림 전송
        messaging_template.convertAndSend("/topic/store/" + vo.getStore_id(), "새로운 웨이팅이 접수되었습니다! 번호: " + vo.getWait_num());
        
        return "redirect:/member/mypage";
    }

    // 상태 변경 (점주 관리용) - 웹소켓 알림 로직 추가
    @PostMapping("/updateStatus")
    public String update_status(@RequestParam("wait_id") int wait_id, 
                                @RequestParam(value="user_id", required=false) String user_id,
                                @RequestParam("status") String status) {
        
        // 1. DB 상태 업데이트
        wait_service.update_wait_status(wait_id, status);
        
        // 2. '호출(CALLED)' 상태로 변경 시 해당 사용자에게 웹소켓 알림 전송
        if ("CALLED".equals(status) && user_id != null) {
            messaging_template.convertAndSend("/topic/wait/" + user_id, "입장하실 순서입니다! 매장으로 방문해주세요.");
        }
        
        // 3. 관리 페이지(/book/manage)로 연동 리다이렉트
        return "redirect:/book/manage";
    }

    // 사용자 직접 취소
    @PostMapping("/cancel")
    public String cancel_wait(@RequestParam("wait_id") int wait_id) {
        wait_service.update_wait_status(wait_id, "CANCELLED");
        return "redirect:/wait/myStatus";
    }
}