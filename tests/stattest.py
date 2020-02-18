from os import walk
from os.path import join, getsize
from samfs import *
from thread import start_new_thread, allocate_lock
from time import sleep

filelist = {}
basedir = '/sam/wg/projekte/archive'

nothreads = 8
locks = []
fllock = allocate_lock()

def setupLocks(nothreads):
    for i in range(nothreads) :
        lock = allocate_lock()
        locks.append(lock)

def appendAttr(file):
    fllock.acquire()
    filelist[file] = sam_stat(file).attr
    fllock.release()
    
def procDir(subroot,lock,i):
    print "start %d for %s" %(i,subroot)
    for dirname, subdirs, files in walk(subroot):
        for file in ((join(dirname, name)) for name in files):
            try:
                if not isOffline(file) or isArchDone(file):
                    appendAttr(file)
            except IOError, e: 
                if e.errno == 2:
                     print "IO ERROR: ", e.strerror, file
    print "finish %d for %s" %(i,subroot)
    lock.release()

def main():
    setupLocks(nothreads)
    i = 0
    root, dirs, files = walk(basedir).next()
    #     print root,
    for subroot in ((join(root, name)) for name in dirs):
        for i in range(nothreads) :
            if not locks[i].locked(): break
#            print "lock[%d] locked" % i
            
        locks[i].acquire()
        start_new_thread(procDir,(subroot,locks[i],i))
        
    print "wait for finish childrens"
    for i in range(nothreads):
        while locks[i].locked():
            print "wait for %d" % i
            sleep(1)
                 
    print "found %d offline files\n" % len(filelist)

if __name__ == '__main__':
   main()
