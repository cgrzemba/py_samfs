# This file was automatically generated by SWIG (http://www.swig.org).
# Version 2.0.9
#
# Do not make changes to this file unless you know what you are doing--modify
# the SWIG interface file instead.



from sys import version_info
if version_info >= (2,6,0):
    def swig_import_helper():
        from os.path import dirname
        import imp
        fp = None
        try:
            fp, pathname, description = imp.find_module('_samapi_rpc', [dirname(__file__)])
        except ImportError:
            import _samapi_rpc
            return _samapi_rpc
        if fp is not None:
            try:
                _mod = imp.load_module('_samapi_rpc', fp, pathname, description)
            finally:
                fp.close()
            return _mod
    _samapi_rpc = swig_import_helper()
    del swig_import_helper
else:
    import _samapi_rpc
del version_info
try:
    _swig_property = property
except NameError:
    pass # Python < 2.2 doesn't have 'property'.
def _swig_setattr_nondynamic(self,class_type,name,value,static=1):
    if (name == "thisown"): return self.this.own(value)
    if (name == "this"):
        if type(value).__name__ == 'SwigPyObject':
            self.__dict__[name] = value
            return
    method = class_type.__swig_setmethods__.get(name,None)
    if method: return method(self,value)
    if (not static):
        self.__dict__[name] = value
    else:
        raise AttributeError("You cannot add attributes to %s" % self)

def _swig_setattr(self,class_type,name,value):
    return _swig_setattr_nondynamic(self,class_type,name,value,0)

def _swig_getattr(self,class_type,name):
    if (name == "thisown"): return self.this.own()
    method = class_type.__swig_getmethods__.get(name,None)
    if method: return method(self)
    raise AttributeError(name)

def _swig_repr(self):
    try: strthis = "proxy of " + self.this.__repr__()
    except: strthis = ""
    return "<%s.%s; %s >" % (self.__class__.__module__, self.__class__.__name__, strthis,)

try:
    _object = object
    _newclass = 1
except AttributeError:
    class _object : pass
    _newclass = 0



def sam_attrtoa(*args):
  return _samapi_rpc.sam_attrtoa(*args)
sam_attrtoa = _samapi_rpc.sam_attrtoa

def sam_request(*args):
  args.__add__((args[len(args)-1],))


  return _samapi_rpc.sam_request(*args)

def sam_stat(*args):
  return _samapi_rpc.sam_stat(*args)
sam_stat = _samapi_rpc.sam_stat

def sam_lstat(*args):
  return _samapi_rpc.sam_lstat(*args)
sam_lstat = _samapi_rpc.sam_lstat

def sam_archive(*args):
  return _samapi_rpc.sam_archive(*args)
sam_archive = _samapi_rpc.sam_archive

def sam_stage(*args):
  return _samapi_rpc.sam_stage(*args)
sam_stage = _samapi_rpc.sam_stage

def sam_release(*args):
  return _samapi_rpc.sam_release(*args)
sam_release = _samapi_rpc.sam_release

def sam_segment(*args):
  return _samapi_rpc.sam_segment(*args)
sam_segment = _samapi_rpc.sam_segment

def sam_setfa(*args):
  return _samapi_rpc.sam_setfa(*args)
sam_setfa = _samapi_rpc.sam_setfa
# This file is compatible with both classic and new-style classes.

cvar = _samapi_rpc.cvar

