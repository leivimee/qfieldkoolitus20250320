library(sf)
library(tidyverse)

# Seirealade ja seirepunktide kooondamine geopakki

rp<-st_read("src/PR0069_sjmk_pt.shp")

rp %>%
  rename(
    punkti_nr=kood,
    punkti_kkr_kood=kkr_kood,
    seireala_nimi=seirejaam_,
    seireala_kkr_kood=seirejaa_1
  ) %>%
  select(punkti_nr, punkti_kkr_kood, seireala_nimi, seireala_kkr_kood) %>%
  st_write("PR0069sjmk.gpkg", "punktid", append=F)

ra<-st_read("src/PR0069_sj_ar.shp")

ra %>%
  rename(
    seireala_nimi=nimi,
    seireala_kkr_kood=kkr_kood
  ) %>%
  select(seireala_nimi, seireala_kkr_kood) %>%
  st_write("PR0069sjmk.gpkg", "seirealad", append=F)


c10k<-st_read("src/epk10T.shp")
st_write(c10k,"kaardiruudustikud.gpkg","epk10T")
