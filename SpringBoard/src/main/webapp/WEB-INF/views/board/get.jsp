<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 조회</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 조회</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<div class="form-group">
					<label>번호</label> <input class="form-control" name="bno"
						value='<c:out value="${board.bno }"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>제목</label> <input class="form-control" name="title"
						value='<c:out value="${board.title }"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>내용</label>
					<textarea class="form-control" rows="3" name="content"
						readonly="readonly"><c:out value="${board.content }" />
					</textarea>
				</div>
				<div class="form-group">
					<label>작성자</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer }" />' readonly="readonly">
				</div>
				
				<sec:authentication property="principal" var="pinfo" />
				
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper="modify" class="btn btn-primary">수정하기</button>
					</c:if>
				</sec:authorize>
				
				<button data-oper="list" class="btn btn-success">목록보기</button>

				<form id='operForm' action="/board/modify" method="get">
					<input type="hidden" id='bno' name='bno'
						value='<c:out value="${board.bno }"/>'> <input
						type="hidden" name="pageNum"
						value="<c:out value='${cri.pageNum}'/>"> <input
						type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
					<input type='hidden' name='type'
						value='<c:out value="${cri.type }"/>'> <input
						type='hidden' name='keyword'
						value='<c:out value="${cri.keyword }"/>'>
				</form>
			</div>
			<!-- /.table-responsive -->
		</div>
		<!-- /.panel-body -->
	</div>
	<!-- /.panel -->
</div>


<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>

<style>
.uploadResult {
  width:100%;
  background-color: gray;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  list-style: none;
  padding: 10px;
  align-content: center;
  text-align: center;
}
.uploadResult ul li img{
  width: 100px;
  cursor: pointer;
}
.uploadResult ul li span {
  color:white;
}
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:80%;
  height:100%;
  background-color: gray; 
  z-index: 100;
  background:rgba(255,255,255,0.5);
}
.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

.bigPicture img {
  width:600px;
}

</style>


<!-- 파일첨부화면 -->
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">첨부파일</div>
      <!-- /.panel-heading -->
      
      <div class="panel-body">

        <div class='uploadResult'> 
          <ul>
          </ul>
        </div>
        
      </div>
      <!--  end panel-body -->
    </div>
    <!--  end panel-body -->
  </div>
  <!-- end panel -->
</div>
<!-- /.row -->


<!-- 댓글 화면 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> 댓글
				
				<sec:authorize access="isAuthenticated()">
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글달기</button>
				</sec:authorize>
			</div>
			<!-- /.panel-heading -->
			
			<div class="panel-body">
				<ul class="chat">
				<!-- <li class="left clearfix" data-rno='12'>
						<div>
							<div class="header">
								<strong class="primary-font">아이디</strong>
							</div>
							<p>내용</p>
						</div>
					</li> -->
				</ul>
			</div>
			<!-- /.panel .chat-panel -->
			
			<div class="panel-footer">
			
			</div>
		</div>
		<!-- /.end row -->
	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<!-- 댓글 입력 모달 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>내용</label> <input class="form-control" name="reply" value="new reply!!">
				</div>
				<div class="form-group">
					<label>작성자</label> <input class="form-control" name="replyer" value="replyer" readonly="readonly">
				</div>
				<div class="form-group">
					<label>작성일</label> <input class="form-control" name="replyDate" value="">
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning"
					data-dismiss="modal">수정하기</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger"
					data-dismiss="modal">삭제하기</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary"
					data-dismiss="modal">등록하기</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default"
					data-dismiss="modal">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.댓글 입력 모달 -->

<%@ include file="../includes/footer.jsp"%>

