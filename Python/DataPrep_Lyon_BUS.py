Index([u'aID_p�riode', u'ID_date_periode', u'date', u'P�riode', u'date et heure', u'Ann�e', u'Semestre', u'Trimestre', u'Mois_num', u'Mois', u'Jour_num', u'Jour', u'Jour ouvr�', u'jour f�ri�', u'Vacances scolaires', u'Vacances ou jour f�ri�', u'Deux premiers jours du mois', u'Jour de gr�ve'], dtype='object')

In [28]: df_calender.columns[0]
Out[28]: 'aID_p\xe9riode'


 df_calender.rename(columns={'P\xe9riode':'periode', 'date': 'date', 'Mois':'mois', 'Jour':'jour', 'jour f\xe9ri\xe9':'jour_ferie', 'Vacances scolaires':'vac_scolaire', 'Jour de gr\xe8ve':'jour_de_greve', 'Deux premiers jours du mois' : 'deux_prem_jours_mois' ,'Conditions m\xe9t\xe9o':'meteo'}, inplace=True)

cols = ['date', 'periode', 'mois', 'jour','jour_ferie','vac_scolaire','jour_de_greve','deux_prem_jours_mois']

df_calender = df_calender[['date', 'periode', 'meteo']]


In [28]: df_calender.columns[0]
Out[28]: 'aID_p\xe9riode'

In [29]: df_calender.columns[3]
Out[29]: 'P\xe9riode'

In [30]: df_calender.columns[12]
Out[30]: 'Jour ouvr\xe9'

In [31]: df_calender.columns[13]
Out[31]: 'jour f\xe9ri\xe9'

In [32]: df_calender.columns[14]
Out[32]: 'Vacances scolaires'

In [33]: df_calender.columns[15]
Out[33]: 'Vacances ou jour f\xe9ri\xe9'

In [34]: df_calender.columns[16]
Out[34]: 'Deux premiers jours du mois'

In [35]: df_calender.columns[17]
Out[35]: 'Jour de gr\xe8ve'



Index([u'date', u'ANNEE', u'SEMESTRE', u'LIBELLE_SEMESTRE', u'TRIMESTRE', u'LIBELLE_TRIMESTRE', u'ANNEE_MOIS', u'MOIS', u'LIBELLE_MOIS', u'SEMAINE', u'JOUR', u'LIBELLE_JOUR', u'JOUR_FERIE', u'JOUR_OUVRE'], dtype='object')

df_periode = df_periode[['date', u'ANNEE', u'SEMESTRE', u'TRIMESTRE', u'LIBELLE_MOIS',  u'LIBELLE_JOUR']]

df_periode.rename(columns={'date':'date'}, inplace=True)

df_train$periode + df_train$arret + controle + SEMESTRE + TRIMESTRE + LIBELLE_MOIS + LIBELLE_JOUR + jour_num + JVScolaire + JFerie + JGreve + meteo


DAT_CPT', u'COD_LIG', u'IDT_SIT', u'LIB_SIT', u'COO_X', u'COO_Y', u'NBR_VOY_BRT', u'NBR_VOY_COR', u'NBR_PAS_BRT', u'NBR_PAS_COR', u'NBR_SOR_BRT', u'NBR_SOR_COR', u'NBR_ENT_BRT', u'NBR_ENT_COR

df_comptage['ligne'] = df_comptage.COD_LIG.map(lambda s: s.split('A')[0])
df_comptage.rename(columns={'DAT_CPT': 'date'}, inplace=True)

df_comptage = df_comptage[['date', 'ligne', 'NBR_VOY_BRT', 'NBR_VOY_COR']]

'''
------------------------------------------------------------------------------------------
'''
df_validations = df_validations[['AGG_VALIDATIONS_DIVERS_DATE_VALIDATION', u'AGG_VALIDATIONS_DIVERS_PERIODE', u'AGG_VALIDATIONS_DIVERS_LIG_CODE', u'AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE', u'LISTE_ARRETS_NOM_LIE', u'AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT', u'AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS']]

df_validations_bus = df_validations[df_validations.AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT=='BUS']

df_validations_bus = df_validations[df_validations.AGG_VALIDATIONS_DIVERS_LIG_CODE != 'T1']

