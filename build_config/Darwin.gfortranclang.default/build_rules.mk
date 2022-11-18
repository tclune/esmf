# $Id$
#
# Darwin.gfortranclang.default
#

############################################################
# Default compiler setting.
#
ESMF_F90DEFAULT         = gfortran
ESMF_F90LINKERDEFAULT   = clang++
ESMF_CXXDEFAULT         = clang++
ESMF_CDEFAULT           = clang
ESMF_CPPDEFAULT         = clang -E -P -x c

ESMF_CXXCOMPILEOPTS    += -x c++ -mmacosx-version-min=10.7 -stdlib=libc++

############################################################
# Default MPI setting.
#
ifeq ($(ESMF_COMM),default)
export ESMF_COMM := mpiuni
endif

############################################################
# MPI dependent settings.
#
ifeq ($(ESMF_COMM),mpiuni)
# MPI stub library -----------------------------------------
ESMF_F90COMPILECPPFLAGS+= -DESMF_MPIUNI
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_MPIUNI
ESMF_CXXCOMPILEPATHS   += -I$(ESMF_DIR)/src/Infrastructure/stubs/mpiuni
ESMF_MPIRUNDEFAULT      = $(ESMF_DIR)/src/Infrastructure/stubs/mpiuni/mpirun
else
ifeq ($(ESMF_COMM),mpich1)
# Mpich1 ---------------------------------------------------
ESMF_F90COMPILECPPFLAGS+= -DESMF_MPICH1
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_MPICH1
ESMF_F90DEFAULT         = mpif90
ESMF_F90LINKERDEFAULT   = mpiCC
ESMF_CXXDEFAULT         = mpiCC
ESMF_CDEFAULT           = mpicc
ESMF_MPIRUNDEFAULT      = mpirun $(ESMF_MPILAUNCHOPTIONS)
ESMF_F90COMPILECPPFLAGS+= -DESMF_NO_MPI3
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_NO_MPI3
else
ifeq ($(ESMF_COMM),mpich2)
# Mpich2 ---------------------------------------------------
ESMF_F90DEFAULT         = mpif90
ESMF_F90LINKERDEFAULT   = mpicxx
ESMF_CXXDEFAULT         = mpicxx
ESMF_CDEFAULT           = mpicc
ESMF_MPIRUNDEFAULT      = mpirun $(ESMF_MPILAUNCHOPTIONS)
ESMF_MPIMPMDRUNDEFAULT  = mpiexec $(ESMF_MPILAUNCHOPTIONS)
ESMF_F90COMPILECPPFLAGS+= -DESMF_NO_MPI3
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_NO_MPI3
else
ifeq ($(ESMF_COMM),mpich)
# Mpich3 and up --------------------------------------------
ESMF_F90DEFAULT         = mpif90
ESMF_F90LINKERDEFAULT   = mpicxx
ESMF_CXXDEFAULT         = mpicxx
ESMF_CDEFAULT           = mpicc
ESMF_CXXLINKLIBS       += $(shell $(ESMF_DIR)/scripts/libs.mpich3f90)
ESMF_F90LINKLIBS       += $(shell $(ESMF_DIR)/scripts/libs.mpich3f90)
ESMF_MPIRUNDEFAULT      = mpirun $(ESMF_MPILAUNCHOPTIONS)
ESMF_MPIMPMDRUNDEFAULT  = mpiexec $(ESMF_MPILAUNCHOPTIONS)
else
ifeq ($(ESMF_COMM),mvapich2)
# Mvapich2 -------------------------------------------------
ESMF_F90DEFAULT         = mpif90
ESMF_F90LINKERDEFAULT   = mpicxx
ESMF_CXXDEFAULT         = mpicxx
ESMF_CDEFAULT           = mpicc
ESMF_MPIRUNDEFAULT      = mpirun $(ESMF_MPILAUNCHOPTIONS)
ESMF_MPIMPMDRUNDEFAULT  = mpiexec $(ESMF_MPILAUNCHOPTIONS)
else
ifeq ($(ESMF_COMM),lam)
# LAM (assumed to be built with gfortran) ------------------
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_NO_SIGUSR2
ESMF_F90DEFAULT         = mpif77
ESMF_F90LINKERDEFAULT   = mpic++
ESMF_CXXDEFAULT         = mpic++
ESMF_CDEFAULT           = mpicc
ESMF_MPIRUNDEFAULT      = mpirun $(ESMF_MPILAUNCHOPTIONS)
ESMF_MPIMPMDRUNDEFAULT  = mpiexec $(ESMF_MPILAUNCHOPTIONS)
ESMF_F90COMPILECPPFLAGS+= -DESMF_NO_MPI3
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_NO_MPI3
else
ifeq ($(ESMF_COMM),openmpi)
# OpenMPI --------------------------------------------------
ifeq ($(shell $(ESMF_DIR)/scripts/available mpifort),mpifort)
ESMF_F90DEFAULT         = mpifort
else
ESMF_F90DEFAULT         = mpif90
endif
ESMF_F90LINKERDEFAULT   = mpicxx
ESMF_CXXCOMPILECPPFLAGS+= -DESMF_NO_SIGUSR2
ESMF_F90LINKLIBS       += $(shell $(ESMF_DIR)/scripts/libs.openmpif90_forcxx $(ESMF_F90DEFAULT))
ESMF_CXXDEFAULT         = mpicxx
ESMF_CDEFAULT           = mpicc
ESMF_MPIRUNDEFAULT      = mpirun $(ESMF_MPILAUNCHOPTIONS)
ESMF_MPIMPMDRUNDEFAULT  = mpiexec $(ESMF_MPILAUNCHOPTIONS)
else
ifeq ($(ESMF_COMM),user)
# User specified flags -------------------------------------
else
$(error Invalid ESMF_COMM setting: $(ESMF_COMM))
endif
endif
endif
endif
endif
endif
endif
endif