<!-- 댓글 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
	$(document).ready(function() {
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");

			showList(1);

			function showList(page) {
				
				console.log("show list" + page);
				
				replyService.getList({bno : bnoValue, page : page || 1}, function(replyCount, list) {

				console.log("replyCount: " + replyCount);
				console.log("list: " + list);
					
				if(page == -1){
					pageNum = Math.ceil(replyCount / 5.0);
					showList(pageNum);
					return;
				}
				
				var str = "";

					if (list == null || list.length == 0) {
						replyUL.html("");
	
						return;
					}
	
					for (var i = 0, len = list.length || 0; i < len; i++) {
						str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
						str += "<div><div class='header'><strong class='primary-font'>"
								+ list[i].replyer
								+ "</strong>";
						str += "<small class='pull-right text-muted'>"
								+ replyService
										.displayTime(list[i].replyDate)
								+ "</small></div>";
						str += "<p>"
								+ list[i].reply
								+ "</p></div></li>";
					}

					replyUL.html(str);
					
					showReplyPage(replyCount);
						
				}); //end getList
			} //end showList

			var modal=$(".modal");
			var modalInputReply = modal.find("input[name='reply']");
			var modalInputReplyer = modal.find("input[name='replyer']");
			var modalInputReplyDate = modal.find("input[name='replyDate']");
			
			var modalModBtn = $("#modalModBtn");
			var modalRemoveBtn = $("#modalRemoveBtn");
			var modalRegisterBtn = $("#modalRegisterBtn");
			
			var replyer = null;
			
			<sec:authorize access="isAuthenticated()">
				replyer = '<sec:authentication property="principal.username"/>';
			</sec:authorize>
			
			var csrfHeaderName = "${_csrf.headerName}";
			var csrfTokenValue = "${_csrf.token}";
			
			//댓글달기모달창
			$("#addReplyBtn").on("click", function(e){
				
				modal.find("input").val("");
				
				modal.find("input[name='replyer']").val(replyer);
				
				modalInputReplyDate.closest("div").hide();
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				
				modalRegisterBtn.show();
				
				$(".modal").modal("show");
			});
			
			//Ajax spring security header
			$(document).ajaxSend(function(e, xhr, options){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			});
			
			//등록하기 버튼
			modalRegisterBtn.on("click", function(e){
				var reply = {
						reply: modalInputReply.val(),
						replyer: modalInputReplyer.val(),
						bno: bnoValue
				};
				
				replyService.add(reply, function(result){
					alert(result);
					
					modal.find("input").val("");
					modal.modal("hide");
					
					//showList(1);
					showList(-1);
				});
				
			});
			
			//댓글 조회 - 수정, 삭제 모달창
			$(".chat").on("click", "li", function(e){
				var rno = $(this).data("rno");
				
				replyService.get(rno, function(reply){
					modalInputReply.val(reply.reply);
					
					modalInputReplyer.val(reply.replyer).attr("readonly", "readonly");
					
					modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
					
					modal.data("rno", reply.rno);
					
					modal.find("button[id != 'modalCloseBtn']").hide();
					modalModBtn.show();
					modalRemoveBtn.show();
					
					$(".modal").modal("show");
				});
			});
			
			//댓글 수정
			modalModBtn.on("click", function(e){
				
				var originalReplyer = modalInputReplyer.val();
				
				var reply = {
						rno: modal.data("rno"),
						reply: modalInputReply.val(),
						replyer: originalReplyer
				};
				
				if(!replyer){
					alert("로그인 후 수정이 가능합니다.");
					modal.modal("hide");
					return;
				}			
				
				if(replyer != originalReplyer){
					alert("자신이 작성한 댓글만 수정이 가능합니다.");
					modal.modal("hide");
					return;
				}
				
				replyService.update(reply, function(result){
					alert(result);
					modal.modal("hide");
					showList(pageNum);
				})
			});
			
			//댓글 삭제
			modalRemoveBtn.on("click", function(e){
				var rno = modal.data("rno");
				
				if(!replyer){
					alert("로그인 후 삭제가 가능합니다.");
					modal.modal("hide");
					return;
				}
				
				var originalReplyer = modalInputReplyer.val();
				
				if(replyer != originalReplyer){
					alert("자신이 작성한 댓글만 삭제가 가능합니다.");
					modal.modal("hide");
					return;
				}
				
				replyService.remove(rno, originalReplyer, function(result){
					alert(result);
					modal.modal("hide");
					showList(pageNum);
				})
			})
			
			//댓글 페이징 
			var pageNum = 1;
			var replyPageFooter = $(".panel-footer");
			
			function showReplyPage(replyCount){
				var endNum = Math.ceil(pageNum / 5.0) * 5;
				var startNum = endNum - 4;
				
				var prev = startNum != 1;
				var next = false;
				
				if(endNum * 5 >= replyCount){
					endNum = Math.ceil(replyCount / 5.0);
				}
				
				if(endNum * 5 < replyCount){
					next = true;
				}
				
				var str = "<ul class='pagination pull-right'>";
				
				if(prev){
					str += "<li class = 'page-item'><a class='page-link' href='"+(startNum - 1)+"'>이전 </a></li>";
				}
				
				for(var i= startNum; i <= endNum; i++){
					var active = pageNum == i ? "active" : "";
					
					str += "<li class = 'page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
				}
				
				if(next){
					str += "<li class = 'page-item'><a class='page-link' href='"+(endNum + 1)+"'>다음</a></li>"; 
				}
				
				str += "</ul></div>";
				
				console.log(str);
				
				replyPageFooter.html(str);
			}
			
			//댓글페이징 클릭 이동
			replyPageFooter.on("click", "li a", function(e){
				e.preventDefault();
				console.log("page click");
				
				var targetPageNum = $(this).attr("href");
				
				console.log("targetPageNum" + targetPageNum);
				
				pageNum = targetPageNum;
				
				showList(pageNum);
			})
			
	});
