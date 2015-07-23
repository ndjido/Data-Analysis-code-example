SELECT val.agg_validations_divers_date_validation	
,val.agg_validations_divers_periode		
,val.agg_validations_divers_lig_code		
,val.agg_validations_divers_val_arret_code AS code_arret		
,val.agg_validations_divers_type_transport
,val.agg_validations_divers_nb_validations
,val.mean AS mean_val_gp
,val.group AS group_val
,val.indices_1 AS indice_val_s_mean
,val.libelle_jour AS libelle_jour
,val.libelle_mois AS libelle_mois
,val.jvscolaire AS jvscolaire
,val.jour_ouvre AS jour_ouvre
,TIMESTAMP(CONCAT(SPLIT(datetime, ' ')[0], ' ', split(agg_validations_divers_periode, ' - ')[0], ':00')) AS date_tranche_horaire
, UNIX_TIMESTAMP(CONCAT(val.agg_validations_divers_date_validation, ' ', SPLIT(val.agg_validations_divers_periode, ' - ')[0]), "dd/MM/yyyy HH:mm") AS unix_tstamp
FROM `keolis.agg_validations_indices` val
WHERE SPLIT(agg_validations_divers_date_validation, '/')[2]="2014" AND val.agg_validations_divers_type_transport="BUS"
ORDER BY code_arret, date_tranche_horaire ASC;