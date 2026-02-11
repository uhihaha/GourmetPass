/* com/uhi/gourmet/wait/WaitController.java */
package com.uhi.gourmet.wait;

import java.security.Principal;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.uhi.gourmet.member.MemberService;

@Controller
@RequestMapping("/wait") // 중복을 피하기 위해 /store/wait 제거
public class WaitController {

    @Autowired
    private WaitService wait_service;
    
    @Autowired
    private MemberService member_service;

    @Autowired
    private SimpMessagingTemplate messaging_template; // websocket 실시간 알림
    
    @Autowired
    private MessageSource messageSource; // 다국어 메시지 처리

    // 1. 나의 웨이팅 현황 페이지 조회
    @GetMapping("/status")
    public String my_status(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/member/login";
        }
        
        String user_id = principal.getName();
        model.addAllAttributes(member_service.getMyStatusSummary(user_id));
        
        return "wait/wait_status";
    }

   // 2. 웨이팅 등록
    @PostMapping("/register")
    public String register_wait(WaitVO vo, Principal principal, HttpServletRequest request, 
                               RedirectAttributes rttr, Locale locale) {
        if (principal == null) {
            return "redirect:/member/login";
        }
        
        // 점주는 웨이팅 불가능
        if (request.isUserInRole("ROLE_OWNER")) {
            String msg = messageSource.getMessage("store.detail.owner.block", null, locale);
            rttr.addFlashAttribute("msg", msg);
            return "redirect:/store/detail?storeId=" + vo.getStore_id();
        }
        
        String user_id = principal.getName();
        vo.setUser_id(user_id);
        
        try {
            wait_service.register_wait(vo);
            // 성공 메시지
            String successMsg = messageSource.getMessage("wait.register.success", null, locale);
            rttr.addFlashAttribute("msg", successMsg);
        } catch (IllegalStateException e) {
            // 에러 메시지 (다국어)
            String errorMsg = messageSource.getMessage("wait.already.exists", null, locale);
            rttr.addFlashAttribute("msg", errorMsg);
            return "redirect:/store/detail?storeId=" + vo.getStore_id();
        }
        
        // 점주에게 실시간으로 알림
        messaging_template.convertAndSend("/topic/store/" + vo.getStore_id(), 
            "새로운 웨이팅 접수! 번호: " + vo.getWait_num());
        messaging_template.convertAndSend("/topic/store/" + vo.getStore_id() + "/waitUpdate", "REFRESH");
        
        return "redirect:/wait/status";
    }

    // 3. 상태 업데이트 (점주 호출/입장/취소)  manage.jsp에서 /wait/updateStatus로 요청을 보내도록 수정해야 함
    @PostMapping("/updateStatus")
    public String update_status(@RequestParam("wait_id") int wait_id, 
                                @RequestParam(value="user_id", required=false) String user_id,
                                @RequestParam("status") String status) {
        
        WaitVO wait = wait_service.get_wait_detail(wait_id); 
        wait_service.update_wait_status(wait_id, status);
        
        if (wait != null) {
            int store_id = wait.getStore_id();

            // 고객에게 개별 알림
            if ("CALLED".equals(status) && user_id != null) {
                messaging_template.convertAndSend("/topic/wait/" + user_id, status);
            }
            
            // 대기열 변경 시 전체 고객에게 알림 -> 대기 순서 갱신
            messaging_template.convertAndSend("/topic/store/" + store_id + "/waitUpdate", "REFRESH");
        }
        
        // 관리자 페이지로 다시 돌아감
        return "redirect:/book/manage";
    }
    

    // 4. 웨이팅 취소 (Ajax)
    @PostMapping("/cancel")
    @ResponseBody 
    public Map<String, Object> cancel_wait(@RequestParam("wait_id") int wait_id) {
        Map<String, Object> result = new HashMap<>();
        try {
            WaitVO wait = wait_service.get_wait_detail(wait_id);
            wait_service.update_wait_status(wait_id, "CANCELLED");
            
            // 대기열 갱신 알림
            if (wait != null) {
                messaging_template.convertAndSend("/topic/store/" + wait.getStore_id() + "/waitUpdate", "REFRESH");
            }
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}