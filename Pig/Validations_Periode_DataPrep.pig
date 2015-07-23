-- Define parameters
%default agg_validations_data_file_path '/user/hypercube/keolis_data/Lyon/agg_validations.csv'
%default liste_periode_data_file_path '/user/hypercube/keolis_data/Lyon/liste_periodes-2.csv'

%default delimiter ';'

set default_parallel 50;

-- Register Keolis UDFs
REGISTER 'keolis_pig_udfs.py' USING streaming_python AS keolisUDFs;

-- Load 'validations' data
agg_validations_data = LOAD '$agg_validations_data_file_path' USING PigStorage('$delimiter') AS (
    AGG_VALIDATIONS_DIVERS_DATE_VALIDATION: chararray,
    AGG_VALIDATIONS_DIVERS_PERIODE: chararray,
    AGG_VALIDATIONS_DIVERS_LIG_CODE: chararray,
    AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE: chararray,
    LISTE_ARRETS_NOM_LIE: chararray,
    LISTE_ARRETS_COO_X: double,
    LISTE_ARRETS_COO_Y: double,
    LISTE_ARRETS_COO_Z: double,
    AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT: chararray,
    AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS: int);


agg_validations_data_2 = FOREACH agg_validations_data {
     periode_tuple = STRSPLIT($1, ' - ');
     date_deb = ToDate(CONCAT(CONCAT($0, ' '), periode_tuple.$0), 'dd/mm/yyyy HH:mm');
     date_fin = ToDate(CONCAT(CONCAT($0, ' '), periode_tuple.$1), 'dd/mm/yyyy HH:mm');
     GENERATE date_deb, (long)ToUnixTime(date_deb), date_fin , (long)ToUnixTime(date_fin), AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE, AGG_VALIDATIONS_DIVERS_DATE_VALIDATION, AGG_VALIDATIONS_DIVERS_PERIODE, AGG_VALIDATIONS_DIVERS_LIG_CODE, LISTE_ARRETS_NOM_LIE, AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT, AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS ;
        };

-- Load calender data
liste_periode_data_2 = FOREACH liste_periode_data {
     date = (long)ToUnixTime(ToDate($0, 'dd/mm/yyyy'));
     periode_tuple = STRSPLIT($1, ' - ');
     date_deb = ToDate(CONCAT(CONCAT($0, ' '), periode_tuple.$0), 'dd/mm/yyyy HH:mm');
     date_fin = ToDate(CONCAT(CONCAT($0, ' '), periode_tuple.$1), 'dd/mm/yyyy HH:mm');
     --JOUR VAC Scolaire
     deb_vac1 = (long)ToUnixTime(ToDate('21/12/2013', 'dd/mm/yyyy'));
     fin_vac1 = (long)ToUnixTime(ToDate('06/01/2014', 'dd/mm/yyyy'));
     deb_vac2 = (long)ToUnixTime(ToDate('01/03/2014', 'dd/mm/yyyy'));
     fin_vac2 = (long)ToUnixTime(ToDate('17/03/2014', 'dd/mm/yyyy'));
     deb_vac3 = (long)ToUnixTime(ToDate('26/04/2014', 'dd/mm/yyyy'));
     fin_vac3 = (long)ToUnixTime(ToDate('12/05/2014', 'dd/mm/yyyy'));
     deb_vac4 = (long)ToUnixTime(ToDate('03/07/2014', 'dd/mm/yyyy'));
     fin_vac4 = (long)ToUnixTime(ToDate('02/09/2014', 'dd/mm/yyyy'));
     deb_vac5 = (long)ToUnixTime(ToDate('18/10/2014', 'dd/mm/yyyy'));
     fin_vac5 = (long)ToUnixTime(ToDate('03/11/2014', 'dd/mm/yyyy'));
     deb_vac6 = (long)ToUnixTime(ToDate('20/12/2014', 'dd/mm/yyyy'));
     fin_vac6 = (long)ToUnixTime(ToDate('05/01/2015', 'dd/mm/yyyy'));
     --JOUR DE GREVE
     jG1 = (long)ToUnixTime(ToDate('14/02/2014', 'dd/mm/yyyy'));
     jG2 = (long)ToUnixTime(ToDate('12/05/2014', 'dd/mm/yyyy'));
     jG3 = (long)ToUnixTime(ToDate('26/05/2014', 'dd/mm/yyyy'));
     jG4 = (long)ToUnixTime(ToDate('21/06/2014', 'dd/mm/yyyy'));
     jG5 = (long)ToUnixTime(ToDate('19/09/2014', 'dd/mm/yyyy'));
     --JOUR FERIE
     jF1 = (long)ToUnixTime(ToDate('25/12/2013', 'dd/mm/yyyy'));
     jF2 = (long)ToUnixTime(ToDate('01/01/2014', 'dd/mm/yyyy'));
     jF3 = (long)ToUnixTime(ToDate('21/04/2014', 'dd/mm/yyyy'));
     jF4 = (long)ToUnixTime(ToDate('01/05/2014', 'dd/mm/yyyy'));
     jF5 = (long)ToUnixTime(ToDate('08/05/2014', 'dd/mm/yyyy'));
     jF6 = (long)ToUnixTime(ToDate('29/05/2014', 'dd/mm/yyyy'));
     jF7 = (long)ToUnixTime(ToDate('09/06/2014', 'dd/mm/yyyy'));
     jF8 = (long)ToUnixTime(ToDate('14/07/2014', 'dd/mm/yyyy'));
     jF9 = (long)ToUnixTime(ToDate('15/08/2014', 'dd/mm/yyyy'));
     jF10 = (long)ToUnixTime(ToDate('01/11/2014', 'dd/mm/yyyy'));
     jF11 = (long)ToUnixTime(ToDate('11/11/2014', 'dd/mm/yyyy'));
     jF12 = (long)ToUnixTime(ToDate('25/12/2014', 'dd/mm/yyyy'));
     --GENERATE cols
     GENERATE date_deb , (long)ToUnixTime(date_deb), date_fin, (long)ToUnixTime(date_fin), $0.. , ((((date >= ToUnixTime(ToDate('21/12/2013', 'dd/mm/yyyy'))) AND (date <= ToUnixTime(ToDate('06/01/2013', 'dd/mm/yyyy'))))
     OR ((date >= ToUnixTime(ToDate('01/03/2014', 'dd/mm/yyyy'))) AND (date <= ToUnixTime(ToDate('17/03/2014', 'dd/mm/yyyy'))))
     OR ((date >= ToUnixTime(ToDate('26/04/2014', 'dd/mm/yyyy'))) AND (date <= ToUnixTime(ToDate('12/05/2014', 'dd/mm/yyyy'))))
     OR ((date >= ToUnixTime(ToDate('03/07/2014', 'dd/mm/yyyy'))) AND (date <= ToUnixTime(ToDate('02/09/2014', 'dd/mm/yyyy'))))
     OR ((date >=  ToUnixTime(ToDate('18/10/2014', 'dd/mm/yyyy'))) AND (date <= ToUnixTime(ToDate('03/11/2014', 'dd/mm/yyyy'))))
     OR ((date >= ToUnixTime(ToDate('20/12/2014', 'dd/mm/yyyy'))) AND (date <= ToUnixTime(ToDate('05/01/2015', 'dd/mm/yyyy')))))? 1 : 0) AS JVScolaire,
     (((date == jF1) OR (date == jF2) OR (date == jF3) OR (date == jF4) OR (date == jF5) OR (date == jF6) OR (date == jF7) OR (date == jF8) OR (date == jF9) OR (date == jF10) OR (date == jF11) OR (date ==jF12))?1:0) AS JFerie,
     (((date == jG1) OR (date == jG2) OR (date == jG3) OR (date == jG4) OR (date == jG5))?1:0) AS JGreve;
     };


