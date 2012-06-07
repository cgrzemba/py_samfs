py_samfs

Python Binding for Oracle<-Sun<-LSC SamFS API

This Python Binding is created by SWIG on top of the C-API

build:

$ swig -python samapi.i 
$ python setup.py build_ext 
$ python setup.py install
