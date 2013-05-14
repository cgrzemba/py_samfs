from os import walk
from os.path import join, getsize
from samfs import *

basedir = '/samtest'

for root, dirs, files in walk(basedir):
    print root,
    for file in ((join(root, name)) for name in files):
        if isDamaged(file):
         print file,
         print "%x" % sam_stat(file).attr,
         print sam_stat(file).copies
