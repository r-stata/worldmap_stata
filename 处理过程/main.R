library(sf)
library(tidyverse)
rnaturalearthdata::countries50 %>% 
  st_as_sf() -> worldMap 

worldMap %>% 
  select(country = admin, continent, 
         iso3 = adm0_a3) %>% 
  as_tibble() %>% 
  st_sf() %>% 
  st_transform(4326) -> worldMap 

# 修正中国的部分
read_sf("2021行政区划/省.shp") %>% 
  st_union() %>% 
  nngeo::st_remove_holes() -> cn

read_sf("2021行政区划/九段线.shp") -> jdx
cn %>% 
  st_sf() %>% 
  mutate(country = "China",
         continent = "Asia",
         iso3 = "CHN") -> cn

worldMap %>% 
  st_make_valid() %>% 
  st_difference(cn) %>% 
  dplyr::filter(!country %in% c("China", "Hong Kong S.A.R.", 
                                "Macao S.A.R", "Taiwan")) %>% 
  select(-contains(".")) -> worldMap

worldMap %>% 
  add_row(cn) %>% 
  arrange(country) -> worldMap

# 调整为太平洋为中心
target_crs <- st_crs("+proj=eck3 +lat_ts=0 +lat_0=0 +lon_0=150 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# 生成一个细长的多边形
offset <- 180 - 150 

polygon <- st_polygon(x = list(rbind(
  c(-0.000001 - offset, 90),
  c(0 - offset, 90),
  c(0 - offset, -90),
  c(-0.000001 - offset, -90),
  c(-0.000001 - offset, 90)
))) %>%
  st_sfc() %>%
  st_sf() %>% 
  st_set_crs(4326)

# plot(polygon)
# plot(worldMap["country"], add = T)

# 从世界地图上删除和这个多边形重合的部分 
worldMap %>% 
  st_make_valid() %>% 
  st_transform(4326) %>% 
  st_difference(polygon) -> world2

# 转换坐标系
world2 %>% 
  st_transform(crs = target_crs) -> world3

ggplot(data = st_simplify(world3, dTolerance = 2000), aes(group = iso3)) +
  geom_sf(fill = "grey") +
  coord_sf(crs = target_crs)

# 保存为 shp 数据
dir.create("worldmap0")
world3 %>% 
  st_make_valid() %>% 
  st_write("worldmap0/worldmap0.shp", layer_options = "ENCODING=UTF-8", delete_layer = TRUE, layer = "MULTIPOLYGON") 

# 保存九段线数据
dir.create("jdx")
jdx %>% 
  st_transform(target_crs) %>% 
  st_make_valid() %>% 
  st_collection_extract("LINESTRING") %>% 
  st_write("jdx/jdx.shp", layer_options = "ENCODING=UTF-8", delete_layer = TRUE, layer = "MULTILINESTRING") 

# 合并两个数据
world3 %>% 
  st_make_valid() -> world3
jdx %>% 
  st_transform(target_crs) %>% 
  st_make_valid() %>% 
  st_collection_extract("LINESTRING") %>% 
  set_names(c("country", "geometry")) -> jdx 

world3 %>% 
  add_row(jdx) -> world4

st_bbox(world4)

# 添加指北针和比例尺
# 绘制指北针
x0 <- 13000000
y0 <- 5000000
mycrs <- target_crs
tribble(
  ~x, ~y,
  x0 + 2500000, y0 + 800000,
  x0 + 2500000, y0 + 2500000,
  x0 + 3000000, y0 + 500000,
  x0 + 2500000, y0 + 800000
) %>% 
  as.matrix() %>% 
  list() %>% 
  st_polygon() -> left
# plot(left)

tribble(
  ~x, ~y,
  x0 + 2000000, y0 + 500000,
  x0 + 2500000, y0 + 2500000,
  x0 + 2500000, y0 + 800000,
  x0 + 2000000, y0 + 500000
) %>% 
  as.matrix() %>% 
  st_linestring() -> right

# 绘制比例尺
x0 <- -16333720
y0 <- -8860500
tribble(
  ~x, ~y,
  x0, y0 + 0,
  x0 + 1250000, y0 + 0,
  x0 + 1250000, y0 + 400000,
  x0, y0 + 400000,
  x0, y0 + 0
) %>% 
  as.matrix() %>% 
  st_linestring() -> m1

tribble(
  ~x, ~y,
  x0 + 1250000, y0 + 0,
  x0 + 1250000, y0 + 400000,
  x0 + 2500000, y0 + 400000,
  x0 + 2500000, y0 + 0,
  x0 + 1250000, y0 + 0
) %>% 
  as.matrix() %>% 
  list() %>% 
  st_polygon() -> m2

tribble(
  ~x, ~y,
  x0 + 2500000, y0 + 0,
  x0 + 2500000, y0 + 400000,
  x0 + 3750000, y0 + 400000,
  x0 + 3750000, y0 + 0,
  x0 + 2500000, y0 + 0
) %>% 
  as.matrix() %>% 
  st_linestring() -> m3

tribble(
  ~x, ~y,
  x0 + 3750000, y0 + 0,
  x0 + 3750000, y0 + 400000,
  x0 + 5000000, y0 + 400000,
  x0 + 5000000, y0 + 0,
  x0 + 3750000, y0 + 0
) %>% 
  as.matrix() %>% 
  list() %>% 
  st_polygon() -> m4

st_multilinestring(list(m1, m3)) %>% 
  st_sfc(crs = mycrs) -> scale1
st_multipolygon(list(m2, m4)) %>% 
  st_sfc(crs = mycrs) -> scale2

st_multilinestring(list(right)) %>% 
  st_sfc(crs = mycrs) -> northarrow1
st_multipolygon(list(left)) %>% 
  st_sfc(crs = mycrs) -> northarrow2 

world4 %>% 
  st_simplify(dTolerance = 20000) -> wdsim 

world4 %>% 
  add_row(
    northarrow1 %>% 
      st_sf() %>% 
      mutate(country = "指北针1")
  ) %>% 
  add_row(
    northarrow2 %>% 
      st_sf() %>% 
      mutate(country = "指北针2")
  ) %>% 
  add_row(
    scale1 %>% 
      st_sf() %>% 
      mutate(country = "比例尺1")
  ) %>% 
  add_row(
    scale2 %>% 
      st_sf() %>% 
      mutate(country = "比例尺2")
  ) -> world5

# 保存成 shp 格式
world5

dir.create("worldmap")
world5 %>% 
  st_make_valid() %>% 
  st_collection_extract("POLYGON") %>% 
  st_write("worldmap/worldmap.shp", layer_options = "ENCODING=UTF-8", delete_layer = TRUE, layer = "MULTIPOLYGON") 

# 提取 LINESTRING
world5 %>% 
  st_make_valid() %>% 
  st_cast("MULTILINESTRING") %>% 
  st_write("worldmap/worldmap_line.shp", layer_options = "ENCODING=UTF-8", delete_layer = TRUE, layer = "MULTILILINESTRING") 

# 各国标签坐标数据
world5 %>% 
  slice(1:239) %>% 
  st_point_on_surface() -> world5_label

# ggplot(data = world5, aes(group = iso3)) +
#   geom_sf(fill = "grey") + 
#   geom_sf_label(data = world5_label, aes(label = country)) + 
#   coord_sf(crs = target_crs)

bind_cols(
  world5_label %>% 
    st_drop_geometry(),
  world5_label %>% 
    st_coordinates() %>% 
    as_tibble() 
) %>% 
  haven::write_dta("worldmap_label.dta", label = "微信公众号 RStata") 
