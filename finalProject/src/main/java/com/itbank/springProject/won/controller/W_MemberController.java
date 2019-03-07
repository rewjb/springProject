package com.itbank.springProject.won.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itbank.springProject.db.MemberDAO;
import com.itbank.springProject.db.MemberDTO;

@Controller
public class W_MemberController{
	
	@Autowired
	@Qualifier("MemberDAO")
	private MemberDAO memberDAO;
	
	@Autowired
	@Qualifier("worker")
	private W_MemberWorker worker;
	
	//회원가입
	@RequestMapping("won/insertMember")
	@ResponseBody
	public String insertMember(MemberDTO memberDTO){
		memberDTO = worker.settingBasicInfo(memberDTO);
 		System.out.print(memberDTO.getMid()+",");
 		System.out.print(memberDTO.getMpw()+",");
 		System.out.print(memberDTO.getMname()+",");
 		System.out.print(memberDTO.getMprofile()+",");
 		System.out.print(memberDTO.getMtel()+",");
 		System.out.print(memberDTO.getMaddr1()+"-");
 		System.out.print(memberDTO.getMaddr2()+",");
 		System.out.print(memberDTO.getGender()+",");
 		System.out.println(memberDTO.getRdate());
		try {
			//insert성공시 insertM으로
			memberDAO.insert(memberDTO);
			System.out.println("insertMember 성공");
			return "0";
		} catch (Exception e) {
			//insert실패시 다시 회원가입 화면으로
			System.out.println("insertMember 실패");
			e.printStackTrace();
			return "1";
		}
	}//end insertMember()
	
	//정보수정
	@RequestMapping("won/updateMember")
	public String updateMember(MemberDTO memberDTO){
		try {
			//정보수정 성공시 : 정보수정 성공한 데이터를 마이페이지에서 확인해줌
			memberDAO.update(memberDTO);
			System.out.println("updateMember 성공");
			return "won/updateM";
		} catch (Exception e) {
			//정보수정 실패시 : 정보수정 하기 전 데이터가 있는 마이페이지로 돌아감
			e.printStackTrace();
			System.out.println("updateMember 실패");
			return "redirect:mypage.jsp";
		}
	}//end updateMember()
	
	//회원탈퇴
	@RequestMapping("won/deleteMember")
	public String deleteMember(@RequestParam("mid") String mid,
			MemberDTO dto){
		try {
			//삭제 진행
			dto.setMid(mid);
			memberDAO.delete(dto);
			return "won/deleteM";
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("deleteMember 실패");
			return "redirect:mypage.jsp";
		}
	}//end deleteMember()
	
	//회원가입시 아이디 중복확인
	@RequestMapping("won/checkMid")
	@ResponseBody
	public String checkMid(@RequestParam("mid") String mid, MemberDTO dto){
		System.out.println("아이디 중복확인 mid:"+ mid);
		System.out.println("아이디 중복확인 dto:"+ dto.getMid());
		try {
			dto.setMid(mid);
			MemberDTO mdto = memberDAO.select(dto);
			if(mdto == null || mdto.getMid().equals("")){
				System.out.println("존재하지 않는 아이디! 가입 가능합니다!");
			}else{
				System.out.println("존재하는 아이디! 가입 불가능!");
			}
			
		} catch (Exception e) {
			//실패시 회원가입 페이지로 돌아감
			e.printStackTrace();
			System.out.println("select실패");
		}
		return mid; 
	}
	
	//회원가입시 이름 중복확인
	@RequestMapping("won/checkMname")
	@ResponseBody
	public String checkMname(@RequestParam("mname") String mname, MemberDTO dto){
		System.out.println("이름 중복확인 mname:"+ mname);
		System.out.println("이름 중복확인 dto:"+ dto.getMname());
		try {
			dto.setMname(mname);
			MemberDTO mdto = memberDAO.selectName(dto);
			if(mdto == null || mdto.getMname().equals("")){
				System.out.println("존재하지 않는 이름! 사용 가능합니다!");
			}else{
				System.out.println("존재하는 이름! 사용 가능!");
			}
			
		} catch (Exception e) {
			//실패시 회원가입 페이지로 돌아감
			e.printStackTrace();
			System.out.println("select실패");
		}
		return mname; 
	}
		
	//로그인 확인 (-1 : db관련 실패 / 0 : 성공 / 1 : 아이디가 없음 / 2 : 비밀번호가 없음)
	@RequestMapping("won/login")
	@ResponseBody
	public String selectIdPw(MemberDTO memberDTO, HttpSession session){
		System.out.println("login!! 잘 찾아왔어!!!");
		try {
			MemberDTO mdto = memberDAO.select(memberDTO);
			//로그인 실패시
			if(mdto == null){
				//아이디가 존재하지 않는경우
				System.out.println("아이디가 존재하지 않습니다.");
				return "1";
			}else{
				//아이디가 존재하는 경우
				//입력받은 비밀번호와 아이디로 검색한 비밀번호가 일치하는지 확인
				if(mdto.getMpw() == memberDTO.getMpw() || 
						mdto.getMpw().equals(memberDTO.getMpw())){
					//일치하는 경우 - 세션에 아이디를 넣어줌!
					System.out.println("controller : 로그인 성공"+memberDTO.getMid());
					session.setAttribute("mid", memberDTO.getMid());
					System.out.println(session.getAttribute("mid"));
					return "0";
				}else{
					//일치하지 않는 경우
					System.out.println("비밀번호가 일치하지 않습니다");
					return "2";
				}
			}
		} catch (Exception e) {
			//실패시 로그인 페이지로 돌아감
			e.printStackTrace();
			System.out.println("select실패");
			return "-1";
		}//end try~catch
	}//end selectIdPw
	
	//마이페이지에 정보수정 페이지에 필요한 개인정보 검색
	@RequestMapping("won/selectMember")
	@ResponseBody
	public String selectMember(Model model, MemberDTO dto,
			@RequestParam("mid") String mid){
		try {
			dto.setMid(mid);
			MemberDTO mdto = memberDAO.select(dto);
			model.addAttribute("memberDTO", mdto);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("select실패");
			return "won/home";
		}
		return "won/selectM";
	}//end selectMember();
	
	@RequestMapping("won/myPage")
	public void myPage() {
		
	}
	
}
