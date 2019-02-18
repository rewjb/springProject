package com.itbank.springProject.db;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository("PlaceCartDAO")
public class PlaceCartDAO {
	
	@Autowired
	private SqlSession session;
	
	public List<PlaceCartDTO> selectAll(String mid){
		return session.selectList("PlaceCart.selectAll",mid);
	}
	
	public void cartInsert(String pid, String mid) {
		
		
	}
	
	
}
