
import datetime as dt
from datetime import datetime
import time


def main():
	start = time.time()
	print '-- START --'

	start_date = datetime.strptime('01/01/2014 00:00', '%d/%m/%Y %H:%M')
	end_date = datetime.strptime('31/12/2014 23:29', '%d/%m/%Y %H:%M')
	tmp = start_date
	delta = dt.timedelta(minutes=90)

	with open('Periodes1h30.csv', 'w') as periodes:
		while tmp <= end_date:
			periodes.write(str(tmp.year) +'/'+ str(tmp.month).zfill(2) +'/'+  str(tmp.day).zfill(2) + '; '+ str(tmp.hour) + ':' + str(tmp.minute).zfill(2) + ' - ' + str((tmp+delta).hour) + ':' + str((tmp+delta).minute).zfill(2) + '\n')
			tmp += delta
		periodes.close()

	print '-- END --'
	duration = time.time() - start
	print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")
	print("# Computation time:%f seconds\n") % (duration)
	print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")

if __name__ == '__main__':
	main()
