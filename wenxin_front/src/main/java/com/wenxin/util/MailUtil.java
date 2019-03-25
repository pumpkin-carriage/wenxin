package com.wenxin.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailMessage;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.BodyPart;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 * @ClassName MailUtil
 * @Author Spring
 * @DateTime 2019/2/10 9:26
 */
@Component
public class MailUtil {
    @Value("${mail_from}")
    private String mail_from;
    @Value("${qiniuDomain}")
    private String qiniu;
    @Value("${bg}")
    private String bg;
    @Autowired
    private JavaMailSender mailSender;

    public void sendMail(String to, String title, String content) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setFrom(mail_from);
            helper.setTo(to);
            helper.setSubject(title);
            helper.setText("<html>\n" +
                    "\t<body style=\"background: url("+qiniu+bg+"?_="+Math.random()+") center;\">\n" +
                    "\t\t<strong><em style=\"color: blue;font-family:仿体;\">"+content+"</em></strong>\n" +
                    "\t</body>\n" +
                    "</html>", true);
            mailSender.send(message);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
