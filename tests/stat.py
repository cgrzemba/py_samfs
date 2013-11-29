from os import walk
from os.path import join, getsize
from samfs import *

basedir = '/samtest/aa/00/'

for root, dirs, files in walk(basedir):
    for file in ((join(root, name)) for name in files):
        if isOffline(file):
            print file,
            sam_stage(file,'i')
