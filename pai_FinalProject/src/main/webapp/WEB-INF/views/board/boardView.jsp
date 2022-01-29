<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<jsp:include page="/WEB-INF/views/common/header.jsp"/> 
<script src="http://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@ page import="com.pai.spring.board.model.vo.Board" %> 
<%
	Board b=(Board)request.getAttribute("board");
%>
<style>
section>*{
	 font-family: sans-serif;
}
.main>div{
	 font-weight: bold;
}
 
</style>
<section>
	<div class="container" style="margin-top:50px;"> 
	 <div class="row main" style="border-bottom:1px gray solid;">
	    <div class="col-1">
	      <h1 style="color:blue; font-family:fantasy">${board.boardCategory}</h1>
	    </div>
	    <div class="col">
	      <h1>${board.boardTitle} [${commentCount}]</h1> 
	    </div>
	   
	  </div>
	  
	    <div class="row" style="border-bottom:2px gray solid;">
		    <div class="col-2" style="width:auto;">
		      ${board.boardWriter.member_nick}
		    </div>
		    <div class="col-7">
		      ${board.boardEnrollDate }
		    </div>
		    <div class="col-1" style="text-align:right;">
		      조회수 ${board.boardReadCount }
		    </div>
		    <div class="col-1  " style="text-align:right;"  >
		      추천수 <span>${board.recommendCount }</span>
		    </div>
		    <div class="col-1" style="text-align:right;">
		      댓글 ${commentCount}
		    </div>
	    </div>
	    
	    <!-- 첨부파일이 있으면 carousel이 보임 -->
	    <c:if test="${board.attachFile.size()>0}">
	    	<div id="carouselExampleDark" class="carousel carousel-dark slide" data-bs-ride="carousel" style="height:350px;">
			  <div class="carousel-indicators">
			   <%for(int i=0;i<b.getAttachFile().size();i++){%>
			    <button type="button" data-bs-target="#carouselExampleDark" data-bs-slide-to="<%=i%>" class="active" aria-current="true" aria-label="Slide <%=i+1%>"></button>
			   <%} %>  
			  </div>
			  <div class="carousel-inner"> 
			    <div class="carousel-item active" data-bs-interval="10000">
			      <img style="height:350px;" src="${path}/resources/upload/board/${board.getAttachFile().get(0).getAttachFileName()}" class="d-block w-100" alt="...">
			    </div>
			    <%for(int i=1;i<b.getAttachFile().size();i++){%>
				    <div class="carousel-item" data-bs-interval="2000">
				      <img style="height:350px;" src="${path}/resources/upload/board/<%=b.getAttachFile().get(i).getAttachFileName()%>" class="d-block w-100" alt="...">
				    </div> 
			    <%} %> 
			    
			</div>
			  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="prev">
			    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
			    <span class="visually-hidden">Previous</span>
			  </button>
			  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="next">
			    <span class="carousel-control-next-icon" aria-hidden="true"></span>
			    <span class="visually-hidden">Next</span>
			  </button>
			</div> 
	    </c:if>
	    
	   <!-- 게시글 내용 -->
		<div class="form-floating" style="margin-top:30px;">
		  <textarea class="form-control" placeholder="Leave a comment here" id="floatingTextarea2" style="height: 150px; resize: none;" readonly></textarea>
		  <label for="floatingTextarea2">${board.boardContent}</label>
		</div>
		
	   <!-- 신고&공유&추천버튼 -->	
	    
	  <div class="row justify-content-md-center" style="margin-top:30px; margin-left:400px; margin-right:400px;">
	        <div class="btn-group" role="group" aria-label="Third group">
	        	<button type="button" class="btn btn-danger">
	      			<img style="height:15px; width:15px;"src="${path}/resources/images/board/siren.png">&nbsp;신고
	      		</button>
	        	<button type="button" class="btn btn-info">
					<img style="height:15px; width:15px;"src="${path}/resources/images/board/share.png">&nbsp;공유
   		  		</button>
			    <button type="button" class="btn btn-info" id="recommend" onclick="location.replace('${path}/board/boardLike.do?boardNo=${board.boardNo}&memberId=${loginMember.member_id}')">
			    	<img style="height:20px; width:20px;"src="${path}/resources/images/board/recommended.png">
			    	<c:if test="${like==null}">&nbsp;추천</c:if>	
			    	<c:if test="${like!=null}">&nbsp;추천취소</c:if>		 
			    </button>
			    <button type="button" class="btn btn-info" id="likeCount">${board.recommendCount}</button>
		    </div>
	  </div>  
	    
	   <!-- 댓글보기  --> 
	   	<p style="font-size: 15px;font-weight: bolder;">전체댓글 : ${commentCount}개</p>
 	    <table class="container" id="tbl-comment" style="border-top:2px black solid;">
	    	<c:forEach var="bc" items="${comments}"> 
	    	  <c:if test="${bc.commentLevel==1}">
			    	<tr class="level1" style="border-bottom:1px gray solid;">
			    		<td>
		    			  <div class="row">
						    <div class="col-2">	
							  <span class="comment-writer"><c:out value="${bc.commentWriter}"/></span> 
						    </div>
					        <div class="col"> 
    						  <span><c:out value="${bc.commentContent}"/></span> 
						    </div>
						    <div class="col-2"> 
						   	  <span class="comment-date "><c:out value="${bc.commentDate}"/></span>
						    </div>
						  </div>
			    		</td>
			    		<td>
							<c:if test="${loginMember!=null}">  
								<button class="btn-reply" value=<c:out value="${bc.commentNo}"/>>답글</button>
								<c:if test="${loginMember.member_id eq 'admin' || loginMember.member_nick eq bc.commentWriter}">  
									<button type="button" data-bs-toggle="modal" data-bs-target="#commentDelete" class="btn-delete">삭제</button>
								</c:if>
							</c:if>		
							<!-- Modal -->
							<div class="modal fade" id="commentDelete" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
							  <div class="modal-dialog">
							    <div class="modal-content">
							      <div class="modal-header">
							        <h5 class="modal-title" id="staticBackdropLabel">댓글 삭제</h5>
							        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							      </div>
							      <div class="modal-body">
							        댓글을 정말 삭제하시겠습니까?
							      </div>
							      <div class="modal-footer">
							        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">아니오</button>
							        <button type="button" class="btn btn-primary" onclick="location.replace('${path}/board/commentDelete.do?commentNo=${bc.commentNo}&boardNo=${board.boardNo}')">네</button>
							      </div>
							    </div>
							  </div>
							</div>			
						</td>
			    	</tr>
	    	  </c:if>
	    	  <c:if test="${bc.commentLevel==2}">
	    	  		<tr class="level2" >
						<td  style="padding-left:100px;">
							<div class="row">
							    <div class="col-2">	
								  <span class="comment-writer" style="color:gray; font-size: 16px;">ㄴ<c:out value="${bc.commentWriter}"/></span> 
							    </div>
						        <div class="col"> 
	    						  <span style="color:gray; font-size: 16px;"> <c:out value="${bc.commentContent}"/></span> 
							    </div>
							    <div class="col-2"> 
							   	  <span class="comment-date " style="color:gray; font-size: 16px;"><c:out value="${bc.commentDate}"/></span>
							    </div>
						    </div>
						</td>
						<td>
						</td>
					</tr>
	    	  </c:if>
		    </c:forEach>		
	    </table>
	    
 
	   <!-- 댓글 입력창 -->
 	   <div id="comment-container" style="margin-top:30px; border-top:2px gray solid;">
			<div class="comment-editor" style="margin-top:10px;">
				<form action="${path}/board/insertBoardComment.do" method="post">
					<label style="text-align:center;"><c:out value="${loginMember.member_nick}"></c:out></label>
					<c:if test="${loginMember!=null}"> 
						<textarea name="commentContent" cols="140" rows="2" style="resize: none;"></textarea>
					</c:if>
					<c:if test="${loginMember==null}"> 
						<textarea name="commentContent" cols="140" rows="2" style="background-color:gray;resize: none;" readonly>댓글작성은 회원만 가능합니다.</textarea>
					</c:if>
					<input type="hidden" name="commentLevel" value="1">
					<input type="hidden" name="commentWriter" value="${loginMember.member_nick}"  > 
					<input type="hidden" name="boardRef" value="${board.boardNo}"  >
					<input type="hidden" name="commentRef" value="0">
					<button type="submit" id="btn-insert" class="btn btn-outline-primary">등록</button>
				</form>
			</div>
		</div> 
	    
	    
	    
	   <!-- 이전글/다음글/글쓰기 버튼 -->
	     <div class="row" style="border-top:2px gray solid; margin-top:20px;">
		    <div class="col" style="margin-top:10px;" >
		       <div class="d-grid gap-2 d-md-block"  >
				  <button class="btn btn-primary" id="before" type="button" onclick="before();">이전글</button>
				  <button class="btn btn-primary" type="button" onclick="after();">다음글</button>
				</div>
		    </div>
		    <!-- 내가 쓴글일때 수정&삭제버튼이 보임 -->
		    <c:if test="${loginMember.member_id eq board.boardWriter.member_id}"> 
			    <div class="col-1" style="margin-top:10px; padding:0px; width:60px;" >
			       <button class="btn btn-primary" type="button" onclick="location.assign('${path}/board/boardUpdate.do?boardNo=${board.boardNo}')">수정</button>
			    </div>
			     <div class="col-1" style="margin-top:10px; padding:0px; width:60px;" >
			       <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop">삭제</button>
			    </div> 
		    </c:if>
		    <div class="col-1" style="margin-top:10px; padding:0px;" >
		       <button class="btn btn-primary" type="button" onclick="location.assign('${path}/board/boardList.do')">전체목록</button>
		    </div>
		    
		    <!-- 삭제 Modal -->
			<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
			  <div class="modal-dialog">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="staticBackdropLabel">게시물 삭제</h5>
			        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			      </div>
			      <div class="modal-body">
			        정말 게시물을 삭제하시겠습니까? 
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">아니오</button>
			        <button type="button" class="btn btn-primary" onclick="location.replace('${path}/board/boardDelete.do?boardNo=${board.boardNo}')">네</button>
			      </div>
			    </div>
			  </div>
			</div>
		    
		  </div> 	   
	</div>
