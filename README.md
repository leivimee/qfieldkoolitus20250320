QField koolitus 20.03.2025
================

## Eesmärk

Käesoleva koolituse eesmärk on läbi teha praktiline ülesanne, kus
valmistatakse ette välioludes andmete kogumiseks toimiv QField projekt.
See hõlmab järgnevaid tegevusi:

- QGIS projekti loomine, kasutatavate aluskaartide lisamine projekti
- Kogutavate vaatluste salvestamiseks mõeldud kaardifailide loomist
- Sisestusvormide kohandamist
- Projekti eksport QField või QFieldCloud jaoks

Käesolev juhend annab pealiskaudse kirjelduse etappidest, mis koolituse
käigus juhendaja eestvedamisel läbitakse.

## QGIS projekti loomine

Projektiks nimetatakse tööseansi seisu. Tööseanss sisaldab kihtide
vaatesse laetud kaardimaterjale ning neile omistatud stiile ning
muudatusi omadusted. Tööseansi olek on võimalik salvestada
projektifailiks, millel on QGZ laiend. Projekti lisamine menüü kaudu
toimub järgnevalt.

`Projekt` \> `Uus`

### Aluskaartide lisamine

Lisa allikatesse [Geoportaali
teenuste](https://geoportaal.maaamet.ee/est/teenused/wms-wfs-wcs-teenused-p65.html)
lehelt WMS fotokaart: <https://kaart.maaamet.ee/wms/fotokaart>?.
Fotokaart sisaldab kahte olulist aluskaarti:

- [Hübriidkaart](https://geoportaal.maaamet.ee/index.php?lang_id=1&page_id=296)
- [Ortofoto](https://geoportaal.maaamet.ee/est/Ruumiandmed/Ortofotod-p99.html)

`Brauser` \> `WMT/WMTS` \> RMB[^1] \> `Uus ühendus`

Menüü kaudu toimida järgnevalt

`Kiht` \> `Andmeallika haldur` \> `WMS/WMTS` \> `Uus ühendus`

> :heavy_check_mark: WMS allikate seadistus on vaja teha vaid esimesel
> QGIS kasutuskorral. Järgmistel kordadel on lisatud allikad juba
> allikate brauseris olemas.

> :warning: WMS aluskaartide kasutamine on võimalik vaid olukorras, kus
> on tagatud püsiv internetiühendus 4G/5G võrgu kaudu. Juhul kui see
> võimalik ei ole, on tungivalt soovitatav ette valmistada ka Maa- ja
> ruumiameti ortofotodest koostatud aluskaart.

### Ortofotode allalaadimine \[edasijõudnutele\]

Ortofototosid kaardilehted kaupa saab alla laadida
[Geoportaali](https://geoportaal.maaamet.ee/index.php?lang_id=1&page_id=610)
vahendusel. Seda võib teha käsitsi, teades kaardilehtede numbreid, kuid
suurte alade kohta, kus on vaja alla laadida kümneid kaardilehti, on see
äärmiselt tülikas. Lihtne allalaadimise algoritm on esitatud R-koodis
[ofdown.R](/ofdown.R). Selles tuleb eelnevalt seadistada allalaetavate
kaardilehtede numbrid. Eelnevalt on omale vaja alla laadida värskeim
1:10000 kartogramm. Koodis tuleb vajalike ruutude allalaadimiseks muuta
järgnevat rida.

    laeruudud <- c(53331,53332,53333,53334)

### Taustamaterjalide lisamine

Vaatluste kogumisel on sageli vaja infot ka seireala või seirealal asuva
mõõtekoha kohta, et sealt vajalikke andmeid seostada. Näiteks
rähniseires on vajalik teada punkti numbrit, et seirevaatlused saaks
sooritatud õiges seirepunktis.

Lisa kihtide loetellu rähniseire alad ja rähniseire punktid.
Kaardifailis [PR0069sjmk.gpkg](/PR0069sjmk.gpkg), sisaldub kaks kihti:
punktid ja seirealad.

Järgnevalt seadista taustakihtide stiilid.

Viimaseks sammuks projekti loomisel on selle salvestamine. :tada:

## Vaatluste alusfailide loomine

Järgnevas loome kaks kaardikihti, millesse salvestame vaatluskoha ning
vaatluse alguse andmed ning vaadeldud isendite asukohad ning vajaliku
lisainfo.

Loo uus kiht peibutuspunktide registreerimiseks, tehes seda menüü kaudu:

`Kiht` \> `Loo kiht` \> `New GeoPackage layer`

- Andmebaas: “loendus.gpkg”
- Tabeli nimi: “punkt”
- Geomeetria tüüp: Punkt

Lisa väljad:

- skeem (sõne)
- punkti_nr (täisarv)
- vaatleja (sõne)
- kommentaar (sõne)
- datetime (kuupäev ja kellaaeg)

Loo uus kiht vaatluste registreerimiseks:

- Andmebaas: “loendus.gpkg”
- Tabeli nimi: “vaatlus”
- Geomeetria tüüp: Punkt

Lisa väljad:

- skeem (sõne)
- punkti_nr (täisarv)
- liik (sõne)
- arv (täisarv)
- sugu (sõne)
- tegevus (sõne)
- pkood (sõne)
- paare (täisarv)
- vaatleja (sõne)
- kommentaar (sõne)
- datetime (kuupäev ja kellaaeg)

Kinnitamisel pakutakse kolme valikut:

\[ \] Kirjutan üle \[x\] Add new layer \[ \] Cancel

Selle etapi läbimisel on vaatluste kogumiseks mõeldud aluskaardid
loodud. :tada:

## Sisestusvormide loomine

Selles etapis loome kogumiseks mõeldud kaardifailidele sisestusvormid.

Enne jätkamist tuleb kihtide nimetused lihtustada, et neid oleks
valemites võimalik kasutada. Selleks vt `Kihi omadused` \> `Allikas` \>
`Kihi nimi`. Kasutame kihi nimetusi ilma GeoPackage faili nimeta
(“punktid”, “punkt” ja “vaatlus”).

#### Peibutuspunktid (loendus.gpkg - punkt)

Ava kihi omadused (*Layer properties*) 2xLMB[^2] ning vali avanenud akna
vasakult menüüst *Attributes form*. Anna igale väljale järgnevad
omadused.

> :warning: Iga välja vormi seadistemise järel tuleb vajutada *Apply*.

**fid**

- Vidina tüüp: Varjatud

**skeem**

- Üldine
  - Alias: “Skeem”
  - [x]  Reuse last entered value
- Vidina tüüp: Väärtuskaart

| Väärtus | Kirjeldus       |
|:--------|:----------------|
| r       | rähniseire      |
| k       | kakuliste seire |
| n       | nurmkana seire  |

**punkti_nr**

- Üldine
  - Alias: “Punkti nr”
- Vidina tüüp: Ulatus
  - Miinimum: 0
  - Maksimum: 999
- Vaikeväärtus
  - Vaikeväärtused:
    `array_first(overlay_nearest('punktid', "punkti_nr"))`

**vaatleja**

- Üldine
  - Alias: “Vaatleja”
  - [x]  Reuse last entered value
- Vidina tüüp: Väärtuskaart
  - lae väärtused CSV failist [seiretiim.csv](/seiretiim.csv)

**kommentaar**

- Üldine
  - Alias: “Kommentaarid”
- Vidina tüüp: Tekstiväli

**datetime**

- Üldine
  - Alias: “Ajatempel”
  - [ ]  Redigeeritav
- Vidina tüüp: Kuupäev/aeg
  - Display format: Kohandatud: yyyy-MM-dd HH:mm
- Vaikeväärtus
  - Vaikeväärtused: `now()`

#### Vaatlused (loendus.gpkg - vaatlus)

Ava kihi omaduste dialoog (2xLMB kihi nimel) ning liigu jaotisele
*Attributes form*. Anna igale väljale järgnevad omadused.

**skeem**

- Üldine
  - Alias: “Skeem”
  - [x]  Reuse last entered value
- Vidina tüüp: Väärtuskaart

| Väärtus | Kirjeldus       |
|:--------|:----------------|
| r       | rähniseire      |
| k       | kakuliste seire |
| n       | nurmkana seire  |

**punkti_nr**

- Üldine
  - Alias: “Punkti nr”
- Vidina tüüp: Ulatus
  - Miinimum: 0
  - Maksimum: 999
- Vaikeväärtus
  - Vaikeväärtused:
    `array_first(overlay_nearest('punkt', "punkti_nr"))` - väljastab
    vaatlusele lähima punkti numbri
  - Vaikeväärtused:
    `array_first(overlay_nearest('punkt', "punkti_nr", max_distance:= 100))` -
    väljastab vaatluse lähima punkti numbri, juhul kui see jääb 100
    meetri raadiusse
  - Vaikeväärtused:
    `array_last(aggregate('punkt','array_agg',"punkti_nr"))` - väljastab
    viimati registreeritud punkti

> :warning: Lähima punkti numbri leidmisel tuleb silmas pidada, et kui
> vaatlus on lähemal kui mõni teine punkt, siis omistatakse vaatlusele
> selle punkti number. Kuna eesmärk on leida punkti number, kust
> teoastati vaatlus, siis on korrektne kasutada viimati sisestatud
> punkti kirjet.

**liik**

- Üldine
  - Alias: “Liik, 3+3 kood”
- Vidina tüüp: Tekstiväli
- Vidina tüüp: Väärtuskaart
- Piirangud: Mitte null

Seda välja võib kohendada vastavalt projekti eripäradele. Eesti lindude
nimestiku 3+3 koodi ja Eesti keelse nimega leiab failist
[linnud_lyh_ek_syst.csv](/linnud_lyh_ek_syst.csv). Eesti lindude
nimestiku 3+3 koodi ja teadusliku nimega leiab failist
[linnud_lyh_lk_syst.csv](/linnud_lyh_lk_syst.csv). Mõistlik on kasutada
versiooni, kus välja kirjelduses on nii 3+3 kood ja eestikeelne nimi:
[linnud_lyh-ek_syst.csv](/linnud_lyh-ek_syst.csv).

> :warning: \[x\] **Mitte null** piirangu puhul antakse hoiatus juhul
> kui väli on täitmata. \[x\] **Jõusta not null piirang** puhul ei lase
> QField nähtust salvestada juhul kui väli on täitmata.

**arv**

- Üldine
  - Alias: “Arv”
- Vidina tüüp: Ulatus
  - Miinimum: 0
  - Maksimum: 9999

**sugu**

- Üldine
  - Alias: “Sugu”
- Vidina tüüp: Väärtuskaart

| Väärtus | Kirjeldus |
|:--------|:----------|
| F       | Emane     |
| M       | Isane     |

**tegevus**

- Üldine
  - Alias: “Tegevus”
- Vidina tüüp: Väärtuskaart
  - lae väärtused CSV failist [tkood.csv](/tkood.csv)
- Vaikeväärtus
  - Vaikeväärtused: ‘s’

**pkood**

- Üldine
  - Alias: “Pesitsuskindlus”
- Vidina tüüp: Väärtuskaart
  - lae väärtused CSV failist [pkkood.csv](/pkkood.csv)
- Vaikeväärtus
  - Vaikeväärtused: ‘l’

**paare**

- Üldine
  - Alias: “Paaride arv”
- Vidina tüüp: Ulatus
  - Miinimum: 0
  - Maksimum: 9999
- Vaikeväärtus
  - Vaikeväärtused: 1

**vaatleja**

- Üldine
  - Alias: “Vaatleja”
  - [x]  Reuse last entered value
- Vidina tüüp: Väärtuskaart
  - lae väärtused CSV failist [seiretiim.csv](/seiretiim.csv)

**kommentaar**

- Üldine
  - Alias: “Kommentaarid”
- Vidina tüüp: Tekstiväli

**datetime**

- Üldine
  - Alias: “Ajatempel”
  - [ ]  Redigeeritav
- Vidina tüüp: Kuupäev/aeg
  - Display format: Kohandatud: “yyyy-MM-dd HH:mm”
- Vaikeväärtus
  - Vaikeväärtused: `now()`

Selle etapiga on sisestusvormid loodud. Ära unusta oma tööd salvestada.

:tada:

## Eksport

Enne jätkamist installeeri QField Sync plugin.

`Pluginad` \> `Halda ja installi ...`

Enne eksportimist tuleb seadistada andmekihtide toimingud, QField
rakendusega sünkroniseerimisel. Selleks ava kihi omadused. Vasakust
menüüst mine jaotise QField peale. Sakil `QFieldCloud` tuleb kihtide
toimingud seadistada juhul, kui eksport toimub pilve. Sakil
`Cable Export` tuleb kihtide toimingud seadistada juhul kui eksport
toimub seadmesse.

Ekspordiks on kaks võimalust: pilve (QFIeldCloud) või seadmesse (Paki
QField’i jaoks).

:tada:

[^1]: **R**ight **M**ouse **B**utton ehk hiire parema nupu vajutus

[^2]: **L**eft **M**ouse **B**utton ehk hiire vasaku nupu vajutus.
