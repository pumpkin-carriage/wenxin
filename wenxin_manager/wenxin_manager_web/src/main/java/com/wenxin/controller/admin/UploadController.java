package com.wenxin.controller.admin;

import com.qiniu.common.QiniuException;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;

/**
 * @ClassName UploadController
 * @Author Spring
 * @DateTime 2019/2/6 15:48
 */
@Controller
public class UploadController {
    @Value("${accessKey}")
    private String accessKey;
    @Value("${secretKey}")
    private String secretKey;
    @Value("${bucket}")
    private String bucket;
    public String token() {
        Auth auth = Auth.create(accessKey, secretKey);
        String upToken = auth.uploadToken(bucket);
        return upToken;
    }

    @RequestMapping("upload")
    public @ResponseBody
    Result upload(MultipartFile file, HttpServletRequest request){
        String fileName = System.currentTimeMillis()+file.getOriginalFilename();
        String filePath= null;
        try {
            filePath = uploadLocal(file,request,fileName);
            uploadQiniu(filePath,fileName);
            File file1 = new File(filePath);
            file1.delete();
            return Result.success(fileName);
        } catch (IOException e) {
            e.printStackTrace();
        }
       return Result.failure("上传失败");
    }

    private void uploadQiniu(String filePath,String fileName) throws QiniuException {
        Configuration configuration = new Configuration();
        UploadManager manager = new UploadManager(configuration);
        manager.put(filePath,fileName,token());
    }

    private String uploadLocal(MultipartFile file, HttpServletRequest request,String fileName) throws IOException {
        String path = request.getSession().getServletContext().getRealPath("/file/" + fileName);
        File file1 = new File(path);
        if (!file1.exists()) {
            file1.mkdirs();
        }
        file.transferTo(file1);
        return path;
    }
}
