package com.uhi.gourmet.member;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/*
 * [핵심] UserDetailsService 란?
 * - Spring Security에게 "우리 DB에서 회원을 어떻게 찾는지" 알려주는 역할입니다.
 * - 로그인 버튼을 누르면 Security가 자동으로 이 클래스의 loadUserByUsername()을 호출합니다.
 * * @Service("customUserDetailsService"):
 * - security-context.xml에서 <authentication-provider user-service-ref="customUserDetailsService"> 
 * 설정과 일치해야 정상적으로 빈(Bean)이 주입됩니다.
 */
@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberMapper;

    /*
     * [로그인 처리 핵심 메서드]
     * 1. 사용자가 입력한 아이디(username)를 전달받음
     * 2. DB에서 해당 아이디의 회원 정보를 조회
     * 3. Security 표준 객체인 UserDetails(User)로 변환하여 리턴
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        // 1. DB에서 회원 정보 조회
        MemberVO vo = memberMapper.getMemberById(username); 

        // 2. 회원이 존재하지 않을 경우 예외 처리
        if (vo == null) {
            throw new UsernameNotFoundException("해당 아이디를 찾을 수 없습니다: " + username);
        }

        /*
         * 3. [변환] MemberVO -> UserDetails
         * - vo.getUser_id(): 사용자 ID
         * - vo.getUser_pw(): 암호화된 비밀번호 (BCryptPasswordEncoder로 비교됨)
         * - vo.getUser_role(): 권한 문자열 (예: ROLE_USER, ROLE_OWNER)
         */
        return new User(
            vo.getUser_id(),
            vo.getUser_pw(),
            Collections.singletonList(new SimpleGrantedAuthority(vo.getUser_role()))
        );
    }
}