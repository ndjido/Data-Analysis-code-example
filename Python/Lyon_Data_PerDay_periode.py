

df_validations = pd.read_csv('agg_validation_with_header_3.csv', sep=';')

df_prod = pd.read_csv('../Lyon_Produit_justice.csv', sep=';')

code_produit = df_prod["Code produit_x"].tolist()

header_valid = ['AGG_VALIDATIONS_DIVERS_DATE_VALIDATION', 'AGG_VALIDATIONS_DIVERS_PERIODE', 'AGG_VALIDATIONS_DIVERS_LIG_CODE', 'AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE', 'LISTE_ARRETS_NOM_LIE', 'AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT','AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS', 'AGG_VALIDATIONS_DIVERS_NB_VENTE_ARRET']

[header_valid.append(prod) for prod in code_produit]

df_validations_new = df_validations[header_valid]

df_validations_new['groups1'] = df_validations.AGG_VALIDATIONS_DIVERS_DATE_VALIDATION.map(str) + '_' + df_validations_new.AGG_VALIDATIONS_DIVERS_LIG_CODE.map(str) + '_' + df_validations_new.AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE.map(str) + '_' + df_validations_new.AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT.map(str)

df_val_new_agg = df_validations_new.groupby(['groups1']).agg(sum).reset_index()

df_val_new_agg['date']= df_val_new_agg.groups1.map(lambda s: s.split('_')[0])

df_val_new_agg['ligne']= df_val_new_agg.groups1.map(lambda s: s.split('_')[1])

df_val_new_agg['arret']= df_val_new_agg.groups1.map(lambda s: s.split('_')[2])

df_val_new_agg['type_transport']= df_val_new_agg.groups1.map(lambda s: s.split('_')[3])

df_val_new_agg.drop('AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE', 1, inplace=True)

df_val_new_agg_clean = df_val_new_agg.drop_duplicates().fillna(0)

df_val_new_agg_clean.to_csv('Lyon_Validations_Prod_1_agg.csv', sep=';', index=False)

'''
Renaming
'''

df_validations.rename(columns={'AGG_VALIDATIONS_DIVERS_DATE_VALIDATION':'date'}, inplace=True)
df_validations.rename(columns={'AGG_VALIDATIONS_DIVERS_PERIODE':'periode'}, inplace=True)
df_validations.rename(columns={'AGG_VALIDATIONS_DIVERS_LIG_CODE':'ligne'}, inplace=True)
df_validations.rename(columns={'AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE':'arret'}, inplace=True)
df_validations.rename(columns={'AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT':'type_transport'}, inplace=True)
df_validations.rename(columns={'AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS':'nb_validations'}, inplace=True)


'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# wide to long
# Code sous-type produit
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''
del df_validations_1
del df_validations_1_agg

category = df_prod['Libell\xe9 Sous type-produit'].tolist()

category_u = np.unique(category)

##-> Initialisation

codes = df_prod[df_prod['Libell\xe9 Sous type-produit']==category_u[0]]['Code produit_x']

df_validations_1 = pd.melt(df_validations, id_vars=['date','periode', 'ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod['Libell\xe9 Sous type-produit']==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date', 'periode','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('NEW_DATA/Lyon_validations_agg_sous_type_prod.csv', sep=';', index=False)


'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# wide to long    NOT DONE : Memory Error
# Code Famille
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''
del df_validations_1
del df_validations_1_agg

category = df_prod["Code famille"].tolist()

category_u = np.unique(category)

#start = time.time()
codes = df_prod[df_prod["Code famille"]==category_u[0]]['Code produit_x']

df_validations_1 = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod["Code famille"]==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

#end = time.time() - start

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('df_validations_agg_famille_prod.csv', sep=';', index=False)
'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# wide to long
# Code Sous Famille
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''
del df_validations_1
del df_validations_1_agg

category = df_prod[u'Code sous-famille'].tolist()

category_u = np.unique(category)

codes = df_prod[df_prod["Code sous-famille"]==category_u[0]]['Code produit_x']

df_validations_1 = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod["Code sous-famille"]==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('NEW_DATA/Lyon_validations_agg_sous_famille_prod.csv', sep=';', index=False)

'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# wide to long
# Code Famille Marketing
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''
del df_validations_1
del df_validations_1_agg

category = df_prod[u'Famille Marketing (Produit)'].tolist()

category_u = np.unique(category)

codes = df_prod[df_prod[u'Famille Marketing (Produit)']==category_u[0]]['Code produit_x']

df_validations_1 = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod[u'Famille Marketing (Produit)']==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('NEW_DATA/Lyon_validations_agg_famille_marketing_prod.csv', sep=';', index=False)

'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# wide to long
# Cible
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''
del df_validations_1
del df_validations_1_agg

category = df_prod[u'Cible'].tolist()

category_u = np.unique(category)

codes = df_prod[df_prod["Cible"]==category_u[0]]['Code produit_x']

df_validations_1 = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod["Cible"]==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','periode','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','periode','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('NEW_DATA/Lyon_validations_agg_cible_prod_2.csv', sep=';', index=False)



'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Serfling method DataPrep
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''


df_validations_t1 = df_validations_t1[[u'date', u'ligne', u'arret', u'type_transport', 'AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS', u'AGG_VALIDATIONS_DIVERS_NB_VENTE_ARRET', 
 u'Nombre_Perturbations', u'Nombre_Infractions', u'Nombre_alertes', u'Probleme_identifie',
  u'ANNEE', u'LIBELLE_MOIS', u'SEMAINE', u'LIBELLE_JOUR', u'JVScolaire', u'JFerie', u'JGreve', u'CET', u'Temperature_maximumC', 
  u'Temperature_moyenneC', u'Temperature_minimumC', u'Point_de_roseeC', u'MeanDew_PointC', u'Min_DewpointC', u'Max_Humidite', 
  u'Mean_Humidite', u'Min_Humidite', u'Max_Pression_au_niveau_de_la_merhPa', u'Mean_Pression_au_niveau_de_la_merhPa', 
  u' Min_Pression_au_niveau_de_la_merhPa', u'Max_VisibiliteKm', u'Mean_VisibiliteKm', u'Min_VisibilitekM', u'Max_Vitesse_du_ventKm_h',
   u'Mean_Vitesse_du_ventKm_h', u' Max_Vitesse_des_RafalesKm_h', u'Precipitationmm', u'CloudCover', u'Condition_Meteo', u'WindDirDegrees']]


df_validations_t1.drop_duplicates(inplace=True)
