import com.wenxin.utils.MD5Utils;
import com.wenxin.utils.StrUtils;

/**
 * @ClassName test
 * @Author Spring
 * @DateTime 2019/2/2 10:10
 */
public class test {
    public static void main(String[] args) {
        String uuid = StrUtils.getRandom32UUID();
        String md5 = MD5Utils.md5("123456"+uuid);
        System.out.println(uuid);
        System.out.println(md5);
    }
}
