# #!/usr/bin/env python
from concurrent.futures import thread
from time import sleep
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

options = Options()
options.headless = True

# Start the browser and navigate to http://automationpractice.com/index.php.
driver = webdriver.Chrome(executable_path="C:\\Code\\Azure\\udacity-azure-devops\\9.test-selenium\\chromedriver.exe", options=options)
url = 'http://automationpractice.com/index.php'
searchItem = 't shirt'

print('Navigating to: ' + url)
driver.get(url)

print('Searching for: ' + searchItem)
driver.find_element(by=By.ID,value= "search_query_top").send_keys(searchItem)
searchBtn = driver.find_element(by=By.CSS_SELECTOR, value="button[class='btn btn-default button-search']")
sleep(2)
searchBtn.click()
our_search = driver.find_element(by=By.CSS_SELECTOR, value="div[id='center_column']>h1>span.lighter").text
result = driver.find_element(by=By.CSS_SELECTOR, value="div[id='center_column']>h1>span.heading-counter").text

assert "T SHIRT" in our_search
print("We are on the search results page for "+ our_search)
if "1" in result:
	print("We found "+ result)
else:
	print("We did not find "+ result)
driver.close()
driver.quit()