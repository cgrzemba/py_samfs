
# pay attention to the VERSION numbers in setup.py, pkg/pkginfo, pkg/py_samfs.p5p
VERSION=0.2

SRC = sam
# BUILDREMOTEAPI = -DREMOTE

PYTHON = /usr/bin/python

PYVER = 2.7
PYV = $(subst .,,$(PYVER))
ARCH = $(shell uname -i)
REL = $(subst 5,2,$(shell uname -r))
SWIG_FLAGS = -v -Wall 

BUILDDIR = build/temp.solaris-$(REL)-$(ARCH)-$(PYVER)
BUILDREMOTEPY = $(shell echo $(subst -D,--,$(BUILDREMOTEAPI)) | tr A-Z a-z)
DESTDIR = /tmp/py_sam
IPSREPO = ~/samfs/samqfs/repo

%_wrap.c:	%.i
	swig -python $(SWIG_FLAGS) $(BUILDREMOTEAPI) $*.i 

all: $(SRC)api_wrap.c $(SRC)fs.py
	$(PYTHON) setup.py build_ext $(BUILDREMOTEPY)

install: 
	sudo $(PYTHON) setup.py install $(BUILDREMOTEPY)
	
svr4pkg:
	cd pkg && ./mksvr4pkg

ipspkg:
	rm -rf $(DESTDIR) && mkdir -p $(DESTDIR)
	$(PYTHON) setup.py install $(BUILDREMOTEPY) --root=$(DESTDIR)
	rm -f pkg/generated.p5m
	pkgmogrify -DPYV=${PYV} -DPYVER=${PYVER} -DVERSION=${VERSION} -O pkg/generated.p5m pkg/py_samfs.p5m
	pkgsend publish -s $(IPSREPO) -d $(DESTDIR) pkg/generated.p5m

clean:
	rm -rf build 
	rm -rf $(DESTDIR)
	rm samapi_wrap.c pkg/generated.p5m
	
show-var:
	@echo $($(ARG))
