package com.wenxin.controller;

import com.qiniu.common.QiniuException;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;
import com.wenxin.mapper.WOrderInfoMapper;
import com.wenxin.mapper.WOrderMapper;
import com.wenxin.mapper.WProductMapper;
import com.wenxin.mapper.WUserProductMapper;
import com.wenxin.pojo.*;
import com.wenxin.service.WProductService;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName ProductController
 * @Author Spring
 * @DateTime 2019/2/11 21:28
 */
@Controller
@RequestMapping("product")
public class ProductController {
    @Value("${accessKey}")
    private String accessKey;
    @Value("${secretKey}")
    private String secretKey;
    @Value("${bucket}")
    private String bucket;
    @Autowired
    private WProductService productService;
    @Autowired
    private WOrderMapper orderMapper;
    @Autowired
    private WUserProductMapper userProductMapper;
    @Autowired
    private WOrderInfoMapper orderInfoMapper;
    @Autowired
    private WProductMapper productMapper;
    @RequestMapping("pList/{id}")
    public String pList(@PathVariable("id") Integer id, Model model) {
        List<WProduct> products = productService.getListById(id);
        model.addAttribute("productList", products);
        return "pList";
    } @RequestMapping("pList")
    public String pList(String keyword, Model model) {
        List<WProduct> products = productService.getListByKeyword(keyword);
        model.addAttribute("productList", products);
        return "pList";
    }

    @RequestMapping("p/{id}")
    public String p(@PathVariable("id") Integer id, Model model, HttpServletResponse response, HttpServletRequest request) {
        WProduct product=productService.getById(id,response,request,model);
        return "p";
    }
    @RequestMapping("myproduct")
    public String myproduct(HttpSession session,Model model){
        WUser user = (WUser) session.getAttribute("user");
        List<WProduct> products=productService.getMyProduct(user.getId());
        model.addAttribute("products",products);
        return "myproduct";
    }
    @RequestMapping("receiveOrder")
    public String receiveOrder(HttpSession session,Model model){
        WUser user = (WUser) session.getAttribute("user");
        WUserProductExample userProductExample = new WUserProductExample();
        WUserProductExample.Criteria criteria = userProductExample.createCriteria();
        criteria.andUserIdEqualTo(user.getId());
        List<WUserProduct> userProducts = userProductMapper.selectByExample(userProductExample);
        List<Integer> ids=new ArrayList<>();
        for (WUserProduct u : userProducts) {
            ids.add(u.getProductId());
        }
        WOrderInfoExample orderInfoExample = new WOrderInfoExample();
        WOrderInfoExample.Criteria criteria1 = orderInfoExample.createCriteria();
        criteria1.andProductIdIn(ids);
        List<WOrderInfo> infos = orderInfoMapper.selectByExample(orderInfoExample);
        ids=new ArrayList<>();
        for (WOrderInfo i : infos) {
            ids.add(i.getOrderId());
        }
        if(ids.size()==0){
            return "receiveOrder";
        }
        WOrderExample orderExample = new WOrderExample();
        WOrderExample.Criteria criteria2 = orderExample.createCriteria();
        criteria2.andIdIn(ids);
        criteria2.andStateEqualTo(0);
        List<WOrder> orders = orderMapper.selectByExample(orderExample);
        for (WOrder order : orders) {
            WOrderInfoExample wOrderInfoExample = new WOrderInfoExample();
            WOrderInfoExample.Criteria criteria3 = wOrderInfoExample.createCriteria();
            criteria3.andOrderIdEqualTo(order.getId());
            List<WOrderInfo> wOrderInfos = orderInfoMapper.selectByExample(wOrderInfoExample);
            for (WOrderInfo orderInfo : wOrderInfos) {
                WProductExample wProductExample = new WProductExample();
                WProductExample.Criteria criteria4 = wProductExample.createCriteria();
                criteria4.andIdEqualTo(orderInfo.getProductId());
                List<WProduct> products = productMapper.selectByExample(wProductExample);
                orderInfo.setProductName(products.get(0).getName());
            }
            order.setOrderInfoList(wOrderInfos);
        }
        model.addAttribute("orders",orders);
        return "receiveOrder";
    }
    @RequestMapping("myproduct/cancel/{id}")
    public @ResponseBody Result cancel(@PathVariable Integer id){
        productService.updateOff(id);
        return Result.success(null);
    }
    @RequestMapping("myproduct/del/{id}")
    public @ResponseBody Result del(@PathVariable Integer id){
        productService.updateDel(id);
        return Result.success(null);
    }
    public String token() {
        Auth auth = Auth.create(accessKey, secretKey);
        String upToken = auth.uploadToken(bucket);
        return upToken;
    }

    @RequestMapping("upload")
    public @ResponseBody Result upload(MultipartFile file, HttpServletRequest request){
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
    @RequestMapping("myproduct/add")
    public String add(WProduct product,HttpSession session){
        productService.add(product,session);
        return "redirect:/product/myproduct";
    }
}
