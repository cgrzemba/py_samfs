from os import walk
from os.path import join, getsize
from samfs import *

filelist = {}
basedir = '/sam/wg/projekte/archive'

for root, dirs, files in walk(basedir):
#     print root,
    for file in ((join(root, name)) for name in files):
        try:
            if not isOffline(file) or isArchDone(file):
                filelist[file] = sam_stat(file).attr,
        except IOError, e: 
            if e.errno in (2,13):
                 print "IO ERROR: ", e.strerror, file

print len(filelist)
