# seadista töökaust oma kõvakettal
setwd("G:/_qfield/qfieldkoolitus20250320")

# juhul kui kasutad seda esmakordselt, installi paketid
# install.packages(c("tidyverse,"sf","progress"))

library(dplyr)
library(readr)
library(sf)
library(ggplot2)
library(progress)

# URL toorik, kus RUUT asendatakse lehe numbriga ning KPV ülelennu kuupäevaga
# OLULINE! ajakohase foto saamiseks tuleb alla laadida ajakohane kartogramm (1:10000).
ofurl <- "https://geoportaal.maaamet.ee/index.php?lang_id=1&plugin_act=otsing&kaardiruut=RUUT&andmetyyp=ortofoto_eesti_rgb&dl=1&f=RUUT_OF_RGB_GeoTIFF_KPV.zip&no_cache=67dc0c447ccdd&page_id=610"
#ofurl<-"https://geoportaal.maaamet.ee/index.php?lang_id=1&plugin_act=otsing&kaardiruut=RUUT&andmetyyp=ortofoto_eesti_rgb&dl=1&f=RUUT_OF_RGB_GeoTIFF_KPV.zip&no_cache=67bab253bbc0a&page_id=610"
# https://geoportaal.maaamet.ee/index.php?lang_id=1&plugin_act=otsing&kaardiruut=63082&andmetyyp=ortofoto_eesti_rgb&dl=1&f=63082_OF_RGB_GeoTIFF_2022_06_25.zip&no_cache=642a32b14d177&page_id=610
# https://geoportaal.maaamet.ee/index.php?lang_id=1&plugin_act=otsing&kaardiruut=53334&andmetyyp=ortofoto_eesti_rgb&dl=1&f=53334_OF_RGB_GeoTIFF_2023_06_08-06_09.zip&no_cache=67bab7d365bba&page_id=610

# Viimase 1:10000 kartogrammi leiab Geoportaalist.
# https://geoportaal.maaamet.ee/est/Ruumiandmed/Kaardilehtede-susteemid/Kaardiruudustikud-allalaadimiseks-p488.html
# lae kartogramm
c10<-st_read("kaardiruudustikud.gpkg","epk10T")

# anna ruudud käsitsi
laeruudud <- c(53331,53332,53333,53334)

# leia ruudud Lagenõmme ja Viidumäe aladele
seireala<-st_read("PR0069sjmk.gpkg","seirealad") %>% filter(seireala_nimi %in% c("Lagenõmme","Viidumäe"))
seirealac10<-c10 %>% st_intersects(seireala)
laeruudud <- c10 %>% slice(which(lengths(seirealac10)>0)) %>% st_drop_geometry() %>% select(NR) %>% unlist() %>% unname()

cells10k<-c10 %>% filter(NR %in% laeruudud)

dstfolder<-"./"
n<-nrow(cells10k)
pb <- progress_bar$new(format = "  laen alla [:bar] :percent eta: :eta", total = n, clear = FALSE, width= 60)
for(i in 1:n) {
  #i<-3
  ruut<-cells10k$NR[i]
  kpv<-cells10k$LENNUAEG[i]
  URL<-gsub("RUUT",ruut,ofurl)
  if(T%in%grepl("-",kpv)) {
    # 10.05.2022-22.05.2022 -> 2022_05_10-05_22
    # 08.06-09.06.2023 -> 2023_06_08-06_09
    kpvs<-unlist(strsplit(kpv,"-"))
    kpvy<-format(as.Date(kpvs[2], format="%d.%m.%Y"), format="%Y")
    fkpv<-paste0(format(as.Date(paste0(kpvs[1],".",kpvy), format="%d.%m.%Y"), format="%Y_%m_%d"), "-", format(as.Date(kpvs[2], format="%d.%m.%Y"), format="%m_%d"))
  }  else {
    fkpv<-format(as.Date(kpv, format="%d.%m.%Y"), format="%Y_%m_%d")
  }
  URL<-gsub("KPV",fkpv,URL)
  down<-try( download.file(URL, destfile = paste0(dstfolder,"/",ruut,"_",fkpv,".zip"), method="curl", quiet=T) )
  pb$tick()
}










