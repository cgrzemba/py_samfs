from distutils.core import setup, Extension
import platform
import re, sys

conf_extra_gcc_compile_args  = ['-Wno-unknown-pragmas']
conf_extra_gcc_compile_args += ['-Wno-unused-but-set-variable']
conf_extra_compile_args = ['-g']
# conf_extra_compile_args += conf_extra_gcc_compile_args

if platform.python_version_tuple()[0] == '3':
    if platform.uname()[4] == 'i86pc':
    	libdirsuffix = '/lib/amd64'
    elif platform.uname()[4] == 'x86_64':
        libdirsuffix = '/lib64'
    else:
    	libdirsuffix = '/lib/sparcv9'
else:
    libdirsuffix = '/lib'

# verbose is default
# sys.argv.append("--verbose")

if "--remote" in sys.argv:
    MOD = 'samapi_rpc'
    libdirs = ['/opt/SUNWsamfs/client'+libdirsuffix]
    libs = ['samrpc','nsl']
    conf_extra_compile_args += ['-DREMOTE']
    sys.argv.remove("--remote")
else: 
    MOD = 'samapi'
    libdirs = ['/opt/SUNWsamfs/lib'+libdirsuffix]
#    libs = ['sam','samcat','samapi','samfs']
    libs = ['sam','samcat','samfs']

incdirs = ['../samqfs/include/pub','../samqfs/include']

setup(name=MOD, 
    version = '5.64.4',
    author = "Carsten Grzemba",
    author_email = "cgrzemba@opencsw.org",
    url='https://github.com/cgrzemba/py_samfs',
    description = "SamFS %s API created with SWIG" % 'RPC' if re.match('.*rpc',MOD) else '',
    py_modules = [MOD,re.sub('api','fs',MOD)],
    ext_modules=[Extension('_'+MOD ,sources=['samapi_wrap.c'],
      library_dirs=libdirs,
      runtime_library_dirs=libdirs,
      include_dirs=incdirs,
      libraries=libs,
      extra_compile_args = conf_extra_compile_args,
#      extra_link_args = ['-R%s' % ld for ld in libdirs],
    )]
) 