</script>

<script>
	console.log("==============");
	console.log("JS TEST");

	var bnoValue = "<c:out value="${board.bno}"/>";

	/* replyService.add({
		reply : "JS Test",
		replyer : "tester",
		bno : bnoValue
	}, function(result) {
		alert("RESULT: " + result);
	});

	replyService.getList({
		bno : bnoValue,
		page : 1
	}, function(list) {
		for (var i = 0, len = list.length || 0; i < len; i++) {
			console.log(list[i]);
		}
	});

	replyService.remove(6, function(count) {
		console.log(count);

		if (count === "success") {
			alert("removed");
		}
	}, function(err) {
		alert("error...");
	});

	replyService.update({
		rno : 9,
		bno : bnoValue,
		reply : "댓글 수정..."
	}, function(result) {
		alert("수정 완료...");
	});

	replyService.get(10, function(data) {
		console.log(data);
	}); */
</script>

<!-- /댓글 -->

<script type="text/javascript">
	$(document).ready(function() {

		var operForm = $("#operForm");

		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});

		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		})

	})
</script>

<!-- 첨부파일 불러오기 -->
<script type="text/javascript">
	$(document).ready(function(){
		(function(){
			var bno = "<c:out value='${board.bno}' />";
			
			$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
				console.log(arr);
				
				var str = '';
				
				$(arr).each(function(i, attach){
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
						
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
						str += "<img src = '/display?fileName="+fileCallPath+"'>";
						str += "</div></li>";
						
					}else{
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
						str += "<span> " +attach.fileName+ "</span><br/>";
						str += "<img src = '/resources/img/attach.png'>";
						str += "</div></li>";
					}
				});
				
				$(".uploadResult ul").html(str);
				
			}); //end getJson
		})(); //end function
		
		/* 첨부파일 클릭시 원본 or 다운로드 */
		$(".uploadResult").on("click", "li", function(e){
			console.log("view image");
			
			var liObj = $(this);
			
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			
			if(liObj.data('type')){
				showImage(path.replace(new RegExp(/\\/g), "/"));
			}else{
				self.location = "/download?fileName="+path
			}
		});
		
		function showImage(fileCallPath){
			//alert(fileCallPath);
			
			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width: '100%', height: '100%'}, 1000);
		}
		
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPictureWrapper").hide();
		});
	});
</script>