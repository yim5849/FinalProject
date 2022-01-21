package com.pai.spring.board.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pai.spring.board.model.dao.BoardDao;
import com.pai.spring.board.model.vo.Board;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDao dao;
	
	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public List<Board> boardList(int cPage,int numPerPage) { 
		return dao.boardList(session,cPage,numPerPage);
	}

	@Override
	public int selectBoardCount() { 
		return dao.selectBoardCount(session);
	}

}
