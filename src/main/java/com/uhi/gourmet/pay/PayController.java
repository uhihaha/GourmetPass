package com.uhi.gourmet.pay;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.siot.IamportRestClient.exception.IamportResponseException;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/pay")
public class PayController {


    @Autowired
    private PaymentService service;




    /* V1 가격이 일치하는지 확인 */
//	@PostMapping("/api/v1/payment/complete")
//	public ResponseEntity<?> paymentVal(@RequestParam String impUid, String apiKey, String apiSecret) throws IamportResponseException, IOException{
//		System.out.println("Controller paymentVal()..................");
//		
//		if(service.paymentVal(impUid)) {
//			int payId = service.getPayIdByImpUid(impUid);	// impUid로 payId를 가져옴
//			return ResponseEntity.ok(payId);		// 가격이 같을경우 js로 payId보냄
//		} else {
//			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);	// 가격이 다를경우
//		}
//		
//	}

    // 가격이 일치하는지 확인
    @PostMapping("/api/v2/payment/complete")
    public ResponseEntity<?> paymentVal(@RequestBody Map<String, String> body) throws IamportResponseException, IOException {
        System.out.println("Controller paymentVal()..............");
        String paymentId = body.get("paymentId");
        System.out.println("전달받은 paymentId: " + paymentId);

        if (service.paymentVal(paymentId)) {
            int payId = service.getPayIdByImpUid(paymentId);
            return ResponseEntity.ok(payId);        // 가격이 같을경우
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);    // 가격이 다를경우
        }

    }
    
    	// 모바일의 경우 결제
    @GetMapping("/api/v2/payment/complete/mobile")
    public void mobilePaymentComplete(
            @RequestParam("paymentId") String paymentId,
            @RequestParam("storeId") int storeId,
            @RequestParam("book_date") String bookDate,
            @RequestParam("book_time") String bookTime,
            @RequestParam("people_cnt") int peopleCnt,
            HttpServletResponse response,
            HttpServletRequest request) throws IOException, IamportResponseException {
        
        System.out.println("========== 모바일 결제 검증 ==========");
        System.out.println("paymentId: " + paymentId);
        System.out.println("storeId: " + storeId);
        System.out.println("book_date: " + bookDate);
        System.out.println("book_time: " + bookTime);
        System.out.println("people_cnt: " + peopleCnt);
        System.out.println("====================================");
        
        String contextPath = request.getContextPath();
        
        try {
            if(service.paymentVal(paymentId)) {
                int payId = service.getPayIdByImpUid(paymentId);
                
                // 검증 성공 후 예약 정보와 함께 상세 페이지로 리다이렉트
                String redirectUrl = String.format(
                    "%s/store/detail?storeId=%d&pay_id=%d&book_date=%s&book_time=%s&people_cnt=%d&status=success",
                    contextPath, storeId, payId, bookDate, bookTime, peopleCnt
                );
                
                System.out.println("리다이렉트 URL: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else {
                System.out.println("결제 검증 실패!");
                response.sendRedirect(contextPath + "/store/detail?storeId=" + storeId + "&status=fail");
            }
        } catch (Exception e) {
            System.err.println("모바일 결제 처리 중 오류: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(contextPath + "/store/detail?storeId=" + storeId + "&status=fail");
        }
    }


    /* v1 환불 */
//	@PostMapping(value = "/api/v1/payment/refund", consumes = "application/json")
//	public ResponseEntity<?> refund(@RequestBody Map<String, ?> body) throws IamportResponseException, IOException{
//		
//		System.out.println("Controller refund()..................");
//		System.out.println("pay_id 값 : "+ body.get("pay_id"));		// pay_id의 값
//		PayVO pay_vo;
//		pay_vo = service.getPayById((int) body.get("pay_id"));	// pay_id로 환불할 Pay값 가져와 pay_vo에 넣기
//		
//		if(service.refund(pay_vo.getImp_uid())) {	// pay_vo에 있는 impUid 값으로 환불 Service 실행
//			
//			return ResponseEntity.ok().build();		// 환불 성공
//		} else {
//			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);	// 환불 안될 경우
//		}
//		
//		
//	}	

    @PostMapping(value = "/api/v2/payment/refund", consumes = "application/json")
    public ResponseEntity<?> refund(@RequestBody Map<String, Object> body) throws IamportResponseException, IOException {
        System.out.println("Controller refund()..................");
        System.out.println("pay_id 값 : " + body.get("pay_id"));        // pay_id의 값
        PayVO pay_vo;
        pay_vo = service.getPayById((int) body.get("pay_id"));    // pay_id로 환불할 Pay값 가져와 pay_vo에 넣기

        if (service.refund(pay_vo.getPayment_id())) {    // pay_vo에 있는 payment_id 값으로 환불 Service 실행

            return ResponseEntity.ok().build();           // 환불 성공
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);    // 환불 안될 경우
        }


    }


}
