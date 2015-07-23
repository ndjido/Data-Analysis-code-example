SELECT
 agg_validations_divers_val_arret_code AS CODE_ARRET
,SUM(agg_validations_divers_nb_validations) AS NB_VALIDATIONS
, AVG(agg_validations_divers_nb_validations) AS AVG_NB_VALIDATIONS
, STDDEV_SAMP(agg_validations_divers_nb_validations) AS STD_NB_VALIDATIONS
, COUNT(agg_validations_divers_nb_validations) AS SIZE_GP
, MIN(agg_validations_divers_nb_validations) AS MIN_GP
, MAX(agg_validations_divers_nb_validations) AS MAX_GP
, PERCENTILE(agg_validations_divers_nb_validations, 0.5) AS MEDIANE
, PERCENTILE(agg_validations_divers_nb_validations, 0.25) AS Q1
, PERCENTILE(agg_validations_divers_nb_validations, 0.75) AS Q3
FROM `keolis.agg_validations_indices` 
GROUP BY agg_validations_divers_val_arret_code;
