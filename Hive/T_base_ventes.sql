select 
 db_ventes.date_heure_facture
,db_ventes.DATE_
,db_ventes.periode
,db_ventes.ligne
,db_ventes.arret as arret
,ref_arret.num_arret as num_arret
,db_ventes.id_utilisateur_vendeur
,db_ventes.total_montant_detail
,db_ventes.total_montant_global
,db_ventes.nb_ventes
,db_ventes.nb_trajets
,db_ventes.jour
,db_ventes.jferie
,db_ventes.jvscolaires
from (
select distinct
 ventes.date_heure_facture
,ventes.DATE_
,ventes.periode
,ventes.ligne
,ventes.arret as arret
,ventes.id_utilisateur_vendeur
,ventes.total_montant_detail
,ventes.total_montant_global
,ventes.nb_ventes
,ventes.nb_trajets
,cal.jour
,cal.jferie
,cal.jvscolaires
,(cal.jour=="Samedi" or cal.jour=="Dimanche") or cal.jferie==1 or cal.jvscolaires==1 AS jour_de_repos
FROM ( 
   select
   date_heure_facture
  ,CONCAT(SPLIT(date_heure_facture, "-")[0],CONCAT("/",CONCAT(SPLIT(date_heure_facture, "-")[1], CONCAT("/", SPLIT(date_heure_facture, "-")[2])))) AS DATE_
  ,periode
  ,ligne
  ,arret
  ,id_utilisateur_vendeur
  ,SUM(quantite) AS nb_ventes
  ,SUM(montant_detail) AS total_montant_detail
  ,SUM(montant_global) AS total_montant_global
  ,COUNT(distinct CODE_SESSION) AS nb_trajets
   from `keolis.tours_base_ventes`
   where split(date_heure_facture, '/')[2]="2014" 
   group by `date_heure_facture`, `ligne`, `periode`, `arret`,`id_utilisateur_vendeur`) ventes
LEFT JOIN `keolis.calendrier_tours` cal
ON ventes.DATE_ = cal.date ) db_ventes 
LEFT JOIN `keolis.ref_arret` ref_arret
ON ref_arret.arret = db_ventes.arret;