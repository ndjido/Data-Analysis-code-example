


# loading "liste arret data with WGS84 coordinate"
LOAD DATA INPATH 'liste_arrets_WGS84-2.csv' OVERWRITE INTO TABLE `keolis.liste_arrets_wgs84`;


LOAD DATA INPATH 'agg_comptage_tram_noheader.csv' OVERWRITE INTO TABLE `keolis.agg_comptage_tram`;


LOAD DATA INPATH 'agg_validations.csv' OVERWRITE INTO TABLE `keolis.agg_validations_raw_lyon`;


LOAD DATA INPATH 'liste_periodes_noheader.csv' OVERWRITE INTO TABLE `keolis.periode`;


LOAD DATA INPATH 'Weather_Data_Lyon_3_noheader.csv' OVERWRITE INTO TABLE `keolis.weather_lyon`;


LOAD DATA INPATH 'Periodes1h30.csv' OVERWRITE INTO TABLE `keolis.periode1h30`;


LOAD DATA INPATH 'passages_tram_noheader.csv' OVERWRITE INTO TABLE `keolis.passages_tram`;


LOAD DATA INPATH 'periodes_noheader.csv' OVERWRITE INTO TABLE `keolis.periodes_tram`;


LOAD DATA INPATH 'Lyon_Passages_TRAM_Periodes_Group.csv' OVERWRITE INTO TABLE `keolis.lyon_tram_passages_periodes`;


LOAD DATA INPATH 'Lyon_Tram_Validations_controles_pv.csv' OVERWRITE INTO TABLE `keolis.Lyon_Tram_Validations_controles_pv`;


LOAD DATA INPATH 'Cproblemes.csv' OVERWRITE INTO TABLE `keolis.Cproblemes`;





