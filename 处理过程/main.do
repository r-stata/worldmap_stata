* 把 shp 文件转换成 dta 文件
local name = "worldmap"
shp2dta using `name'/`name', database(`name'_db) coordinates(`name'_coord) genid(ID) gencentroids(centroid) replace 
shp2dta using `name'/`name'_line, database(`name'_line_db) coordinates(`name'_line_coord) genid(ID) replace

* 生成指北针和比例尺的 polygon 数据
use worldmap_db.dta, clear 
use worldmap_coord.dta, clear 
keep if inlist(_ID, 239, 240) 
gen value = 1
save worldmap_polygon, replace 

* 删除 *_db.dta 中的指北针和比例尺
use worldmap_db.dta, clear 
drop if inlist(ID, 239, 240) 
merge m:1 iso3 using 中文国名.dta
drop if _m == 2 
drop _m 

replace country_cn = "皮特凯恩群岛" if country == "Pitcairn Islands"
replace country_cn = "库拉索" if country == "Curaçao"
replace country_cn = "北塞浦路斯" if country == "Northern Cyprus"
replace country_cn = "阿什莫尔岛和卡地亚岛" if country == "Ashmore and Cartier Islands"
replace country_cn = "锡亚琴冰川" if country == "Siachen Glacier"
replace country_cn = "塞舌尔群岛" if country == "Seychelles"
replace country_cn = "瑙鲁" if country == "Nauru"
replace country_cn = "安圭拉" if country == "Anguilla"
replace country_cn = "奥兰群岛" if country == "Aland"
replace country_cn = "南苏丹" if country == "South Sudan"
replace country_cn = "库克群岛" if country == "Cook Islands"
replace country_cn = "马歇尔群岛" if country == "Marshall Islands"
replace country_cn = "圣马力诺" if country == "San Marino"
replace country_cn = "梵蒂冈" if country == "Vatican"
replace country_cn = "百慕大群岛" if country == "Bermuda"
replace country_cn = "圣巴泰勒米" if country == "Saint Barthelemy"
replace country_cn = "诺福克岛" if country == "Norfolk Island"
replace country_cn = "马恩岛" if country == "Isle of Man"
replace country_cn = "摩纳哥" if country == "Monaco"
replace country_cn = "马尔代夫" if country == "Maldives"
replace country_cn = "罗马尼亚" if country == "Romania"
replace country_cn = "根西岛" if country == "Guernsey"
replace country_cn = "索马里兰" if country == "Somaliland"
replace country_cn = "泽西岛" if country == "Jersey"
replace country_cn = "蒙特塞拉特岛" if country == "Montserrat"
replace country_cn = "印度洋领土" if country == "Indian Ocean Territories"
replace country_cn = "瓦利斯群岛和富图纳群岛" if country == "Wallis and Futuna"
replace country_cn = "关岛" if country == "Guam"
replace country_cn = "英属维尔京群岛" if country == "British Virgin Islands"
replace country_cn = "英属印度洋领土" if country == "British Indian Ocean Territory"
replace country_cn = "科索沃" if country == "Kosovo"
replace country_cn = "荷属圣马丁" if country == "Sint Maarten"
replace country_cn = "特克斯和凯科斯群岛" if country == "Turks and Caicos Islands"
replace country_cn = "南极洲" if country == "Antarctica"
replace country_cn = "撒哈拉西部" if country == "Western Sahara"
replace country_cn = "法属圣马丁" if country == "Saint Martin"
replace country_cn = "东帝汶" if country == "East Timor"
replace country_cn = "巴勒斯坦" if country == "Palestine"
save worldmap_db.dta, replace 

* 标签文件处理
use worldmap_label, clear

set obs 241 
replace country = "N" in 240 

replace X = 15500000 in 240 
replace Y = 7800000 in 240 

replace country = "5000km" in 241

replace X = -13633720 in 241 
replace Y = -8090500 in 241 

replace X = X + 600000 if country == "China"
replace Y = Y - 300000 if country == "China"
replace Y = Y + 300000 if country == "United States of America"
replace X = X + 800000 if country == "Russia"
replace Y = Y + 200000 if country == "Russia"
replace X = X + 800000 if country == "Antarctica"
replace Y = Y - 200000 if country == "Antarctica"
merge m:1 iso3 using 中文国名.dta
drop if _m == 2 
drop _m 

replace country_cn = "皮特凯恩群岛" if country == "Pitcairn Islands"
replace country_cn = "库拉索" if country == "Curaçao"
replace country_cn = "北塞浦路斯" if country == "Northern Cyprus"
replace country_cn = "阿什莫尔岛和卡地亚岛" if country == "Ashmore and Cartier Islands"
replace country_cn = "锡亚琴冰川" if country == "Siachen Glacier"
replace country_cn = "塞舌尔群岛" if country == "Seychelles"
replace country_cn = "瑙鲁" if country == "Nauru"
replace country_cn = "安圭拉" if country == "Anguilla"
replace country_cn = "奥兰群岛" if country == "Aland"
replace country_cn = "南苏丹" if country == "South Sudan"
replace country_cn = "库克群岛" if country == "Cook Islands"
replace country_cn = "马歇尔群岛" if country == "Marshall Islands"
replace country_cn = "圣马力诺" if country == "San Marino"
replace country_cn = "梵蒂冈" if country == "Vatican"
replace country_cn = "百慕大群岛" if country == "Bermuda"
replace country_cn = "圣巴泰勒米" if country == "Saint Barthelemy"
replace country_cn = "5000km" if country == "5000km"
replace country_cn = "诺福克岛" if country == "Norfolk Island"
replace country_cn = "马恩岛" if country == "Isle of Man"
replace country_cn = "摩纳哥" if country == "Monaco"
replace country_cn = "马尔代夫" if country == "Maldives"
replace country_cn = "罗马尼亚" if country == "Romania"
replace country_cn = "根西岛" if country == "Guernsey"
replace country_cn = "索马里兰" if country == "Somaliland"
replace country_cn = "泽西岛" if country == "Jersey"
replace country_cn = "蒙特塞拉特岛" if country == "Montserrat"
replace country_cn = "印度洋领土" if country == "Indian Ocean Territories"
replace country_cn = "N" if country == "N"
replace country_cn = "瓦利斯群岛和富图纳群岛" if country == "Wallis and Futuna"
replace country_cn = "关岛" if country == "Guam"
replace country_cn = "英属维尔京群岛" if country == "British Virgin Islands"
replace country_cn = "英属印度洋领土" if country == "British Indian Ocean Territory"
replace country_cn = "科索沃" if country == "Kosovo"
replace country_cn = "荷属圣马丁" if country == "Sint Maarten"
replace country_cn = "特克斯和凯科斯群岛" if country == "Turks and Caicos Islands"
replace country_cn = "南极洲" if country == "Antarctica"
replace country_cn = "撒哈拉西部" if country == "Western Sahara"
replace country_cn = "法属圣马丁" if country == "Saint Martin"
replace country_cn = "东帝汶" if country == "East Timor"
replace country_cn = "巴勒斯坦" if country == "Palestine"
drop if country == "九段线和陆地国界线"
gen group = (inlist(country, "N", "5000km")) 
save worldmap_label2, replace 

use worldmap_db.dta, clear 
* 生成个随机变量
set seed 100
gen value = uniform() * 100
spmap value using worldmap_coord, id(ID) ///
  osize(vvthin ...) ocolor(white ...) ///
  clmethod(custom) clbreaks(0 20 40 60 80 100) ///
  fcolor("224 242 241" "178 223 219" "128 203 196" "77 182 172" "38 166 154") ///
  graphr(margin(medium)) /// 
  polygon(data(worldmap_polygon) fcolor(black) ///
    osize(vvthin)) ///
  label(data(worldmap_label2) x(X) y(Y) ///
    label(country) length(40) size(*0.8)) ///
  line(data(worldmap_line_coord.dta) size(vthin ...) ///
    pattern(solid ...) ///
    color(black ...)) ///
  leg(order(2 "0~20" 3 "20~40" 4 "40~60" 5 "60~80" 6 "80~100") ///
    ring(1) pos(6) row(1)) /// 
  ti("使用 Stata 绘制世界地图") ///
  subti("绘制：微信公众号 RStata") xsize(10) ysize(6) 

gr export "pic1.png", width(2400) replace 

* 中文标签
spmap value using worldmap_coord, id(ID) ///
  osize(vvthin ...) ocolor(white ...) ///
  clmethod(custom) clbreaks(0 20 40 60 80 100) ///
  fcolor("224 242 241" "178 223 219" "128 203 196" "77 182 172" "38 166 154") ///
  graphr(margin(medium)) /// 
  polygon(data(worldmap_polygon) fcolor(black) ///
    osize(vvthin)) ///
  label(data(worldmap_label2) x(X) y(Y) ///
    label(country_cn) length(60) size(*0.8)) ///
  line(data(worldmap_line_coord.dta) size(vthin ...) ///
    pattern(solid ...) ///
    color(black ...)) ///
  leg(order(2 "0~20" 3 "20~40" 4 "40~60" 5 "60~80" 6 "80~100") ///
    ring(1) pos(6) row(1)) /// 
  ti("使用 Stata 绘制世界地图") ///
  subti("绘制：微信公众号 RStata") xsize(10) ysize(6) 

gr export "pic2.png", width(2400) replace 

* 选择部分国家标签添加
spmap value using worldmap_coord, id(ID) ///
  osize(vvthin ...) ocolor(white ...) ///
  clmethod(custom) clbreaks(0 20 40 60 80 100) ///
  fcolor("224 242 241" "178 223 219" "128 203 196" "77 182 172" "38 166 154") ///
  graphr(margin(medium)) /// 
  polygon(data(worldmap_polygon) fcolor(black) ///
    osize(vvthin)) ///
  label(data(worldmap_label2) x(X) y(Y) ///
    select(keep if inlist(country_cn, "中国", "美国", ///
        "俄罗斯", "澳大利亚", "南极洲", "N", "5000km")) /// 
    label(country_cn) length(40) size(*0.8)) ///
  line(data(worldmap_line_coord.dta) size(vthin ...) ///
    pattern(solid ...) ///
    color(black ...)) ///
  leg(order(2 "0~20" 3 "20~40" 4 "40~60" 5 "60~80" 6 "80~100") ///
    ring(1) pos(6) row(1)) /// 
  ti("使用 Stata 绘制世界地图") ///
  subti("绘制：微信公众号 RStata") xsize(10) ysize(6) 

gr export "pic3.png", width(2400) replace 

* 实际数据绘制
use "world-covid19.dta", clear 
* 保留最后一天的数据
sum date 
keep if date == r(max) 
save "mydata", replace 

use worldmap_db.dta, clear 
ren iso3 iso 
merge 1:m iso using mydata
replace confirmed = -1 if missing(confirmed) 
drop if _m == 2 

spmap confirmed using worldmap_coord, id(ID) ///
  osize(vvthin ...) ocolor(white ...) ///
  clmethod(custom) clbreaks(-1 0 1e2 1e3 1e4 1e5 1e6 1e7 1e8) ///
  fcolor(gs10 "255 234 70" "211 193 100" "166 157 117" "124 123 120" "87 92 109" "35 62 108" "0 32 77") ///
  graphr(margin(medium)) /// 
  polygon(data(worldmap_polygon) fcolor(black) ///
    osize(vvthin)) ///
  label(data(worldmap_label2) x(X) y(Y) /// 
    by(group) color(gs13 black) size(*0.6 *0.8) /// 
    select(keep if inlist(country_cn, "中国", "美国", "巴西", ///
        "俄罗斯", "澳大利亚", "南极洲", "N", "5000km")) /// 
    label(country_cn) length(80 ...)) ///
  line(data(worldmap_line_coord.dta) size(vthin ...) ///
    pattern(solid ...) ///
    color(black ...)) ///
  leg(order(2 "无数据" 3 "<= 100" 4 "100~1000" 5 "1000~10000" ///
    6 "10000~100000" 7 "100000~1000000" 8 "1000000~10000000" ///
    9 "10000000~100000000") ///
    ring(1) pos(6) row(2)) /// 
  ti("新冠疫情全球各国/地区确诊人数分布") ///
  subti("日期：2022 年 12 月 14 日") xsize(10) ysize(6) ///
  caption("数据来源：约翰霍普金斯大学", size(*0.8)) 

gr export "pic4.png", width(2400) replace 

* 添加散点图
* data.csv 数据是全球 2016 年人口超过 100 万的大城市，ratio 变量是 2000～2016 年这些城市的人口增长率

* 底图的 crs 是 +proj=eck3 +lat_0=0 +lon_0=150 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"，似乎 geo2xy 命令不支持把经纬度转换成这个坐标系，所以我编写了一个 网页应用来帮助转换：https://czxb.shinyapps.io/crs-trans/
import delimited using "转换后的数据.csv", clear 
gen id = _n 
save temp, replace 

import delimited using "data.csv", clear 
gen id = _n 
merge 1:1 id using temp 
drop id _m 
destring ratio, replace force 

sencode category, gen(group) gsort(ratio)

save pointdata, replace 

cap erase temp.dta 

* 绘制到地图上 
use worldmap_db.dta, clear 
spmap using worldmap_coord, id(ID) ///
  osize(vvthin ...) ocolor(white ...) ///
  fcolor(gs14 ...) ///
  graphr(margin(medium)) /// 
  polygon(data(worldmap_polygon) fcolor(black) ///
    osize(vvthin)) ///
  label(data(worldmap_label2) x(X) y(Y) /// 
    by(group) color(gs10 black) size(*0.5 *0.8) /// 
    label(country_cn) length(80 ...)) ///
  line(data(worldmap_line_coord.dta) size(vthin ...) ///
    pattern(solid ...) ///
    color(black ...)) ///
  leg(pos(6) row(1) ring(1)) ///
  point(data(pointdata) x(x) y(y) proportional(ratio) ///
    shape(Oh ...) size(*0.4) legenda(on) ///
    by(group) fcolor("204 12 0" "92 136 218" "132 189 0" "255 205 0")) ///
  ti("大城市发展的有多快？") ///
  subti("该图展示了 2016 年所有人口超过 100 万的大城市，圆圈的大小和颜色表示" "2000 年到 2016 年间城市人口的平均增长速度。", size(*0.8)) xsize(10) ysize(7) ///
  caption("数据来源: How fast do big cities grow? | Created with Datawrapper\n<https://www.datawrapper.de/_/bKvwd/>" "绘制：微信公众号 RStata", size(*0.6)) 

gr export "pic5.png", width(2400) replace 