</section>

<script>
	const before=()=>{ 
		$.ajax({
			url:"${path}/board/ajax/boardView.do",
			data:{boardNo:${board.boardNo-1}},
			success:data=>{
				console.log(data);
				if(data){
					alert('이전글이 없습니다');
				}else{
					location.assign('${path}/board/boardView.do?boardNo='+${board.boardNo-1}); 
				} 
			}		
		})
	}
	
	const after=()=>{ 
		$.ajax({
			url:"${path}/board/ajax/boardView.do",
			data:{boardNo:${board.boardNo+1}},
			success:data=>{
				console.log(data);
				if(data){
					alert('현재 게시글이 마지막 글입니다!');
				}else{
					location.assign('${path}/board/boardView.do?boardNo='+${board.boardNo+1}); 
				} 
			}		
		})
	}
	
	$(()=>{
		$(".btn-reply").click(e=>{
			const test=$("#tbl-comment").find("form");
			console.log(test); 
			$(test).parent().remove();
			const tr=$("<tr>");
			const form=$(".comment-editor>form").clone();
			console.log(form);
			form.attr({"action":"${path}/board/insertBoardComment2.do"})
			form.find("textarea").attr({"rows":"1"});
			form.find("input[name=commentLevel]").val("2");
			form.find("input[name=commentRef]").val($(e.target).val());
			form.find("button").removeAttr("id").addClass("btn-insert2");
			const td=$("<td>").attr({"colspan":"2"})
			td.append(form);
			tr.append(td);
			$(e.target).parents("tr").after(tr);
		
		})
		 
	
	})

	
/*	$("#recommend1").click(e=>{
		console.log($("#likeCount").text(this));
		$.ajax({ 
			url:"${path}/board/ajax/boardLike.do",
			type:"get",
			data:{memberId:"${loginMember.member_id}",boardNo:${board.boardNo}},
			success:data=>{
				console.log(data);
				if(data){ 
					$("#likeName").text("추천취소");
					$("#likeCount").text(this)+1;
				}else{ 
					$("#likeName").text("추천");
					$("#likeCount").text()-1;
				}
			}
		})
	}) */
	
	
	
	
	
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>