cd "~/Desktop/使用 Stata 绘制以太平洋为中心的世界地图/" 
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

* 移动指北针到左上方
* 指北针包含三个部分，线性部分、多边形部分和标签部分，因此需要同时修改 worldmap_line_coord.dta、worldmap_polygon.dta 和 worldmap_label2.dta 文件

* 首先使用 freestyle 确定位置坐标

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
  caption("数据来源: How fast do big cities grow? | Created with Datawrapper\n<https://www.datawrapper.de/_/bKvwd/>" "绘制：微信公众号 RStata", size(*0.6)) freestyle 

gr export "pic6.png", width(2400) replace 

*- 移动线条
use worldmap_line_db.dta, clear 
*- 指北针对应的 ID 是 240 和 241 
use worldmap_line_coord.dta, clear 
replace _X = _X - 30000000 if inlist(_ID, 240, 241)
save worldmap_line_coord2.dta, replace 

*- 移动多边形
use worldmap_polygon, clear 
* worldmap_polygon 数据中指北针对应的 ID 是 239 (四个点围成三角形) 
replace _X = _X - 30000000 if inlist(_ID, 239) 
save worldmap_polygon2, replace 

*- 移动标签
use worldmap_label2, clear 
replace X = X - 30000000 if country == "N"
save worldmap_label22, replace 

*- 重新绘图
use worldmap_db.dta, clear 
spmap using worldmap_coord, id(ID) ///
  osize(vvthin ...) ocolor(white ...) ///
  fcolor(gs14 ...) ///
  graphr(margin(medium)) /// 
  polygon(data(worldmap_polygon2) fcolor(black) ///
    osize(vvthin)) ///
  label(data(worldmap_label22) x(X) y(Y) /// 
    by(group) color(gs10 black) size(*0.5 *0.8) /// 
    label(country_cn) length(80 ...)) ///
  line(data(worldmap_line_coord2.dta) size(vthin ...) ///
    pattern(solid ...) ///
    color(black ...)) ///
  leg(pos(6) row(1) ring(1)) ///
  point(data(pointdata) x(x) y(y) proportional(ratio) ///
    shape(Oh ...) size(*0.4) legenda(on) ///
    by(group) fcolor("204 12 0" "92 136 218" "132 189 0" "255 205 0")) ///
  ti("大城市发展的有多快？") ///
  subti("该图展示了 2016 年所有人口超过 100 万的大城市，圆圈的大小和颜色表示" "2000 年到 2016 年间城市人口的平均增长速度。", size(*0.8)) xsize(10) ysize(7) ///
  caption("数据来源: How fast do big cities grow? | Created with Datawrapper\n<https://www.datawrapper.de/_/bKvwd/>" "绘制：微信公众号 RStata", size(*0.6)) 

gr export "pic7.png", width(2400) replace 

