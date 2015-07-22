import pandas as pd
import numpy as np
from datetime import datetime

'''
--validations
'''
val_header = ['date', 'periode', 'Ligne', 'arret', 'date_TH', 'ID_date_periode_ligne_arret', 'Nombre_de_validations', 'Nombre_entrees', 'Difference_entrees_validations', 'Indice_de_validation', 'Taux_de_non-validation', 'Controles_en_cours', 'Controle', 'Nombre_de_controles', 'Nombre_de_titres_incorrects', 'Nombre_total_de_PV', 'Montant_collecte', 'Nombre_de_paiment_immediats', 'Nombre_de_paiments_differes']
df_validations_lyon = pd.read_csv("Lyon_Validations_comptages_controles_PV.csv", header=None, names=val_header, skiprows=1)

df_validations_lyon = df_validations_lyon[df_validations_lyon.columns[:-3]]

'''
--calender + meteo
'''
cal_header = ['aID_periode', 'ID_date_periode', 'Date', 'Periode', 'Date_et_heure', 'Annee', 'Semestre', 'Trimestre', 'Mois_num', 'Mois', 'Jour_num', 'Jour', 'Jour_ouvre', 'jour_ferie', 'Vacances_scolaires', 'Vacances_ou_jour_ferie', 'Deux_premiers_jours_du_mois', 'Jour_de_greve', 'Vitesse_du_vent', 'Vent', 'TemperatureC', 'Temperature_ressentie', 'Conditions_de_temperature', 'Conditions_meteo', 'Visites_(fixe)', 'Navigateurs_(fixe)', 'Visites_(mobiles)', 'Navigateurs_(mobiles)']
df_calendar_meteo_lyon = pd.read_csv("Lyon_Calendrier_meteo.csv", header=None, names=cal_header, skiprows=1)

df_calendar_meteo_lyon = df_calendar_meteo_lyon[[u'Date', u'Periode', u'Semestre', u'Trimestre', u'Mois', u'Jour', u'Jour_ouvre', u'jour_ferie', u'Vacances_scolaires', u'Vacances_ou_jour_ferie', u'Deux_premiers_jours_du_mois', u'Jour_de_greve']]

df_calendar_meteo_lyon.rename(columns={'Date':'date', 'Periode':'periode'}, inplace=True)

df_calendar_meteo_lyon.drop_duplicates(inplace=True)


'''
-- validations + calender + meteo
'''

df_validations_lyon_cal_meteo = pd.merge(df_validations_lyon, df_calendar_meteo_lyon, how="left", on=['date', 'periode'])

df_validations_lyon_cal_meteo["taux_de_controle"] = df_validations_lyon_cal_meteo.Nombre_de_controles/df_validations_lyon_cal_meteo.Nombre_entrees

df_validations_lyon_cal_meteo["taux_de_fraude_mesure"] = df_validations_lyon_cal_meteo.Nombre_de_titres_incorrects/df_validations_lyon_cal_meteo.Nombre_de_controles

df_validations_lyon_cal_meteo.to_csv("Lyon_TauxFraude_TauxMesure.csv", sep=';', index=False)

df_validations_lyon_cal_meteo = df_validations_lyon_cal_meteo[df_validations_lyon_cal_meteo.Nombre_de_controles <= df_validations_lyon_cal_meteo.Nombre_entrees]


df_validation.to_csv("Lyon_TauxFraudeMesure_TauxControle.csv", sep=';', index=False)