df_validations_bus_agg = df_validations_bus.groupby(['AGG_VALIDATIONS_DIVERS_DATE_VALIDATION', 'AGG_VALIDATIONS_DIVERS_LIG_CODE']).sum().reset_index()

df_validations_bus_agg.rename(columns={'AGG_VALIDATIONS_DIVERS_DATE_VALIDATION':'date', 'AGG_VALIDATIONS_DIVERS_LIG_CODE':'ligne'}, inplace=True)

df_comptage = pd.read_csv('../DONNEES_COMPTAGE_CORRIGEES.csv', sep=',')

df_comptage.rename(columns={'DAT_CPT': 'date'}, inplace=True)

df_comptage['ligne'] = df_comptage.COD_LIG.map(lambda s: s.split('A')[0])

df_comptage = df_comptage[['date', 'ligne', 'NBR_VOY_BRT', 'NBR_VOY_COR']]

df_validation_cpt_bus = pd.merge(df_validations_bus_agg, df_comptage, how='left')

df_validation_cpt_bus.rename(columns={'AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS':'nb_validations'}, inplace=True)

df_validation_cpt_bus['taux_de_non_valitation_cor'] = (df_validation_cpt_bus.NBR_VOY_COR - df_validation_cpt_bus.nb_validations)/df_validation_cpt_bus.NBR_VOY_COR

df_validation_cpt_bus['taux_de_non_valitation_brt'] = (df_validation_cpt_bus.NBR_VOY_BRT - df_validation_cpt_bus.nb_validations)/df_validation_cpt_bus.NBR_VOY_BRT


'''
--- Control
'''
df_controles = pd.read_csv('../controles.csv')

df_controles.rename(columns={'Date':'date', 'LIG_CODE':'ligne'}, inplace=True)

df_controles.drop('SSC_ARRET_CODE', 1, inplace=True)

df_controles_agg = df_controles.groupby(['date','ligne']).sum().reset_index()

df_validations_cpt = pd.merge(df_validation_cpt_bus, df_controles_agg, how='left')

df_validations_cpt.drop('AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE', 1, inplace=True)

df_validations_cpt_ctr = pd.merge(df_validations_cpt, df_controles_agg, how='left')

df_validations_cpt_ctr['taux_de_non_validation'] = (df_validations_cpt_ctr.NBR_VOY_COR - df_validations_cpt_ctr.nb_validations)/df_validations_cpt_ctr.NBR_VOY_COR

df_validations_cpt_ctr = df_validations_cpt_ctr[df_validations_cpt_ctr.ligne!='C3']

'''
--- Problemes
'''
df_pb = pd.read_csv('Cproblemes.csv', sep=';')

df_pb['date'] = df_pb.ID_date_periode_ligne.map(lambda s: s.split('_')[0])

df_pb.drop('ID_date_periode_ligne',1, inplace=True)

df_pb.drop('Probleme_identifie',1, inplace=True)

df_pb_agg = df_pb.groupby(['date', 'ligne']).sum().reset_index()

df_pb_agg.fillna(0, inplace=True)

df_validations_cpt_ctr_pb = pd.merge(df_validations_cpt_ctr, df_pb_agg, how='left')


'''
---------------------------------------------
'''

'''
---liste-periode
'''

df_periodes = pd.read_csv('liste_periodes.csv', sep=';')

df_periodes = df_periodes[['DATE', u'ANNEE', u'SEMESTRE', u'TRIMESTRE', u'LIBELLE_MOIS',  u'LIBELLE_JOUR']]

df_periodes.rename(columns={'DATE':'date'}, inplace=True)

df_periodes.drop_duplicates(inplace=True)

df_validations_cpt_ctr_pb = pd.merge(df_validations_cpt_ctr_pb, df_periodes, how='left')


'''
---
'''
from datetime import datetime

# agg date
df_validations_cpt_ctr_pb['dateTIME'] = pd.to_datetime(df_validations_cpt_ctr_pb.date, '%d/%m/%Y')

