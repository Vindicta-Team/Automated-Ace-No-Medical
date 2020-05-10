import hashlib
import os
import json

aceChecksum = hashlib.blake2b(open('te.pbo','rb').read()).hexdigest()
data = { "ace" : aceChecksum }

# touch('/tmp/data.json')

with open('/tmp/data.json', 'w') as f:
    json.dump(data, f)


print(json.dumps(data))
# print(tete)