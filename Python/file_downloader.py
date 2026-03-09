# TODO: Use input() to take a URL from the user
# TODO: Update to work if on a windows host, perhaps using the requests library
# TODO: Allow user to specify destination filename
import requests

url = 'https://assets.tryhackme.com/img/THMlogo.png'
r = requests.get(url, allow_redirects=True)
open('THMlogo.png', 'wb').write(r.content)