agg_validations_periode_data = JOIN agg_validations_data_2 BY (AGG_VALIDATIONS_DIVERS_DATE_VALIDATION) LEFT, liste_periode_data_2 BY (DATE) PARALLEL 10;

describe agg_validations_periode_data;


--STORE agg_validations_periode_data INTO 'agg_validations_periode_data.CSV' USING PigStorage('$delimiter');

--STORE agg_validations_periode_data INTO 'agg_validations_periode_data.CSV' USING PigStorage('$delimiter');

-- Group ID definition
-- ID format: ARRET_{JOUR N/V}_{LIBELLE JOUR (3 1ere lettres)}_TRANCHE_HORAIRE_LIGNE

agg_validations_periode_data_with_ID = FOREACH agg_validations_periode_data {
    ARRET = agg_validations_data_2::AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE;
    J_NV = keolisUDFs.type_jour(liste_periode_data_2::JVScolaire, liste_periode_data_2::JFerie);
    libelle_jour = SUBSTRING(liste_periode_data_2::LIBELLE_JOUR, 0, 3);
    TRANCHE =  keolisUDFs.periode_alias(agg_validations_data_2::AGG_VALIDATIONS_DIVERS_PERIODE);
    GENERATE CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(ARRET, '_'), J_NV), '_'), libelle_jour), '_'), TRANCHE) AS VALIDATION_GP, $0..;
        };

-- Mean & stdev computation within groups
validation_groups = GROUP agg_validations_periode_data_with_ID BY VALIDATION_GP;

validations_indice_field_helper_data = FOREACH validation_groups {
    -- standard dev
    gp = FOREACH agg_validations_periode_data_with_ID.AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS GENERATE $0;
    size = COUNT(gp);
    mean = AVG(gp);
    std = keolisUDFs.stdev(agg_validations_periode_data_with_ID.AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS);
    GENERATE FLATTEN(group) AS VALIDATION_GP, SUM(agg_validations_periode_data_with_ID.AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS) AS SOM_VALIDATIONS, AVG(agg_validations_periode_data_with_ID.AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS) AS MOY_VALIDATIONS, COUNT(agg_validations_periode_data_with_ID.AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS) AS SIZE_GP,
    std AS StDEV, (std != 0 AND size != 0? mean - 1.96*std/SQRT(size) : 0) AS CI95_MOY_LOWERB, (std != 0 AND size != 0? mean + 1.96*std/SQRT(size) : 0)  AS CI95_MOY_UPPERB;
};

-- Joining validations data to groups

validation_data_with_indice_helpers = JOIN agg_validations_periode_data_with_ID BY VALIDATION_GP LEFT, validations_indice_field_helper_data BY VALIDATION_GP USING 'replicated';

validation_data_with_indice = FOREACH validation_data_with_indice_helpers GENERATE $0.., (MOY_VALIDATIONS != 0? (AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS*100)/MOY_VALIDATIONS : 0) AS INDICE_1,
(StDEV != 0 ? (AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS - MOY_VALIDATIONS)/StDEV :0) AS INDICE_2;


--DESCRIBE validation_data_with_indice;

STORE validation_data_with_indice INTO 'Validations_INDICE_1_2.CSV' USING PigStorage('$delimiter');


