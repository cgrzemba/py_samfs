from os import walk
from os.path import join
from samapi import *
from collections import namedtuple



# SAMFS attributes mapped into sam_stat but not in inode (ino_status_t).

SS_SAMFS        = 0x00000800      # SAM-FS file 
SS_ARCHIVE_R    = 0x00002000      # Re-archive 
SS_ARCHIVED     = 0x00010000      # File has at least one archive copy 
SS_DATA_V       = 0x00040000      # File requires data verification 
SS_AIO          = 0x00080000      # AIO Char Device file 
SS_ARCHIVE_A    = 0x08000000      # Archive immediate 

# SAMFS attributes from the inode.
 
SS_REMEDIA      = 0x00000001      # Removable media file 
SS_RELEASE_A    = 0x00000002      # Release after archive 
SS_RELEASE_N    = 0x00000004      # Release never (nodrop) 
SS_STAGE_N      = 0x00000008      # Stage never (direct) 
SS_DAMAGED      = 0x00000010      # File is damaged - 
                                        # not online and no copy 
SS_RELEASE_P    = 0x00000020      # Release partial (bof_online) 
SS_ARCHIVE_N    = 0x00000040      # Archive never (noarch) 
SS_STAGE_A      = 0x00000080      # Stage associative (stageall) 

SS_CSVAL        = 0x00000100      # Valid checksum exists in inode 
SS_CSUSE        = 0x00000200      # Checksum will be used upon stage 
SS_CSGEN        = 0x00000400      # Checksum will be generated upon - 
                                        # archive 
SS_SAMFS        = 0x00000800      #  SAM-FS file 

SS_ARCHDONE     = 0x00001000      # File has all required -  
                                        # archiving done 
#      SS_ARCHIVE_R    = 0x00002000      used by sam_stat() - see above 
SS_PARTIAL      = 0x00004000      # Partial extents are online 
SS_OFFLINE      = 0x00008000      # File is offline 

SS_ARCHIVED     = 0x00010000      # used by sam_stat() - see above 
SS_SEGMENT_A    = 0x00020000      # Segment attribute 
#      SS_DATA_V       = 0x00040000      used by sam_stat() - see above 
#      SS_AIO          = 0x00080000      used by sam_stat() - see above 

SS_ARCHIVE_C    = 0x00100000      # Archive concurrent 
SS_DIRECTIO     = 0x00200000      # Directio 
SS_ARCHIVE_I    = 0x00400000      # Archive inconsistent copies 
SS_WORM         = 0x00800000      # Read only attribute (worm_attr) 

SS_READONLY     = 0x01000000      # Read only file enabled (worm_set) 
SS_SEGMENT_S    = 0x02000000      # This is a segment of a - 
                                        # segmented file 
SS_SEGMENT_F    = 0x04000000      # Stage/archive file in segments 
#      SS_ARCHIVE_A    = 0x08000000      used by sam_stat() - see above 

SS_SETFA_S      = 0x10000000      # Stripe Width set by setfa -s 
SS_SETFA_H      = 0x10000000      # Stripe Width set by setfa -h 
SS_SETFA_G      = 0x20000000      # Stripe Group set by setfa -g 
SS_SETFA_O      = 0x20000000      # Stripe Group set by setfa -o 
SS_DFACL        = 0x40000000      # Default access control list - 
                                        # present 
SS_ACL          = 0x80000000      # Access control list present 

SS_OBJECT_FS    = 0x000100000000  # Object file system "mb"

#
# * Copy flag masks.
#
CF_STALE =               0x0001  # This archive copy is stale
CF_REARCH =              0x0002  # Copy is to be rearchived 
CF_ARCH_I =              0x0004  # Copy is to be archived immediately 
CF_VERIFIED =            0x0008  # Copy has been verified 
CF_DAMAGED =             0x0010  # This archive copy is damaged 
CF_UNARCHIVED =          0x0020  # This archive copy was unarchived 
CF_INCONSISTENT =        0x0040  # This archive copy is inconsistent 
CF_ARCHIVED =            0x0080  # This archive copy made 
CF_AR_FLAGS_MASK =       0x00FF  # the flags in the stat struct from 
                                        # the AR_FLAGS in the inode 
CF_PAX_ARCH_FMT =        0x8000  # from SAR_hdr_off0 in the inode 

