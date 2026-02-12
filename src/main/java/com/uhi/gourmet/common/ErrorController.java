package com.uhi.gourmet.common;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ErrorController {

    @RequestMapping("/error/handler")
    public String handleGeneralError(HttpServletRequest request, Model model) {
        // 서블릿 컨테이너가 전달한 에러 코드 및 메시지 추출
        Object statusCode = request.getAttribute("javax.servlet.error.status_code");
        Object exceptionType = request.getAttribute("javax.servlet.error.exception_type");
        Object message = request.getAttribute("javax.servlet.error.message");
        Object requestUri = request.getAttribute("javax.servlet.error.request_uri");

        model.addAttribute("code", statusCode != null ? statusCode.toString() : "Unknown");
        model.addAttribute("msg", message != null ? message.toString() : "예기치 못한 오류가 발생했습니다.");
        model.addAttribute("uri", requestUri);

        // common.serverError 등의 다국어 처리가 필요하다면 활용 가능
        return "error/commonError"; // 단일 JSP 페이지 호출
    }
}