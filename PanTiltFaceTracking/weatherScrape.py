import feedparser
import re
import sys

data = feedparser.parse('http://wxdata.weather.com/wxdata/weather/rss/local/USCT0135?cm_ven=LWO&cm_cat=rss')
value = data['entries'][0]['summary_detail']['value']
result = re.search(r'\>(.*\.)', str(value))
result = result.group(1)
result = re.sub('&deg;', 'degrees', result)
result = re.sub('F', 'fahrenheit', result)
sys.stdout.write(result)