############################################################
# Print compiler version string
#
ESMF_F90COMPILER_VERSION    = ${ESMF_F90COMPILER} -v --version
ESMF_CXXCOMPILER_VERSION    = ${ESMF_CXXCOMPILER} -v --version
ESMF_CCOMPILER_VERSION      = ${ESMF_CCOMPILER} -v --version

############################################################
# Special debug flags
#
ESMF_F90OPTFLAG_G       += -Wall -Wextra -Wconversion -Wno-unused -Wno-unused-dummy-argument -fimplicit-none -fcheck=all,no-pointer
ESMF_CXXOPTFLAG_G       += -Wall -Wextra -Wno-unused

############################################################
# Fortran symbol convention
#
ifeq ($(ESMF_FORTRANSYMBOLS),default)
ESMF_F90COMPILEOPTS       +=
ESMF_F90LINKOPTS          +=
ESMF_CPPFLAGS             += -DESMF_LOWERCASE_SINGLEUNDERSCORE
else
ifeq ($(ESMF_FORTRANSYMBOLS),lowercase_singleunderscore)
ESMF_F90COMPILEOPTS       += -fno-second-underscore
ESMF_F90LINKOPTS          += -fno-second-underscore
ESMF_CPPFLAGS             += -DESMF_LOWERCASE_SINGLEUNDERSCORE
else
ifeq ($(ESMF_FORTRANSYMBOLS),lowercase_doubleunderscore)
ESMF_F90COMPILEOPTS       += -fsecond-underscore
ESMF_F90LINKOPTS          += -fsecond-underscore
ESMF_CPPFLAGS             += -DESMF_LOWERCASE_DOUBLEUNDERSCORE
else
$(error "ESMF_FORTRANSYMBOLS = $(ESMF_FORTRANSYMBOLS)" not supported by ESMF and/or this platform)
endif
endif
endif

############################################################
# Construct the ABISTRING
#
ifeq ($(ESMF_MACHINE),x86_64)
ifeq ($(ESMF_ABI),32)
ESMF_ABISTRING := $(ESMF_MACHINE)_32
endif
ifeq ($(ESMF_ABI),64)
ESMF_ABISTRING := x86_64_small
endif
endif

