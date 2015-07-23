-- Registering ES
REGISTER elasticsearch-hadoop-2.1.0.Beta2.jar;
DEFINE EsStorage org.elasticsearch.hadoop.pig.EsStorage();

-- Define parameters
%default agg_validations_data_file_path '/user/hypercube/keolis_data/Lyon/agg_validations_indexes_sorted-2.csv'
%default liste_arrets_file_path '/user/hypercube/keolis_data/Lyon/liste_arrets_WGS84-2.csv'

%default delimiter ';'

set default_parallel 50;

-- Load 'validations' data
agg_validations_data = LOAD '$agg_validations_data_file_path' USING PigStorage('$delimiter') AS (
    ID1: chararray,
    ID2: chararray,
    GROUPS: chararray,
    AGG_VALIDATIONS_DIVERS_DATE_VALIDATION: chararray,
    AGG_VALIDATIONS_DIVERS_PERIODE: chararray,
    AGG_VALIDATIONS_DIVERS_LIG_CODE: chararray,
    AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE: chararray,
    LISTE_ARRETS_NOM_LIE: chararray,
    LISTE_ARRETS_COO_X: chararray,
    LISTE_ARRETS_COO_Y: chararray,
    LISTE_ARRETS_COO_Z: chararray,
    AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT: chararray,
    AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS: int,
    ANNEE: chararray,
    LIBELLE_MOIS: chararray,
    LIBELLE_JOUR: chararray,
    JOUR_FERIE: chararray,
    JOUR_OUVRE: chararray,
    JVScolaire: chararray,
    JFerie: chararray,
    JGreve: chararray,
    SUMM: double,
    MEAN: double,
    StDev: double,
    INDICES_1: double,
    INDICES_2: double,
    DATETIME: chararray,
    MOVING_SUM: double,
    MOVING_AVG: double);

-- Date convertion
agg_validations_data_2 = FOREACH agg_validations_data {
     periode_tuple = STRSPLIT(AGG_VALIDATIONS_DIVERS_PERIODE, ' - ');
     date_deb = ToDate(CONCAT(CONCAT(AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, ' '), periode_tuple.$0), 'dd/mm/yyyy HH:mm');
     date_fin = ToDate(CONCAT(CONCAT(AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, ' '), periode_tuple.$1), 'dd/mm/yyyy HH:mm');
     GENERATE date_deb AS DATE_DEB, (long)ToUnixTime(date_deb) AS DATE_DEB_TSTAMP, date_fin AS DATE_FIN , (long)ToUnixTime(date_fin) AS DATE_FIN_TSTAMP,
     GROUPS, AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, AGG_VALIDATIONS_DIVERS_PERIODE, AGG_VALIDATIONS_DIVERS_LIG_CODE, AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE, LISTE_ARRETS_NOM_LIE, LISTE_ARRETS_COO_X, LISTE_ARRETS_COO_Y, LISTE_ARRETS_COO_Z, AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT, AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS, ANNEE, LIBELLE_MOIS, LIBELLE_JOUR, JOUR_FERIE, JOUR_OUVRE, JVScolaire, JFerie, JGreve, SUMM, MEAN, StDev, INDICES_1, INDICES_2, MOVING_SUM, MOVING_AVG;
     };

-- Loading stops
liste_arrets_data = LOAD '$liste_arrets_file_path' USING PigStorage('$delimiter') AS (
    idt_pnt: chararray,
    idt_lie: chararray,
    nom_lie: chararray,
    id_sit: chararray,
    lib_sit: chararray,
    cod_fam_trp: chararray,
    pmr: chararray,
    coo_x_wgs84: double,
    coo_y_wgs84: double);
    
    
agg_validations_arrets = JOIN agg_validations_data_2 BY (LISTE_ARRETS_NOM_LIE, AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT) LEFT, liste_arrets_data BY (nom_lie, cod_fam_trp) PARALLEL 1;


agg_validations_arrets_geopoints = FOREACH agg_validations_arrets{
	geopoint_1 = TOTUPLE(liste_arrets_data::coo_x_wgs84, liste_arrets_data::coo_y_wgs84);
    geopoint_2 = TOTUPLE(liste_arrets_data::coo_y_wgs84, liste_arrets_data::coo_x_wgs84);
    GENERATE $0.., geopoint_1 AS GEOPOINT_1, geopoint_2 AS GEOPOINT_2;
	};
    
--STORE agg_validations_arrets_geopoints INTO 'agg_validations_arrets_geopoints.CSV' USING PigStorage('$delimiter');

STORE agg_validations_arrets_geopoints INTO 'keolis/validations_geopoints_Lyon' USING EsStorage();

-- Storing to ES
--STORE agg_validations_data_2 INTO 'keolis/validations_Lyon' USING EsStorage('es.mapping.names=DATE_DEB:@timestamp');