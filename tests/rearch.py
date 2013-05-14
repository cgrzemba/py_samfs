# import pdb 

from os import walk
from os.path import join, getsize
from samfs import *

basedir = '/samtest'
name = 'lfile856'
# pdb.set_trace()
sam_rearch(join(basedir, name),2,'o','c2')