# JOUR VAC Scolaire
deb_vac1 = datetime.strptime('21/12/2013', '%d/%m/%Y');
fin_vac1 = datetime.strptime('06/01/2014', '%d/%m/%Y');
deb_vac2 = datetime.strptime('01/03/2014', '%d/%m/%Y');
fin_vac2 = datetime.strptime('17/03/2014', '%d/%m/%Y');
deb_vac3 = datetime.strptime('26/04/2014', '%d/%m/%Y');
fin_vac3 = datetime.strptime('12/05/2014', '%d/%m/%Y');
deb_vac4 = datetime.strptime('03/07/2014', '%d/%m/%Y');
fin_vac4 = datetime.strptime('02/09/2014', '%d/%m/%Y');
deb_vac5 = datetime.strptime('18/10/2014', '%d/%m/%Y');
fin_vac5 = datetime.strptime('03/11/2014', '%d/%m/%Y');
deb_vac6 = datetime.strptime('20/12/2014', '%d/%m/%Y');
fin_vac6 = datetime.strptime('05/01/2015', '%d/%m/%Y');

#JOUR DE GREVE
jG1 = datetime.strptime('14/02/2014', '%d/%m/%Y');
jG2 = datetime.strptime('12/05/2014', '%d/%m/%Y');
jG3 = datetime.strptime('26/05/2014', '%d/%m/%Y');
jG4 = datetime.strptime('21/06/2014', '%d/%m/%Y');
jG5 = datetime.strptime('19/09/2014', '%d/%m/%Y');

#JOUR FERIE
jF1 = datetime.strptime('25/12/2013', '%d/%m/%Y');
jF2 = datetime.strptime('01/01/2014', '%d/%m/%Y');
jF3 = datetime.strptime('21/04/2014', '%d/%m/%Y');
jF4 = datetime.strptime('01/05/2014', '%d/%m/%Y');
jF5 = datetime.strptime('08/05/2014', '%d/%m/%Y');
jF6 = datetime.strptime('29/05/2014', '%d/%m/%Y');
jF7 = datetime.strptime('09/06/2014', '%d/%m/%Y');
jF8 = datetime.strptime('14/07/2014', '%d/%m/%Y');
jF9 = datetime.strptime('15/08/2014', '%d/%m/%Y');
jF10 = datetime.strptime('01/11/2014', '%d/%m/%Y');
jF11 = datetime.strptime('11/11/2014', '%d/%m/%Y');
jF12 = datetime.strptime('25/12/2014', '%d/%m/%Y');

#
JVScolaire = np.where((((df_validations_cpt_ctr_pb['dateTIME'] >= deb_vac1) & (df_validations_cpt_ctr_pb['dateTIME']<= fin_vac1)) | ((df_validations_cpt_ctr_pb['dateTIME'] >= deb_vac2) & (df_validations_cpt_ctr_pb['dateTIME']<= fin_vac2)) 
| ((df_validations_cpt_ctr_pb['dateTIME'] >= deb_vac3) & (df_validations_cpt_ctr_pb['dateTIME']<= fin_vac3)) | ((df_validations_cpt_ctr_pb['dateTIME'] >= deb_vac4) & (df_validations_cpt_ctr_pb['dateTIME']<= fin_vac4)) 
| ((df_validations_cpt_ctr_pb['dateTIME'] >= deb_vac5) & (df_validations_cpt_ctr_pb['dateTIME']<= fin_vac5)) | ((df_validations_cpt_ctr_pb['dateTIME'] >= deb_vac6) & (df_validations_cpt_ctr_pb['dateTIME']<= fin_vac6)))
, 1, 0)
df_validations_cpt_ctr_pb['JVScolaire']  = JVScolaire

JFerie = np.where(((df_validations_cpt_ctr_pb['dateTIME'] == jF1) | (df_validations_cpt_ctr_pb['dateTIME'] == jF2) | (df_validations_cpt_ctr_pb['dateTIME'] == jF3) |
(df_validations_cpt_ctr_pb['dateTIME'] == jF4) | (df_validations_cpt_ctr_pb['dateTIME'] == jF5) | (df_validations_cpt_ctr_pb['dateTIME'] == jF6) |
(df_validations_cpt_ctr_pb['dateTIME'] == jF7) | (df_validations_cpt_ctr_pb['dateTIME'] == jF8) | (df_validations_cpt_ctr_pb['dateTIME'] == jF9) |
(df_validations_cpt_ctr_pb['dateTIME'] == jF10) | (df_validations_cpt_ctr_pb['dateTIME'] == jF11) | (df_validations_cpt_ctr_pb['dateTIME'] == jF12))
, 1, 0)
df_validations_cpt_ctr_pb['JFerie'] = JFerie

 JGreve = np.where(((df_validations_cpt_ctr_pb['dateTIME'] == jG1) | (df_validations_cpt_ctr_pb['dateTIME'] == jG2) | (df_validations_cpt_ctr_pb['dateTIME'] == jG3)
| (df_validations_cpt_ctr_pb['dateTIME'] == jG4) | (df_validations_cpt_ctr_pb['dateTIME'] == jG5)) , 1, 0)
df_validations_cpt_ctr_pb['JGreve'] = JGreve

