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

                print "loading Lyon_Passages_TRAM_Periodes Gp data..."
                df_passages_tram_agg = pd.read_csv("Lyon_Passages_TRAM_Periodes_Group.csv", sep='|', low_memory=False)
                print 'EOF loading Lyon_Passages_TRAM_Periodes Gp data'

                print "create groups..."
                df_passages_tram_agg['groups_helper'] = df_passages_tram_agg.DATE.map(str) + '_' + df_passages_tram_agg.PERIODE.map(str) + '_' + df_passages_tram_agg.ARRET.map(str)
                df_passages_tram_agg_A = df_passages_tram_agg.groupby(['groups_helper'])['groups_helper', 'RETARD_ENTREE', 'RETARD_ENTREE_SUP_5mn', 'RETARD_ENTREE_2mn_5mn', 'AVANCE_ENTREE_SUP_5mn', 'AVANCE_ENTREE_2mn_5mn']
                df_passages_tram_agg_A_agg = df_passages_tram_agg_A.agg(['count', 'sum', 'mean', 'std'])
                print
                print "writting to disk..."
                df_passages_tram_agg.to_csv("Lyon_Passages_TRAM_Periodes_Group_2.csv", sep='|', index=False)

                print '-- END --'
                duration = time.time() - start
                print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")
                print("# Computation time:%f seconds\n") % (duration)
                print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")

        except Exception as details:
                print "Error:%s" % details

if __name__ == '__main__':
        main()
~               