############################################################
# Set memory model compiler flags according to ABISTRING
#
ifeq ($(ESMF_ABISTRING),x86_64_32)
ESMF_CXXCOMPILEOPTS       += -m32
ESMF_CXXLINKOPTS          += -m32
ESMF_F90COMPILEOPTS       += -m32
ESMF_F90LINKOPTS          += -m32
endif
ifeq ($(ESMF_ABISTRING),x86_64_small)
ESMF_CXXCOMPILEOPTS       += -m64 -mcmodel=small
ESMF_CXXLINKOPTS          += -m64 -mcmodel=small
ESMF_F90COMPILEOPTS       += -m64 -mcmodel=small
ESMF_F90LINKOPTS          += -m64 -mcmodel=small
endif
ifeq ($(ESMF_ABISTRING),x86_64_medium)
ESMF_CXXCOMPILEOPTS       += -m64 -mcmodel=medium
ESMF_CXXLINKOPTS          += -m64 -mcmodel=medium
ESMF_F90COMPILEOPTS       += -m64 -mcmodel=medium
ESMF_F90LINKOPTS          += -m64 -mcmodel=medium
endif

############################################################
# Conditionally add pthread compiler and linker flags
#
ifeq ($(ESMF_PTHREADS),ON)
ESMF_F90COMPILEOPTS += -pthread
ESMF_CXXCOMPILEOPTS += -pthread
ESMF_F90LINKOPTS    += -pthread
ESMF_CXXLINKOPTS    += -pthread
endif

############################################################
# OpenMP compiler and linker flags
#
ESMF_OPENMP=OFF

############################################################
# Need this until the file convention is fixed (then remove these two lines)
#
ESMF_F90COMPILEFREENOCPP = -ffree-form
ESMF_F90COMPILEFIXCPP    = -cpp -ffixed-form

############################################################
# Set unlimited line length limit for free format files
#
ESMF_F90COMPILEOPTS += -ffree-line-length-none

############################################################
# Trying to produce a backtrace can lead programs to hang without any useful information
# rather than aborting cleanly, so disable backtraces.
#
ESMF_F90COMPILEOPTS += -fno-backtrace

############################################################
# Set rpath syntax
#
ESMF_F90RPATHPREFIX         = -Wl,-rpath,
ESMF_CXXRPATHPREFIX         = -Wl,-rpath,
ESMF_CRPATHPREFIX           = -Wl,-rpath,

############################################################
# Determine where gfortran's libraries are located
#
ESMF_LIBGFORTRAN := $(shell $(ESMF_F90COMPILER) -print-file-name=libgfortran.dylib)
ifeq ($(ESMF_LIBSTDCXX),libgfortran.dylib)
ESMF_LIBGFORTRAN := $(shell $(ESMF_F90COMPILER) -print-file-name=libgfortran.a)
endif
ESMF_CXXLINKPATHS += -L$(dir $(ESMF_LIBGFORTRAN))
ESMF_CXXLINKRPATHS += $(ESMF_CXXRPATHPREFIX)$(dir $(ESMF_LIBGFORTRAN))
# With clang, we use a C++ linker for Fortran programs, so use the same link paths as for CXX:
ESMF_F90LINKPATHS += -L$(dir $(ESMF_LIBGFORTRAN))
ESMF_F90LINKRPATHS += $(ESMF_CXXRPATHPREFIX)$(dir $(ESMF_LIBGFORTRAN))

############################################################
# Link against libesmf.a using the C++ linker front-end
#
ESMF_CXXLINKLIBS += -lgfortran
# With clang, we use a C++ linker for Fortran programs, so use the same link libs as for CXX:
ESMF_F90LINKLIBS += -lgfortran

############################################################
# Shared library options
ESMF_SL_LIBOPTS  += -dynamiclib
# No need for "$(ESMF_F90LINKPATHS) $(ESMF_F90LINKLIBS)" in the following because they are identical to the CXX versions:
ESMF_SL_LIBLIBS  += $(ESMF_CXXLINKPATHS) $(ESMF_CXXLINKLIBS)

############################################################
# Static builds on Darwin do not support trace lib due to missing linker option
ifeq ($(ESMF_SHARED_LIB_BUILD),OFF)
ESMF_TRACE_LIB_BUILD = OFF
endif

############################################################
# Shared object options
#
ESMF_SO_F90COMPILEOPTS  = -fPIC
ESMF_SO_F90LINKOPTS     = -shared
ESMF_SO_CXXCOMPILEOPTS  = -fPIC
ESMF_SO_CXXLINKOPTS     = -shared
