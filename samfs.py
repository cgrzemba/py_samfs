from samfsapi import *


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
#      SS_SAMFS        = 0x00000800      used by sam_stat() - see above 

SS_ARCHDONE     = 0x00001000      # File has all required -  
                                        # archiving done 
#      SS_ARCHIVE_R    = 0x00002000      used by sam_stat() - see above 
SS_PARTIAL      = 0x00004000      # Partial extents are online 
SS_OFFLINE      = 0x00008000      # File is offline 

#      SS_ARCHIVED     = 0x00010000      used by sam_stat() - see above 
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

def isOffline(path):
    return (stat(path).attr & SS_OFFLINE) != 0
    
def isArchDone(path):
    return (stat(path).attr & SS_ARCHDONE) != 0

def hasCopy(path):
    return (stat(path).attr & SS_ARCHIVED) != 0

def isWorm(path):
    return (stat(path).attr & SS_WORM) != 0