CES_NEEDSAUDIT = 0x80000000
CES_INUSE      = 0x40000000 # slot in use
CES_LABLED   = 0x20000000 # volume has label
CES_OCCUPIED = 0x08000000 # Lib Slot occupied
CES_BARCODE  = 0x02000000 # volume has barcode
CES_RECYCLE  = 0x00400000
CES_NONSAM   = 0x00080000 # not a sam tape
CES_DUPVSN   = 0x00004000
CES_ARCHFULL = 0x00000800 # volume found full by archiver
CES_EMPTY    = 0x00000400

def isOffline(path):
    return (sam_stat(path).attr & SS_OFFLINE) != 0
    
def isArchDone(path):
    return (sam_stat(path).attr & SS_ARCHDONE) != 0

def hasCopy(path):
    return (sam_stat(path).attr & SS_ARCHIVED) != 0

def isWorm(path):
    return (sam_stat(path).attr & SS_WORM) != 0
    
def isDamaged(path):
    return (sam_stat(path).attr & SS_DAMAGED) != 0

CF_BASE = 16 # the 16 correspondes to the index of copy0_flags in static PyStructSequence_Field StatResultFileds in samapi.i
VSN_BASE = 20 # the 20 correspondes to the index of copy0_vsn in static PyStructSequence_Field StatResultFileds in samapi.i
# ncopy in range 1..4
def willRearch(path,ncopy):
    return (sam_stat(path)[CF_BASE + ncopy-1] & CF_REARCH) != 0 
    
def isStale(path,ncopy):
    return (sam_stat(path)[CF_BASE + ncopy-1] & CF_STALE) != 0
    
def isDamaged(path,ncopy):
    return (sam_stat(path)[CF_BASE + ncopy-1] & CF_DAMAGED) != 0

def isArchived(path,ncopy):
    return (sam_stat(path)[CF_BASE + ncopy-1] & CF_ARCHIVED) != 0

def isUnArchived(path,ncopy):
    return (sam_stat(path)[CF_BASE + ncopy-1] & CF_UNARCHIVED) != 0

def isInconsistent(path,ncopy):
    return (sam_stat(path)[CF_BASE + ncopy-1] & CF_INCONSISTENT) != 0
    
def hasDamagedCopy(path):
    filestat = sam_stat(path)
    for i in range(4):
        if filestat[CF_BASE + i] & CF_DAMAGED:
            return True
    return False

def hasRearchCopy(path):
    filestat = sam_stat(path)
    for i in range(4):
        if filestat[CF_BASE + i] & CF_REARCH:
            return True
    return False

##
# this function returns all vsn which have a copy off the file
# @def getAllVSNForFile(path)
# @param path filename
# @return list of vsn as dictionary { vsn: copyno }
#    copyno in range 1..4
VSN = namedtuple('VSN','vsn copyno')
def getAllVSNForFile(path):
    vsndict = {}
    filestat = sam_stat(path)
    for i in range(4):
        if filestat[VSN_BASE + i] != '':
            vsndict[filestat[VSN_BASE + i]] = i+1
    return vsndict;
    
##
# this function returns all files which have a copy on vsn
# @def getAllFilesForVSN(path,vsn)
# @param path basedir looking for files
# @param vsn looking for files which have copies on this vsn
# @return dictionary of files:copyno
def getAllFilesForVSN(path,vsn):
    filedict = {}
    for root, dirs, files in walk(path):
        for paths in ((join(root, name)) for name in files):
            if vsn in getAllVSNForFile(paths).keys():
                filedict[paths] = getAllVSNForFile(paths)[vsn] 
    return filedict

def getAllFilesForRearch(path,vsn):
    filelist = []
    for root, dirs, files in walk(path):
        for paths in ((join(root, name)) for name in files):
            if vsn in getAllVSNForFile(paths).keys() and willRearch(paths,getAllVSNForFile(paths)[vsn]):
                    filelist.append(paths)
    return filelist

# catalog functions
def occupiedSlot(slot):
    return (slot.status & CES_OCCUPIED) != 0

def fullVol(slot):
    return ((slot.status & CES_ARCHFULL) != 0) or (slot.space == 0)

def samVol(slot):
    return not ((slot.status & CES_NONSAM) != 0)

