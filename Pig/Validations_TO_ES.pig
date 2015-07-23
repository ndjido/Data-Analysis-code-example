-- Registering ES
REGISTER elasticsearch-hadoop-2.1.0.Beta2.jar;
DEFINE EsStorage org.elasticsearch.hadoop.pig.EsStorage();

-- Define parameters
%default agg_validations_data_file_path '/user/hypercube/keolis_data/Lyon/agg_validations_indexes_sorted-2.csv'
%default delimiter ';'

set default_parallel 200;

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
     date_deb = ToDate(CONCAT(CONCAT(AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, ' '), periode_tuple.$0), 'dd/MM/yyyy HH:mm');
     date_fin = ToDate(CONCAT(CONCAT(AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, ' '), periode_tuple.$1), 'dd/MM/yyyy HH:mm');
     GENERATE date_deb AS DATE_DEB, (long)ToUnixTime(date_deb) AS DATE_DEB_TSTAMP, date_fin AS DATE_FIN , (long)ToUnixTime(date_fin) AS DATE_FIN_TSTAMP,
     GROUPS, AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, AGG_VALIDATIONS_DIVERS_PERIODE, AGG_VALIDATIONS_DIVERS_LIG_CODE, AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE, LISTE_ARRETS_NOM_LIE, LISTE_ARRETS_COO_X, LISTE_ARRETS_COO_Y, LISTE_ARRETS_COO_Z, AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT, AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS, ANNEE, LIBELLE_MOIS, LIBELLE_JOUR, JOUR_FERIE, JOUR_OUVRE, JVScolaire, JFerie, JGreve, SUMM, MEAN, StDev, INDICES_1, INDICES_2;
     };

-- Storing to ES
STORE agg_validations_data_2 INTO 'keolis/validations_Lyon_2' USING EsStorage('es.mapping.names=DATE_DEB:@timestamp');
