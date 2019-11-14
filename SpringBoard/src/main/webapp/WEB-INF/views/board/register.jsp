<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">새 글 쓰기</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<style type="text/css">
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li img {
	width: 100px;
}

a {
	text-decoration: none;
	color: black;
}

.uploadResult ul li span {
	color: white;
}

</style>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">새 글 쓰기</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>제목</label> <input class="form-control" name="title">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="3" name="content"></textarea>
					</div>
					<div class="form-group">
						<label>작성자</label> 
						<input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
					</div>
					<button type="submit" class="btn btn-default">등록</button>
					<button type="reset" class="btn btn-default">리셋</button>
					
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
				</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">파일첨부</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
				<div class="uploadResult">
					<ul>

					</ul>
				</div>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel-body -->
	</div>
	<!-- /.panel -->
</div>
<!-- /.row -->
</div>

<script>
$(document).ready(function(e) {
	//form 태그 전송
	var formObj = $("form[role='form']");

	$("button[type='submit']").on("click", function(e) {

		e.preventDefault();

		console.log("submit clicked");
	
		var str='';
		
		$(".uploadResult ul li").each(function(i, obj){
			var jobj = $(obj);
			
			console.dir(jobj);
			
			str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
		});
		
		formObj.append(str).submit();
	});
	//./form태그전송

	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");

	var maxSize = 5242880; //5MB

	function checkExtension(fileName, fileSize) {
		
		if(fileSize > maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일을 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	};
	
	//csrf 토큰값
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$("input[type='file']").change(function(e){
		
		var formData = new FormData();
		
		var inputFile = $("input[name='uploadFile']");
		
		var files = inputFile[0].files;
		
		for(var i=0; i < files.length; i++){
			
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data: formData,
			type: 'post',
			dataType: 'json',
			success: function(result){
				console.log(result);
				showUploadResult(result);
			}
		});
	});
	
	//첨부파일 섬네일 미리보기
	function showUploadResult(uploadResultArr){
		
		if(!uploadResultArr || uploadResultArr.length == 0){
			return;
		}
		
		var uploadUL = $(".uploadResult ul");
		
		var str = "";
		
		$(uploadResultArr).each(function(i, obj){
			if(obj.image){
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
				str += "<span> " +obj.fileName+ "</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'>";
				str += "<i class='fa fa-times'></i></button><br>";
				str += "<img src = '/display?fileName="+fileCallPath+"'>";
				str += "</div></li>";
				
			}else{
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
				str += "<span> " +obj.fileName+ "</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'>";
				str += "<i class='fa fa-times'></i></button><br>";
				str += "<img src = '/resources/img/attach.png'>";
				str += "</div></li>";
			}
		});
		
		uploadUL.append(str);
	}
	
	//첨부파일 삭제
	$(".uploadResult").on("click", "button", function(e){
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: '/deleteFile',
			data:{fileName: targetFile, type: type},
			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			type: 'post',
			dataType: 'text',
			success: function(result){
				alert(result);
				targetLi.remove();
			}
		})
	})
	
});
</script>


<%@ include file="../includes/footer.jsp"%>