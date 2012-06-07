#!/usr/sbin/dtrace  -s

#pragma D option flowindent

fbt:samfs::entry 
/ execname == "python" /
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

/*
syscall::ioctl:entry
/execname == "python" && guard++ == 0/
{
        self->traceme = 1;
        printf("fd: %d", arg0);
}

fbt:::
/self->traceme/
{}

syscall::ioctl:return
/self->traceme/
{
        self->traceme = 0;
        exit(0);
}
*/
