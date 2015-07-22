

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

category = df_prod[u'Libell� Sous type-produit'].tolist()

category_u = np.unique(category)

##-> Initialisation

codes = df_prod[df_prod[u'Libell� Sous type-produit']==category_u[0]]['Code produit_x']

df_validations_1 = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod[u'Libell� Sous type-produit']==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('df_validations_agg_sous_type_prod.csv', sep=';', index=False)


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

df_validations_1 = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod["Code famille"]==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
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

df_validations_1 = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod["Code sous-famille"]==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('df_validations_agg_sous_famille_prod.csv', sep=';', index=False)

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

df_validations_1 = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod[u'Famille Marketing (Produit)']==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('df_validations_agg_famille_marketing_prod.csv', sep=';', index=False)

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

df_validations_1 = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())

df_validations_1['categorie'] = category_u[0]

df_validations_1_agg = df_validations_1.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()

df_validations_1_agg.rename(columns={'value':str(category_u[0])}, inplace=True) 


##-> 
for i in range(len(category_u))[1:]:
	codes = df_prod[df_prod["Cible"]==category_u[i]]['Code produit_x']
	df_validations_x = pd.melt(df_validations, id_vars=['date','ligne', 'arret', 'type_transport'], value_vars=codes.tolist())
	df_validations_x['categorie'] = category_u[i]
	df_validations_x_agg = df_validations_x.groupby(['date','ligne', 'arret', 'type_transport']).sum().reset_index()
	df_validations_x_agg.rename(columns={'value':str(category_u[i])}, inplace=True) 
	df_validations_1_agg = pd.merge(df_validations_1_agg, df_validations_x_agg)

df_validations_1_agg.fillna(0, inplace=True)

df_validations_1_agg.to_csv('df_validations_agg_cible_prod_2.csv', sep=';', index=False)



'''
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Serfling method DataPrep
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'''


