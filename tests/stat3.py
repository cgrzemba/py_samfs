from os import walk
from os.path import join, getsize
from samfs import *

filelist = {}
basedir = '/sam/wg/projekte/archive'

class fileStat:
    'define SAM file status attribute object'
    def __init__(self, filename):
        self.attr = sam_stat(filename).attr
    def isOffline(self):
        return self.attr & SS_OFFLINE
    def isArchDone(self):
        return self.attr & SS_ARCHDONE
    def get(self):
        return self.attr
            

for root, dirs, files in walk(basedir):
#     print root,
    for file in ((join(root, name)) for name in files):
        try:
            fs = fileStat(file)
            if not fs.isOffline() or fs.isArchDone():
                filelist[file] = fs.get()
        except IOError, e: 
            if e.errno in (2,13):
                 print "IO ERROR: ", e.strerror, file

print len(filelist)
