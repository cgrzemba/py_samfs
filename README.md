py_samfs

Python Binding for Oracle<-Sun<-LSC SamFS API
========

This Python Binding is created by SWIG (http://www.swig.org) on top of the C-API.
Swig for Solaris is available form http://www.opencsw.org.

build:

    $ swig -python samapi.i
    $ python setup.py build_ext 
    $ sudo python setup.py install


The return code 0 = ok, other = error, are mapped to python exception. 
Not all function are implemented yet, see samfs.i

For usage see examples in path test.
