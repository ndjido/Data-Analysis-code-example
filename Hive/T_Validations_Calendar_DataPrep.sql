SELECT 
val.date_transaction
,val.periode
,val.num_ligne
,val.num_arret
,val.libelle_arret
,val.coord_x_gps_arret
,val.coord_y_gps_arret
,val.nb_validation
,val.nb_correspondance
,UNIX_TIMESTAMP(CONCAT(val.date_transaction, ' ', SPLIT(val.periode, ' - ')[0]), "dd/MM/yyyy HH:mm") AS unix_tstamp
,per.libelle_jour AS libelle_jour
,per.libelle_mois AS libelle_mois
,per.jour_ouvre AS jour_ouvre
, (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("19/10/2013", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("04/11/2013", "dd/MM/yyyy"))
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("21/12/2013", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("06/01/2014", "dd/MM/yyyy")) 
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("22/02/2014", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("10/03/2014", "dd/MM/yyyy")) 
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("19/04/2014", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("05/05/2014", "dd/MM/yyyy")) 
  AS jvscolaire
, (per.jour_ouvre = 0) OR ((UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("19/10/2013", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("04/11/2013", "dd/MM/yyyy"))
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("21/12/2013", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("06/01/2014", "dd/MM/yyyy")) 
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("22/02/2014", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("10/03/2014", "dd/MM/yyyy")) 
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("19/04/2014", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("05/05/2014", "dd/MM/yyyy")) 
)  AS Jour_NV
,("13/12/2014" = val.date_transaction) OR ("14/12/2014" = val.date_transaction) OR ("20/12/2014" = val.date_transaction) OR ("21/12/2014" = val.date_transaction) OR ("27/12/2014" = val.date_transaction) OR 
("28/12/2014" = val.date_transaction) OR ("24/12/2014" = val.date_transaction) OR ("25/12/2014" = val.date_transaction) OR ("31/12/2014" = val.date_transaction) OR ("13/12/2014" = val.date_transaction) OR ("13/12/2014" = val.date_transaction) OR 
("21/06/2014" = val.date_transaction) AS jgreve
, CONCAT(val.num_arret, '_', (per.jour_ouvre = 0) OR ((UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("19/10/2013", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("04/11/2013", "dd/MM/yyyy"))
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("21/12/2013", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("06/01/2014", "dd/MM/yyyy")) 
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("22/02/2014", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("10/03/2014", "dd/MM/yyyy")) 
 OR (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("19/04/2014", "dd/MM/yyyy")) AND (UNIX_TIMESTAMP(val.date_transaction, "dd/MM/yyyy") >= UNIX_TIMESTAMP("05/05/2014", "dd/MM/yyyy")) 
), '_', SUBSTR(per.libelle_jour, 1, 3) , '_', val.periode) AS group_norm
FROM `keolis.agg_validations_raw_tours` val
JOIN `keolis.periode` per
ON per.date = val.date_transaction AND per.periode = val.periode
WHERE SPLIT(val.date_transaction, '/')[2]="2014";