df_validations_cpt_ctr_pb['deux_prem_jour_mois'] = df_validations_cpt_ctr_pb.date.map(lambda s: int(s.split('/')[0])==1 or int(s.split('/')[0])==2)

df_validations_cpt_ctr_pb = df_validations_cpt_ctr_pb[df_validations_cpt_ctr_pb.ANNEE==2014]

'''
---Meteo
'''
df_meteo = pd.read_csv('Lyon_Daily_Weather_2014.csv')

df_meteo['date'] = df_meteo.CET.map(lambda s: s.split('-')[2].zfill(2)) + '/' + df_meteo.CET.map(lambda s: s.split('-')[1].zfill(2)) + '/' +df_meteo.CET.map(lambda s: s.split('-')[0])  

df_meteo.drop('CET', 1, inplace=True)

df_meteo = df_meteo[[u'date', u'Temperature_moyenneC', u'Mean_Humidite', u'Mean_VisibiliteKm', u'Precipitationmm', u'Condition_Meteo']]

df_meteo.drop_duplicates(inplace=True)

df_validations_cpt_ctr_pb_meteo = pd.merge(df_validations_cpt_ctr_pb, df_meteo, how='left')


'''
--- PV
'''
df_pv = pd.read_csv('../PV.csv')

df_pv.rename(columns={'P\xe9riode':'periode', 'Date': 'date', 'Ligne': 'ligne', 'Montant collect\xe9': 'Montant collecte', 'Nombre de paiment imm\xe9diats':'Nombre de paiment immediats','Nombre de paiments diff\xe9r\xe9s':'Nombre de paiments differes'}, inplace=True)

df_pv = df_pv[['date', 'ligne', u'Nombre total de PV', u'Montant collecte', u'Nombre de paiment immediats', u'Nombre de paiments differes', u'NB_CAT_PV_1', u'NB_CAT_PV_2', u'NB_CAT_PV_3', u'NB_CAT_PV_4', u'NB_PAIE_IMMEDIA_CAT_PV_1', u'NB_PAIE_IMMEDIA_CAT_PV_2', u'NB_PAIE_IMMEDIA_CAT_PV_3', u'NB_PAIE_IMMEDIA_CAT_PV_4']]

df_pv_agg = df_pv.groupby(['date', 'ligne']).sum().reset_index()

df_pv_agg.drop_duplicates(inplace=True)

df_validations_cpt_ctr_pb_meteo_pv = pd.merge(df_validations_cpt_ctr_pb_meteo, df_pv_agg, how='left')


'''
--- Passage bus
'''

df_passage = pd.read_csv('../agg_passage_point_bus.csv', sep=';')

df_passage.rename(columns={'DATE_PASSAGE':'date', 'LIGNE':'ligne', 'ARRET':'arret'}, inplace=True)

df_passage = df_passage[['date', 'ligne', 'MOYENNE_DIFF_HEURE']]

df_passage_agg = df_passage.groupby(['date', 'ligne']).mean().reset_index()

df_validations_cpt_ctr_pb_meteo_pv_pass = pd.merge(df_validations_cpt_ctr_pb_meteo_pv, df_passage_agg, how='left')

df_validations_cpt_ctr_pb_meteo_pv_pass.rename(columns={'MOYENNE_DIFF_HEURE':'moyenne_retard'}, inplace=True)

df_validations_cpt_ctr_pb_meteo_pv_pass.to_csv('Lyon_validations_cpt_ctr_pb_meteo_pv_pass_BUS.csv', sep=';', index=False) 





