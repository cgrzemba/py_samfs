
# pay attention to the VERSION numbers in setup.py, pkg/pkginfo, pkg/py_samfs.p5p
VERSION=0.2

SRC = sam
BUILDREMOTEAPI = -DREMOTE

PYTHON = /usr/bin/python

PYVER ?= 3.11
PYV = $(subst .,,$(PYVER))
MACH = $(shell uname -m).32bit
ARCH = $(shell isainfo | cut -d" " -f2)
REL = $(subst 5,2,$(shell uname -r))
SWIG_FLAGS = -v -Wall 

BUILDDIR = build/temp.solaris-$(REL)-$(MACH)-$(PYVER)
BUILDREMOTEPY = $(shell echo $(subst -D,--,$(BUILDREMOTEAPI)) | tr A-Z a-z)
BUILDPY3 = -DPY_VERSION_HEX=0x03000000
DESTDIR = /tmp/py_sam
IPSREPO = ~/samfs/samqfs/repo/$(ARCH)

%_wrap.c:	%.i
	swig -python $(SWIG_FLAGS) $(BUILDREMOTEAPI) $*.i 

all: $(SRC)api_wrap.c $(SRC)fs.py
	$(PYTHON)$(PYVER) setup.py build_ext $(BUILDREMOTEPY)

install: 
	sudo $(PYTHON)$(PYVER) setup.py install $(BUILDREMOTEPY)
	
svr4pkg:
	cd pkg && ./mksvr4pkg

ipspkg:
	rm -rf $(DESTDIR) && mkdir -p $(DESTDIR)
	$(PYTHON)$(PYVER) setup.py install $(BUILDREMOTEPY) --root=$(DESTDIR)
	rm -f pkg/generated.p5m
	pkgmogrify -DPYV=${PYV} -DPYVER=${PYVER} -DVERSION=${VERSION} -O pkg/generated.p5m pkg/py_samfs.p5m
	pkgsend publish -s $(IPSREPO) -d $(DESTDIR) pkg/generated.p5m

clean:
	rm -rf build 
	rm -rf $(DESTDIR)
	rm -f samapi_wrap.* *.pyc pkg/generated.p5m
	
show-var:
	@echo $($(ARG))
