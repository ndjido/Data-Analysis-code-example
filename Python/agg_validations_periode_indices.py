import sys
import json
import pandas as pd 
import numpy as np 
import time
from datetime import datetime

'''
work out Periode alias
'''
nb_periode = 48;
step = 30;
def periode_alias(periode):
	if len(periode):
		if periode == '23:30 - 00:00':
			return 'T48'
		start, end = periode.split(' - ')
		start_h, start_s = start.split(':')
		end_h, end_s = end.split(':')
		start_periode_time = int(start_h)*step*2 + int(start_s)
		end_periode_time = int(end_h)*step*2 + int(end_s)
		if end_periode_time - start_periode_time == 30:
			now = 0
			idx_periode = 0
			while idx_periode < nb_periode:
				idx_periode += 1
				now += step
				if now == end_periode_time:
					return 'T' + str(idx_periode);
		else:
			print "Invalid periode"
	return None

'''
works out Day type
'''
def type_jour(jv_scolaire, j_ferie):
	if (jv_scolaire == 1) or (j_ferie ==1):
		return 'V'
	return 'N'

'''
MAIN
'''
def main():
	try:
		start = time.time()
		print '-- START --'
		# validations header
		agg_validations_header = []
		agg_validations = pd.read_csv('../Data/agg_validation_with_header_3.csv', sep=';')
		agg_validations['DATE'] = agg_validations.AGG_VALIDATIONS_DIVERS_DATE_VALIDATION

		# Calendar data
		calendar_header = ["DATE", "PERIODE", "ANNEE", "SEMESTRE", "LIBELLE_SEMESTRE", "TRIMESTRE", "LIBELLE_TRIMESTRE", "ANNEE_MOIS", "MOIS","LIBELLE_MOIS", "SEMAINE", "JOUR", "LIBELLE_JOUR" ,"JOUR_FERIE", "JOUR_OUVRE"]
		calendar_data = pd.read_csv('../Data/liste_periodes.csv', sep=';', header=None, names=calendar_header, skiprows=1)
		
		# Join validation to calendar
		agg_validations_2 = agg_validations.join(calendar_data, on='DATE', how='left')

		# agg date
		agg_validations_2['DATETIME'] = pd.to_datetime(agg_validations_2.DATE, '%d/%m/%Y')

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
	     JVScolaire = np.where((((agg_validations_2['DATETIME'] >= deb_vac1) & (agg_validations_2['DATETIME']<= fin_vac1)) or ((agg_validations_2['DATETIME'] >= deb_vac2) & (agg_validations_2['DATETIME']<= fin_vac2)) 
	      or ((agg_validations_2['DATETIME'] >= deb_vac3) & (agg_validations_2['DATETIME']<= fin_vac3)) or ((agg_validations_2['DATETIME'] >= deb_vac4) & (agg_validations_2['DATETIME']<= fin_vac4)) 
	      or ((agg_validations_2['DATETIME'] >= deb_vac5) & (agg_validations_2['DATETIME']<= fin_vac5)) or ((agg_validations_2['DATETIME'] >= deb_vac6) & (agg_validations_2['DATETIME']<= fin_vac6)))
, 1, 0)
	     agg_validations_2['JVScolaire']  = JVScolaire

	     JFerie = np.where(((agg_validations_2['DATETIME'] == jF1) or (agg_validations_2['DATETIME'] == jF2) or (agg_validations_2['DATETIME'] == jF3) or
	     (agg_validations_2['DATETIME'] == jF4) or (agg_validations_2['DATETIME'] == jF5) or (agg_validations_2['DATETIME'] == jF6) or
	     (agg_validations_2['DATETIME'] == jF7) or (agg_validations_2['DATETIME'] == jF8) or (agg_validations_2['DATETIME'] == jF9) or
	     (agg_validations_2['DATETIME'] == jF10) or (agg_validations_2['DATETIME'] == jF11) or (agg_validations_2['DATETIME'] == jF12))
, 1, 0)
	     agg_validations_2['JFerie'] = JFerie

	     
 	     JGreve = np.where(((agg_validations_2['DATETIME'] == jG1) or (agg_validations_2['DATETIME'] == jG2) or (agg_validations_2['DATETIME'] == jG3)
		 or (agg_validations_2['DATETIME'] == jG4) or (agg_validations_2['DATETIME'] == jG5)) , 1, 0)
	     agg_validations_2['JGreve'] = JGreve

	     # Build groups
	     # ID format: ARRET_{JOUR N/V}_{LIBELLE JOUR (3 1ere lettres)}_TRANCHE_HORAIRE_LIGNE
	     AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE
	     type_jour() JVScolaire  JFerie
	     LIBELLE_JOUR  [:3] 
	    
	     groups = []
	     for i in range(len(agg_validations_2.index)):
	     	arret = str(agg_validations_2.ix[i]['AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE']) 
	     	jour_NV = str(type_jour(agg_validations_2.ix[i]['JVScolaire'], agg_validations_2.ix[i]['JFerie']))
	     	libelle_jour =  str(agg_validations_2.ix[i]['LIBELLE_JOUR'])[:3]
	     	tranche = str(periode_alias(agg_validations_2.ix[i]['AGG_VALIDATIONS_DIVERS_PERIODE']))
	     	group_value = arret + '_' + jour_NV + '_' + libelle_jour + '_' + tranche
	     	groups.append(group_value)

	    agg_validations_2['GROUP'] = groups

	    # Indices computation
	    index_helpers = agg_validations_2['AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS'].groupby(['GROUP']).agg(['sum', 'mean', 'std'])

	    # Join index helpers & agg_validation
	    agg_validations_index_helpers = agg_validations_2.join(index_helpers, how='left', on='GROUP')

	    # Compute indexes
	    agg_validations_indexes['INDICES_1'] =  agg_validations_index_helpers['AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS']/ agg_validations_index_helpers['mean']
	    agg_validations_indexes['INDICES_2'] =  (agg_validations_index_helpers['AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS'] - agg_validations_index_helpers['mean'])/ agg_validations_index_helpers['std']

	    agg_validations_indexes.to_csv("agg_validations_indexes", sep=";")
	    
		print '-- END --'
		duration = time.time() - start
		print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")
		print("# Computation time:%f seconds\n") % (duration)
		print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")

	except Exception as details:
		print "Error:%s" % details

if __name__ == '__main__':
	main()


