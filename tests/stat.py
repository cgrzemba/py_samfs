from os import walk
from os.path import join, getsize
from samfs import *

basedir = '/sam1/'

for root, dirs, files in walk(basedir):
    for file in ((join(root, name)) for name in files):
        print "%-64s %12d %x\n" % (file, sam_stat(file).st_size, sam_stat(file).attr)
