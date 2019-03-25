package com.wenxin.service.impl;

import com.wenxin.mapper.WOrderExtMapper;
import com.wenxin.mapper.WOrderInfoMapper;
import com.wenxin.mapper.WOrderMapper;
import com.wenxin.mapper.WUserMapper;
import com.wenxin.pojo.*;
import com.wenxin.service.OrderService;
import com.wenxin.utils.DateUtil;
import com.wenxin.utils.Pagnation;
import org.apache.poi.xssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

/**
 * @ClassName OrderServiceImpl
 * @Author Spring
 * @DateTime 2019/2/7 11:39
 */
@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private WOrderMapper orderMapper;
    @Autowired
    private WOrderExtMapper orderExtMapper;
    @Autowired
    private WUserMapper userMapper;
    @Autowired
    private WOrderInfoMapper orderInfoMapper;
    @Override
    public void print(String time, HttpServletResponse response, HttpServletRequest request) throws IOException {
        List<WOrder> orders = orderMapper.selectByTime(time);
        XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(request.getSession().getServletContext().getRealPath("/static/template/order-template.xlsx")));//创建工作簿
        XSSFSheet sheet = wb.getSheet("订单信息");//创建工作表
        /*no username totalMoney paytime receiver address phone*/
        List<String[]> list = new ArrayList<>();
        for (int i = 0; i < orders.size(); i++) {
            WOrder order = orders.get(i);
            String[] str = new String[5];
            str[0] = order.getNo();
            str[3] = DateUtil.dateToString(order.getCreateTime());
            WUser user = userMapper.selectByPrimaryKey(order.getUserId());
            str[1] = user.getUserName();
            WOrderExtExample example = new WOrderExtExample();
            WOrderExtExample.Criteria criteria = example.createCriteria();
            criteria.andOrderIdEqualTo(order.getId());
            List<WOrderExt> orderExts = orderExtMapper.selectByExample(example);
            str[2] = orderExts.get(0).getReceiver();
            str[4] = orderExts.get(0).getPhone();
            list.add(str);
        }
        XSSFRow row0 = sheet.getRow(0);
        XSSFCell cell0 = row0.getCell(0);
        cell0.setCellValue("温馨商城(" + time + ")订单信息");
        if (orders.size() == 0) {
            XSSFRow row1 = sheet.getRow(2);
            for (int i = 0; i < 5; i++) {
                row1.getCell(i).setCellValue("");
                row1.getCell(i).setCellStyle(null);
            }
        }
        XSSFRow row = sheet.getRow(2);
        XSSFCellStyle[] style = new XSSFCellStyle[5];
        for (int i = 0; i < style.length; i++) {
            style[i] = row.getCell(i).getCellStyle();
        }
        for (int i = 0; i < list.size(); i++) {
            String[] strings = list.get(i);
            XSSFRow sheetRow = sheet.createRow(i + 2);
            for (int j = 0; j < 5; j++) {
                XSSFCell cell = sheetRow.createCell(j);
                cell.setCellValue(strings[j]);
                cell.setCellStyle(style[j]);
            }
        }
        String filename = "温馨商城(" + time + ")订单-" + System.currentTimeMillis();
        response.setContentType("application/x-download");
        response.setCharacterEncoding("utf-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + new String(filename.getBytes("gbk"), "iso8859-1") + ".xlsx");
        wb.write(response.getOutputStream());
    }

    @Override
    public Pagnation<WOrder> getOrderPage(Integer page, Integer limit) {
        WOrderExample example = new WOrderExample();
        WOrderExample.Criteria criteria = example.createCriteria();
        int totalCount = orderMapper.countByExample(example);
        Pagnation<WOrder> pagnation = new Pagnation<>(page, limit, totalCount);
        List<WOrder> orders = orderMapper.selectInfo(pagnation.getBegin(), pagnation.getPageSize());
        orders.forEach(order -> {
            WUser user = userMapper.selectByPrimaryKey(order.getUserId());
            if (user != null) {
                order.setUsername(user.getUserName());
            }
        });
        Collections.sort(orders, new Comparator<WOrder>() {
            @Override
            public int compare(WOrder o1, WOrder o2) {
                return (int) (o2.getCreateTime().getTime() - o1.getCreateTime().getTime());
            }
        });
        pagnation.setData(orders);
        return pagnation;
    }

    @Override
    public boolean deleteByIds(List<Integer> toIntegerList) {
        WOrderExample example = new WOrderExample();
        WOrderExample.Criteria criteria = example.createCriteria();
        criteria.andIdIn(toIntegerList);
        orderMapper.deleteByExample(example);
        WOrderExtExample extExample = new WOrderExtExample();
        WOrderExtExample.Criteria criteria1 = extExample.createCriteria();
        criteria1.andOrderIdIn(toIntegerList);
        orderExtMapper.deleteByExample(extExample);
        WOrderInfoExample infoExample = new WOrderInfoExample();
        WOrderInfoExample.Criteria criteria2 = infoExample.createCriteria();
        criteria2.andOrderIdIn(toIntegerList);
        orderInfoMapper.deleteByExample(infoExample);
        return true;

    }
}
