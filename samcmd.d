#!/usr/sbin/dtrace  -s

#pragma D option flowindent

fbt:samfs::entry 
{ 
	printf("\n%s",execname); 
        self->traceme = 1;
}

fbt:::
/self->traceme/
{}

fbt:samfs::return
/self->traceme/
{
        self->traceme = 0;
}

