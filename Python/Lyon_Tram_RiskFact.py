import pandas as pd
import numpy as np

data_header = ["date", "periode", "ligne", "arret", "nombre_de_validations", "nombre_d_entres", "diffrence_entres_validations", "indice_de_validation", "taux_de_non_validation", "contrles_en_cours", "contrle", "nombre_de_personnes_contrles", "nombre_de_titres_incorrects", "nombre_total_de_pv", "nombre_perturbations", "moy_nb_suites_infra", "nombre_infractions", "nombre_alertes", "nb_passages", "retard_entree_moy", "retard_entree_max", "retard_entree_min", "retard_entree_sup_5mn_nb", "retard_entree_2mn_5mn_nb", "avance_entree_sup_5mn_nb", "avance_entree_2mn_5mn_nb", "duree_ouverture_portes_moy", "duree_ouverture_portes_std", "annee", "libelle_mois", "libelle_jour", "jour_ferie", "jour_ouvre", "jvscolaire", "jferie", "jgreve"]

df_tram = pd.read_csv("Lyon_Tram_AnalyseFacteursRisque.hsv", header=None, names=data_header, sep='\x01', na_values="\N",low_memory=False)

df_tram_2 = pd.read_csv("Lyon_Tram_AnalyseFacteursRisque_2.hsv", header=None, names=data_header, sep='\x01', na_values="\N", low_memory=False)

df_tram_final = pd.concat([df_tram, df_tram_2])

df_tram_final_2 = df_tram_final.fillna(value=0)

jour = df_tram_final_2['date'].map(lambda s: int(s.split('/')[0]))

df_tram_final_2['deux_prem_jour_mois'] = np.where(np.logical_or(jour==1, jour==2), "Oui", "Non")

df_cal_meteo = pd.read_csv("Lyon_calendrier_meteo_.csv", sep=',')

df_cal_meteo.columns = [u'aID_periode', u'ID_date_periode', u'date', u'periode', u'Date et heure', u'Annee', u'Semestre', u'Trimestre', u'Mois_num', u'Mois', u'Jour_num', u'Jour', u'Jour ouvre', u'jour ferie', u'Vacances scolaires', u'Vacances ou jour ferie', u'Deux premiers jours du mois', u'Jour de greve', u'vitesse_du_vent', u'vent', u'temperatureC', u'temperature_ressentie', u'conditions_de_temperature', u'conditions_meteo', u'visites_fixe', u'navigateurs_fixe', u'visites_mobiles', u'navigateurs_mobiles']

df_cal_meteo_2 = df_cal_meteo[[u'date', u'periode', u'Date et heure', u'Annee', u'Semestre', u'Trimestre', u'Mois_num', u'Mois', u'Jour_num', u'Jour', u'Jour ouvre', u'jour ferie', u'Vacances scolaires', u'Vacances ou jour ferie', u'Deux premiers jours du mois', u'Jour de greve', u'vitesse_du_vent', u'vent', u'temperatureC', u'temperature_ressentie', u'conditions_de_temperature', u'conditions_meteo', u'visites_fixe', u'navigateurs_fixe', u'visites_mobiles', u'navigateurs_mobiles']]
df_tram_final_3 = pd.merge(df_tram_final_2, df_cal_meteo_2, on=['date', 'periode'], how="left")

cproblem = pd.read_csv('Cproblemes.csv', sep=';')

cproblem_2 = cproblem[['periode', 'ligne', 'Nombre_Perturbations', 'MOY_NB_SUITES_INFRA', 'Nombre_Infractions', 'Libelle', 'Nombre_alertes']]

new_date = cproblem['ID_date_periode_ligne'].map(lambda s: str(s.split('_')[0]))
cproblem_2['date'] = new_date

df_tram_final_5 = pd.merge(df_tram_final_3, cproblem_2, how="left")

df_tram_final_5.fillna(value=0)

df_tram_final_5.to_csv("Lyon_TRAM_RiskFactorsAnalysis_fillna_3.csv", sep=';', index=False)


