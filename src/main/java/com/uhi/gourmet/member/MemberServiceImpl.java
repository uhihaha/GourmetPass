package com.uhi.gourmet.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private StoreMapper storeMapper; 

    // security-context.xml에서 등록한 빈(Bean)이 주입됩니다.
    @Autowired
    private BCryptPasswordEncoder pwEncoder;

    // 1. 일반 회원 가입
    @Override
    public void joinMember(MemberVO member) {
        // [비밀번호 암호화] 사용자가 입력한 평문을 해시값으로 변환하여 저장
        member.setUser_pw(pwEncoder.encode(member.getUser_pw()));
        member.setUser_role("ROLE_USER");
        memberMapper.join(member);
    }

    // 2. 점주 가입 (회원 정보 + 가게 정보 등록)
    @Override
    @Transactional // 둘 중 하나라도 실패하면 전체 취소(Rollback) 되도록 설정
    public void joinOwner(MemberVO member, StoreVO store) {
        // 회원 정보 저장
        member.setUser_pw(pwEncoder.encode(member.getUser_pw()));
        member.setUser_role("ROLE_OWNER");
        memberMapper.join(member);

        // 가게 정보 저장 (회원 ID를 외래키로 연결)
        store.setUser_id(member.getUser_id());
        storeMapper.insertStore(store);
    }

    @Override
    public MemberVO getMember(String userId) {
        return memberMapper.getMemberById(userId);
    }

    // 3. 회원 정보 수정
    @Override
    public void updateMember(MemberVO member) {
        // 비밀번호 변경 여부 확인: 입력값이 있을 때만 새롭게 암호화하여 반영
        if (member.getUser_pw() != null && !member.getUser_pw().isEmpty()) {
            String encodedPw = pwEncoder.encode(member.getUser_pw());
            member.setUser_pw(encodedPw);
        } else {
            // 입력값이 없으면 null로 전달하여 SQL에서 기존 비밀번호가 유지되도록 처리
            member.setUser_pw(null);
        }
        memberMapper.updateMember(member);
    }

    @Override
    public void deleteMember(String userId) {
        memberMapper.deleteMember(userId);
    }

    @Override
    public int checkIdDuplicate(String userId) {
        return memberMapper.idCheck(userId);
    }
}