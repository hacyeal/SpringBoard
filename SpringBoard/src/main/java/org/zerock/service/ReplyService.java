package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO vo);
	
	public ReplyVO get(long rno);  
	
	public int modify(ReplyVO vo);
	
	public int remove(long rno);
	
	public List<ReplyVO> getList(Criteria cri, long bno);
	
	public ReplyPageDTO getListPage(Criteria cri, long bno);
}
