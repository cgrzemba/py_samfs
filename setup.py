from distutils.core import setup, Extension
import re, sys

conf_extra_compile_args  = ['-Wno-unknown-pragmas']
conf_extra_compile_args += ['-Wno-unused-but-set-variable']
conf_extra_compile_args += ['-g']

if "--remote" in sys.argv:
    MOD = 'samapi_rpc'
    libdirs = ['/opt/SUNWsamfs/client/lib']
    libs = ['samrpc','nsl']
    conf_extra_compile_args += ['-DREMOTE']
    sys.argv.remove("--remote")
else: 
    MOD = 'samapi'
    libdirs = ['/opt/SUNWsamfs/lib']
    libs = ['sam','samcat','samapi','samfs']

incdirs = ['/opt/SUNWsamfs/include']

setup(name=MOD, 
    version = '0.2',
    author = "Carsten Grzemba",
    author_email = "cgrzemba@opencsw.org",
    url='https://github.com/cgrzemba/py_samfs',
    description = "SamFS %s API created with SWIG" % 'RPC' if re.match('.*rpc',MOD) else '',
    py_modules = [MOD,re.sub('api','fs',MOD)],
    ext_modules=[Extension('_'+MOD ,sources=['samapi_wrap.c'],
      library_dirs=libdirs,
      include_dirs=incdirs,
      libraries=libs,
      extra_compile_args = conf_extra_compile_args,
      extra_link_args = ['-R%s' % ld for ld in libdirs],
    )]
) 
