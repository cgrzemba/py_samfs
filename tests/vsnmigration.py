from subprocess import *
from samfs import *

vsn = 'li:D10001'
path = '/samtest'

# schedule volume for recycling
for f in getAllFilesForVSN(path,vsn).keys():
    sam_rearch(f,'2','o','c%d' % getAllFilesForVSN(path,vsn)[f])

# trigger archiver for rewrite the obsoletd copies
call(['/opt/SUNWsamfs/sbin/samcmd','arrun'])

# wait for rearch process to finish
while len(getAllFilesForRearch(path,vsn)) > 0:
    sleep(60)

# rerun recycler will finaly recycle the volume
call(['/opt/SUNWsamfs/sbin/sam-recycler'])
