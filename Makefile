
# pay attention to the VERSION numbers in setup.py, pkg/pkginfo, pkg/py_samfs.p5p

SRC = sam
# BUILDREMOTEAPI = -DREMOTE

PYTHON = /usr/bin/python

PYVER = 2.6
ARCH = $(shell uname -i)
REL = $(subst 5,2,$(shell uname -r))

BUILDDIR = build/temp.solaris-$(REL)-$(ARCH)-$(PYVER)
BUILDREMOTEPY = $(shell echo $(subst -D,--,$(BUILDREMOTEAPI)) | tr A-Z a-z)

%_wrap.c:	%.i
	swig -python $(BUILDREMOTEAPI) $*.i 

all: $(SRC)api_wrap.c $(SRC)fs.py
	$(PYTHON) setup.py build_ext $(BUILDREMOTEPY)

install: 
	sudo $(PYTHON) setup.py install $(BUILDREMOTEPY)
	
pkg:
	cd pkg && ./mkpkg

clean:
	rm -rf build 
	rm samapi_wrap.c
	
show-var:
	@echo $($(ARG))
