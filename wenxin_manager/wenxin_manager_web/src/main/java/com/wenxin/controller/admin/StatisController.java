package com.wenxin.controller.admin;

import com.wenxin.mapper.WLoginInfoMapper;
import com.wenxin.mapper.WProductMapper;
import com.wenxin.pojo.WProduct;
import com.wenxin.utils.BingTuView;
import com.wenxin.utils.ZXT;
import com.wenxin.utils.ZheXianTuView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @ClassName StatisController
 * @Author Spring
 * @DateTime 2019/2/3 10:24
 */
@Controller
@RequestMapping("admin/statis")
public class StatisController {
    @Autowired
    private WLoginInfoMapper loginInfoMapper;
    @Autowired
    private WProductMapper productMapper;
    @RequestMapping("accessPressure")
    public @ResponseBody ZheXianTuView accessPressure(){
        ZheXianTuView<Object> zheXianTu = new ZheXianTuView<>();
        List<ZXT> zxtList = loginInfoMapper.selectInfo();
        for (ZXT zxt : zxtList) {
            zheXianTu.getxData().add(zxt.getX());
            zheXianTu.getyData().add(zxt.getY());
        }
        return zheXianTu;
    }
    @RequestMapping("productSale")
    public @ResponseBody List<BingTuView> productSale(){
       return productMapper.selectInfo();
    }
}
