from time import strftime, localtime
from samfs import *;

begin_slot = 0
end_slot = 5

handle, cat = sam_opencat('/var/opt/SUNWsamfs/catalog/sl500')
ent = sam_getcatalog(handle, begin_slot, end_slot)
sam_closecat(handle)

print "Catalog \n\tVersion: %s\n\tSlots: %d\n\tAudit Time: %s" % (cat.version, cat.count, strftime("%a, %d %b %Y %H:%M:%S +0000", localtime(cat.audit_time)))

print "# Slot VSN    Barcode  Type PTOC   Access Capacity  Space     Status     Mod time Mnt time"

for i in range(begin_slot, end_slot):
    print "%6d %6s %6s %4s %6d %8d %9d %9d 0x%8x %8d %8d" % (
        i, ent[i].vsn, ent[i].bar_code, ent[i].media, ent[i].ptoc_fwa, ent[i].access, 
        ent[i].capacity, ent[i].space, ent[i].status, ent[i].modification_time, ent[i].mount_time)
