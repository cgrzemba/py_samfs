py_samfs

Python Binding for Oracle<-Sun<-LSC SamFS API
========

This Python Binding is created by SWIG (http://www.swig.org) on top of the C-API.
Swig for Solaris is available form http://www.opencsw.org.

build:

define REMOTE and use --remote option for build RPC API

    $ swig -python [-DREMOTE] samapi.i  
    $ python setup.py build_ext [--remote]  
    $ sudo python setup.py install [--remote]  


The return code 0 = ok, other = error, are mapped to python exception. 
Not all function are implemented yet, see samfs.i

For use the RPC API you have to set SAMHOST environment variable,  
for config SAM RPC see:

    $ man intro_libsam  
