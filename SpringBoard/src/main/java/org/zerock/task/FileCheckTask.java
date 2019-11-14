package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		
		cal.add(Calendar.DATE, -1);
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron="0 0 12 * * *")
	public void checkFiles() throws Exception{
		
		log.warn("File Check Task run................");
		
		log.warn(new Date());
		
		//어제날짜로 보관된 DB첨부파일 목록
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//DB에서 가져온 파일목록 Path로 변환
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		fileList.stream()
				.filter(vo -> vo.isFileType() == true)
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() +"_" + vo.getFileName()))
				.forEach(p -> fileListPaths.add(p));
		
		log.warn("========================================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		//어제날짜로 보관된 폴더 파일
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		//폴더에 있는파일이 DB에 없는 목록 
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("-------------------------------------");
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			
			file.delete();
		}
	}
}
