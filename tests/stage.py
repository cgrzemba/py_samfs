from os import walk
from os.path import join, getsize
from samfs import *

basedir = '/samtest'
name = 'lfile856'
sam_stage(join(basedir, name),'i')
