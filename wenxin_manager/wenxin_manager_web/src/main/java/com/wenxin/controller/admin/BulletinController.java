package com.wenxin.controller.admin;

import com.wenxin.pojo.WBulletin;
import com.wenxin.service.BulletinService;
import com.wenxin.utils.Pagnation;
import com.wenxin.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @ClassName BulletinController
 * @Author Spring
 * @DateTime 2019/2/13 15:07
 */
@RestController
@RequestMapping("admin/bulletin")
public class BulletinController {
    @Autowired
    private BulletinService bulletinService;
    @GetMapping
    public Result getPageBulletin(@RequestParam(value = "page",defaultValue = "1") Integer page, @RequestParam(value = "limit",defaultValue = "6") Integer limit){
        Pagnation<WBulletin> pagnation=bulletinService.findPage(page,limit);
        return Result.success(pagnation);
    }
    @DeleteMapping
    public Result deleteBulletins(@RequestBody Integer[] ids){
        bulletinService.deleteBulletins(ids);
        return Result.success(null);
    }
    @PostMapping
    public Result addBulletin(WBulletin bulletin){
        bulletinService.addBulletin(bulletin);
        return Result.success(null);
    }
}
