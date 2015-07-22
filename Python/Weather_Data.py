
import requests
import datetime as dt
from datetime import datetime
import time
import codecs

'''
Link Tours http://www.wunderground.com/history/airport/LFOT/2015/3/10/DailyHistory.html?req_city=Tours&req_state=&req_statename=France&reqdb.zip=00000&reqdb.magic=1&reqdb.wmo=07240&format=1
'''

def get_weather(day, month, year, city):
	r = None
	if str(city).upper() == "LYON":
		r = requests.get('http://www.wunderground.com/history/airport/LFLY/'+str(year)+'/'+str(month)+'/'+str(day)+'/DailyHistory.html?req_city=Lyon&req_state=&req_statename=France&reqdb.zip=00000&reqdb.magic=63&reqdb.wmo=07480&format=1')
	elif str(city).upper() == "TOURS":
		r = requests.get('http://www.wunderground.com/history/airport/LFOT/'+str(year)+'/'+str(month)+'/'+str(day)+'/DailyHistory.html?req_city=Tours&req_state=&req_statename=France&reqdb.zip=00000&reqdb.magic=1&reqdb.wmo=07240&format=1')

	return r.text

def main():
	start = time.time()
	print '-- START --'

	start_date = datetime.strptime('1/12/2013', '%d/%m/%Y')
	end_date = datetime.strptime('31/12/2014', '%d/%m/%Y')
	tmp = start_date
	delta = dt.timedelta(days=1)

	# with codecs.open("../../Data/Weather_Data_Lyon.csv", mode='w', encoding="utf-8") as data_file:
	# 	while tmp <= end_date:
	# 		data_file.write(get_weather(tmp.day, tmp.month, tmp.year, "LYON"))
	# 		tmp += delta
	# 	data_file.close()

	with codecs.open("../../Data/Weather_Data_Tours.csv", mode='w', encoding="utf-8") as data_file:
		while tmp <= end_date:
			data_file.write(get_weather(tmp.day, tmp.month, tmp.year, "TOURS"))
			tmp += delta
		data_file.close()

	print '-- END --'
	duration = time.time() - start
	print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")
	print("# Computation time:%f seconds\n") % (duration)
	print("#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++#\n")


if __name__ == '__main__':
	main()


'''
Get rid of header:
#TimeCET,TemperatureC,Dew PointC,Humidity,Sea Level PressurehPa,VisibilityKm,Wind Direction,Wind SpeedKm/h,Gust SpeedKm/h,Precipitationmm,Events,Conditions,WindDirDegrees,DateUTC
> sed '/^TimeCET/d' Weather_Data_Tours.csv > Weather_Data_Tours_1.csv
> sed '/^$/d' Weather_Data_Tours_1.csv > Weather_Data_Tours_2.csv
> sed 's/\<br \/\>//g' Weather_Data_Tours_2.csv > Weather_Data_Tours_3.csv
'''
