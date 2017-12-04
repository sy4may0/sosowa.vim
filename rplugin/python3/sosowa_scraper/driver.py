import sosowa_requester
import sys

sr1 = sosowa_requester.sosowa_requester(sys.argv[1])

p = sr1.get_sosowa_product_list(50)

sr1.get_sosowa_article(p['1204215351'])
sr1.get_sosowa_article(p['1204215351'])
article = sr1.get_sosowa_article(p['1204215351'])

array = article.get_article('content')
for i in array:
    print(i+"EOF")

