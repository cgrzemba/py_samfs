from samfs import *; 
cat = sam_opencat('/var/opt/SUNWsamfs/catalog/sl500')
ent = sam_getcatalog(cat.handle, 1, 4)
sam_closecat(cat.handle)
