import sys
import json
import pandas as pd
import numpy as np
import time
from datetime import datetime


def main():
        try:
                start = time.time()
                print '-- START --\n'

                print "loading Lyon_Passages_TRAM_Periodes data..."
                df_passages_tram = pd.read_csv("Lyon_Passages_TRAM_Periodes.csv", sep='|', low_memory=False)
                print 'EOF loading Lyon_Passages_TRAM_Periodes data'

                print "creating datetime for passages_tram"
                df_passages_tram['HEUREPASSAGE_'] = pd.to_datetime(df_passages_tram.HEUREPASSAGE, "%d-%m-%y %H:%M:%s")
                df_passages_tram['HEUREENTREE_'] = pd.to_datetime(df_passages_tram.HEUREENTREE, "%d-%m-%y %H:%M:%s")
                df_passages_tram['HEURESORTIE_'] = pd.to_datetime(df_passages_tram.HEURESORTIE, "%d-%m-%y %H:%M:%s")


                print "merging passage & periode ..."
                #duree ouverture des portes
                tmp = df_passages_tram['HEURESORTIE_'] - df_passages_tram['HEUREENTREE_']
                df_passages_tram['DUREE_OUVERTURE_PORTES'] = tmp.astype(np.int)/10**9/60
                #retard entree
                tmp2 = df_passages_tram['HEUREENTREE_'] - df_passages_tram['HEUREPASSAGE_']
                df_passages_tram['RETARD_ENTREE'] = tmp2.astype(np.int)/10**9/60
                #retard entree > 5m
                df_passages_tram['RETARD_ENTREE_SUP_5mn'] = np.where(((df_passages_tram['RETARD_ENTREE']/60.0) >= 5.0),1,0)
                #retard entree 2mn - 5mn
                df_passages_tram['RETARD_ENTREE_2mn_5mn'] = np.where(((df_passages_tram['RETARD_ENTREE']/60.0) >= 2.0) & ((df_passages_tram['RETARD_ENTREE']/60.0)<=5.0),1,0)
                #avance entree > 5mn
                df_passages_tram['AVANCE_ENTREE_SUP_5mn'] = np.where(((-1 * df_passages_tram['RETARD_ENTREE']/60.0) >= 5.0),1,0) 
                #avance entree 2mn - 5mn
                df_passages_tram['AVANCE_ENTREE_2mn_5mn'] = np.where(((-1 * df_passages_tram['RETARD_ENTREE']/60.0) >= 2.0) & ((-1 * df_passages_tram['RETARD_ENTREE']/60.0)<=5.0),1,0)

                print ">> Formating calendar data!\n"
                df_passages_tram['DTIME'] = pd.to_datetime(df_passages_tram.DATE, "%d/%m/%Y")
                # JOUR VAC Scolaire
                deb_vac1 = datetime.strptime('21/12/2013', '%d/%m/%Y')
                fin_vac1 = datetime.strptime('06/01/2014', '%d/%m/%Y')
                deb_vac2 = datetime.strptime('01/03/2014', '%d/%m/%Y')
                fin_vac2 = datetime.strptime('17/03/2014', '%d/%m/%Y')
                deb_vac3 = datetime.strptime('26/04/2014', '%d/%m/%Y')
                fin_vac3 = datetime.strptime('12/05/2014', '%d/%m/%Y')
                deb_vac4 = datetime.strptime('03/07/2014', '%d/%m/%Y')
                fin_vac4 = datetime.strptime('02/09/2014', '%d/%m/%Y')
                deb_vac5 = datetime.strptime('18/10/2014', '%d/%m/%Y')
                fin_vac5 = datetime.strptime('03/11/2014', '%d/%m/%Y')
                deb_vac6 = datetime.strptime('20/12/2014', '%d/%m/%Y')
                fin_vac6 = datetime.strptime('05/01/2015', '%d/%m/%Y')
             
            #JOUR DE GREVE
                jG1 = datetime.strptime('14/02/2014', '%d/%m/%Y')
                jG2 = datetime.strptime('12/05/2014', '%d/%m/%Y')
                jG3 = datetime.strptime('26/05/2014', '%d/%m/%Y')
                jG4 = datetime.strptime('21/06/2014', '%d/%m/%Y')
                jG5 = datetime.strptime('19/09/2014', '%d/%m/%Y')
             
             #JOUR FERIE
                jF1 = datetime.strptime('25/12/2013', '%d/%m/%Y')
                jF2 = datetime.strptime('01/01/2014', '%d/%m/%Y')
                jF3 = datetime.strptime('21/04/2014', '%d/%m/%Y')
                jF4 = datetime.strptime('01/05/2014', '%d/%m/%Y')
                jF5 = datetime.strptime('08/05/2014', '%d/%m/%Y')
                jF6 = datetime.strptime('29/05/2014', '%d/%m/%Y')
                jF7 = datetime.strptime('09/06/2014', '%d/%m/%Y')
                jF8 = datetime.strptime('14/07/2014', '%d/%m/%Y')
                jF9 = datetime.strptime('15/08/2014', '%d/%m/%Y')
                jF10 = datetime.strptime('01/11/2014', '%d/%m/%Y')
                jF11 = datetime.strptime('11/11/2014', '%d/%m/%Y')
                jF12 = datetime.strptime('25/12/2014', '%d/%m/%Y')
                print ">> end Formating!\n"
                
                #
                print ">> Computing calendar data\n"
                print ">> jvscolaire\n"
                jvscolaire_test = ((df_passages_tram['DTIME'] >= deb_vac1) & (df_passages_tram['DTIME']<= fin_vac1)) | ((df_passages_tram['DTIME'] >= deb_vac2) & (df_passages_tram['DTIME']<= fin_vac2)) | ((df_passages_tram['DTIME'] >= deb_vac3) & (df_passages_tram['DTIME']<= fin_vac3)) | ((df_passages_tram['DTIME'] >= deb_vac4) & (df_passages_tram['DTIME']<= fin_vac4)) | ((df_passages_tram['DTIME'] >= deb_vac5) & (df_passages_tram['DTIME']<= fin_vac5)) | ((df_passages_tram['DTIME'] >= deb_vac6) & (df_passages_tram['DTIME']<= fin_vac6))
                JVScolaire = np.where(jvscolaire_test, 1, 0)
                df_passages_tram['JVScolaire']  = JVScolaire

                print ">> jferie\n"
                jferie_test = (df_passages_tram['DTIME'] == jF1) | (df_passages_tram['DTIME'] == jF2) | (df_passages_tram['DTIME'] == jF3) | (df_passages_tram['DTIME'] == jF4) | (df_passages_tram['DTIME'] == jF5) | (df_passages_tram['DTIME'] == jF6) | (df_passages_tram['DTIME'] == jF7) | (df_passages_tram['DTIME'] == jF8) | (df_passages_tram['DTIME'] == jF9) | (df_passages_tram['DTIME'] == jF10) | (df_passages_tram['DTIME'] == jF11) | (df_passages_tram['DTIME'] == jF12)
                JFerie = np.where(jferie_test, 1, 0)
                df_passages_tram['JFerie'] = JFerie

                print ">> jgreve\n"
                jgreve_test = (df_passages_tram['DTIME'] == jG1) | (df_passages_tram['DTIME'] == jG2) | (df_passages_tram['DTIME'] == jG3) | (df_passages_tram['DTIME'] == jG4) | (df_passages_tram['DTIME'] == jG5) 
                JGreve = np.where(jgreve_test, 1, 0)
                df_passages_tram['JGreve'] = JGreve
                print ">> end Computing calendar data\n"
                
                # Build groups
                # ID format: ARRET_{JOUR N/V}_{LIBELLE JOUR (3 1ere lettres)}_TRANCHE_HORAIRE_LIGNE
                print ">> Building groups\n"
                arret = df_passages_tram['ARRET'].map(str)
                jour_NV = np.where(np.logical_or(df_passages_tram['JVScolaire']==1, df_passages_tram['JFerie']==1), 'V', 'N')
                libelle_jour =  df_passages_tram['LIBELLE_JOUR'].map(lambda s: str(s)[:3])
                tranche = df_passages_tram['PERIODE'].map(str)
                df_passages_tram['GROUPS'] = arret + '_' + jour_NV + '_' + libelle_jour + '_' + tranche
 
                print "writting to disk..."
                df_passages_tram.to_csv("Lyon_Passages_TRAM_Periodes_Group.csv", sep='|', index=False)

                print '-- END --'
                duration = time.time() - start
                print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")
                print("# Computation time:%f seconds\n") % (duration)
                print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")

        except Exception as details:
                print "Error:%s" % details

if __name__ == '__main__':
        main()
