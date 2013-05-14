from os import walk
from os.path import join, getsize
from samfs import *

for root, dirs, files in walk('/sam'):
    print root,
    for file in ((join(root, name)) for name in files):
        if isOffline(file) and not isArchDone(file):
        	print file, 
        	print sam_stat(file).attr,
		print sam_stat(file).copies
