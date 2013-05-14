from distutils.core import setup, Extension

libdirs= ['/opt/SUNWsamfs/lib']
incdirs = ['/opt/SUNWsamfs/include']
libs = ['sam','samcat','samapi','samfs']

MOD = 'samapi'
setup(name=MOD, 
    version = '0.1',
    author = "Carsten Grzemba",
    description = """SamFS API created with SWIG""",
    py_modules = [MOD,'samfs'],
    ext_modules=[Extension('_'+MOD ,sources=['samapi_wrap.c'],
      library_dirs=libdirs,
      include_dirs=incdirs,
      libraries=libs,
      extra_compile_args=['-g'],
      extra_link_args = ['-R/opt/SUNWsamfs/lib','-R/opt/csw/lib']
    )]
) 
