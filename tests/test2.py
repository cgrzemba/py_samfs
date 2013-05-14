from os import walk
from os.path import join, getsize
from samfs import *

for root, dirs, files in walk('/sam'):
    print root,
    for name in files:
       if name.find('.',0,1) != 0:
           file = join(root, name)
           print file, 
           print sam_stat(file)
