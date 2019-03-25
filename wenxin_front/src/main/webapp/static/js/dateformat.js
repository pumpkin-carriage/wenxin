function Todate(num) { //Fri Oct 31 18:00:00 UTC+0800 2008
    num = num + "";
    var date = "";
    var month = new Array();
    month["Jan"] = "01"; month["Feb"] = "02"; month["Mar"] = "03"; month["Apr"] = "04"; month["May"] = "05"; month["Jan"] = "06";
    month["Jul"] = "07"; month["Aug"] = "08"; month["Sep"] = "09"; month["Oct"] = "10"; month["Nov"] = "11"; month["Dec"] = "12";
    var week = new Array();
    week["Mon"] = "一"; week["Tue"] = "二"; week["Wed"] = "三"; week["Thu"] = "四"; week["Fri"] = "五"; week["Sat"] = "六"; week["Sun"] = "日";
    str = num.split(" ");
    date = str[5] + "-";
    date = date + month[str[1]] + "-" + str[2];
    return date;
}

function Todate1(str) {
    var dateStr=str.trim().split(" ");
    var strGMT = dateStr[0]+" "+dateStr[1]+" "+dateStr[2]+" "+dateStr[5]+" "+dateStr[3]+" GMT+0800";
    var date = new Date(Date.parse(strGMT));
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    m = m < 10 ? ('0' + m) : m;
    var d = date.getDate();
    d = d < 10 ? ('0' + d) : d;
    var h = date.getHours();
    var minute = date.getMinutes();
    minute = minute < 10 ? ('0' + minute) : minute;
    var second = date.getSeconds();
    second = second < 10 ? ('0' + second) : second;
    return y+"-"+m+"-"+d+" "+h+":"+minute+":"+second;
}