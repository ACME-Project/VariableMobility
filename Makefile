# Makefile
# GNU makefile for example grain growth code
# Questions/comments to gruberja@gmail.com (Jason Gruber)
# Modified for CCNI by Trevor Keller

# includes
incdir = $(MMSP_PATH)/include
utildir = $(MMSP_UTIL)
algodir = $(MMSP_PATH)/algorithms

# compilers/flags
compiler = g++ -O3 -Wall
pcompiler = mpic++ -O3 -Wall
ccompiler = mpic++ -O3 -Wall
flags = -I$(incdir) -I$(algodir) -I$(utildir)

# GNU compiler for AMOS
#BG_GNU = /bgsys/drivers/ppcfloor/comm/gcc
#BG_INC = -I$(BG_GNU)/include
#BG_LIB = -L$(BG_GNU)/lib
#qcompiler = $(BG_GNU)/bin/mpic++ -O3 -Wall

# IBM compiler for AMOS
BG_XL = /bgsys/drivers/ppcfloor/comm/xl
BG_INC = -I$(BG_XL)/include
BG_LIB = -L$(BG_XL)/lib
qcompiler = $(BG_XL)/bin/mpixlcxx_r -O3 -qflag=w -qstrict -qmaxmem=-1
#qcompiler = $(BG_XL)/bin/mpixlcxx_r -O2 -g -qflag=w -qstrict -qmaxmem=-1 -qreport
#qcompiler = $(BG_XL)/bin/mpixlcxx_r -O5 -qflag=w -qstrict -qprefetch=aggressive -qmaxmem=-1 -qhot=level=1 -qreport -qsimd=noauto
#after https://wiki.alcf.anl.gov/parts/index.php/Blue_Gene/Q#XL
#qcompiler = $(BG_XL)/bin/mpixlcxx_r -O3 -qflag=w -qstrict -qsimd=auto -qhot=level=1 -qprefetch -qunroll=yes -qreport -qnoipa
#after Carothers
#qcompiler = $(BG_XL)/bin/mpixlcxx_r -O3 -qflag=w -qstrict -qprefetch=aggressive -qmaxmem=-1 -qhot=level=1 -qsimd=noauto -qreport

qflags = $(BG_INC) $(BG_LIB) $(flags) -I/bgsys/apps/CCNI/zlib/zlib-1.2.7/include -L/bgsys/apps/CCNI/zlib/zlib-1.2.7/lib
#qflags = $(BG_INC) $(BG_LIB) $(flags) $(CFLAGS) $(LDFLAGS)

# dependencies
core = $(incdir)/MMSP.main.hpp \
       $(incdir)/MMSP.utility.hpp \
       $(incdir)/MMSP.grid.hpp \
       $(incdir)/MMSP.sparse.hpp \
       $(utildir)/tessellate.hpp

# the program
graingrowth.out: graingrowth.cpp anisotropy.hpp $(core)
	$(compiler) $(flags) $< -o $@ -lz

parallel: graingrowth.cpp anisotropy.hpp $(core)
	$(pcompiler) $(flags) -include mpi.h $< -o parallel_GG.out -lz

sparallel: singraingrowth.cpp anisotropy.hpp $(core)
	$(pcompiler) $(flags) -include mpi.h $< -o parallel_GG.out -lz

bgq: graingrowth.cpp anisotropy.hpp $(core)
	$(qcompiler) -DBGQ $(qflags) $< -o q_GG.out -lz

bgqs: singraingrowth.cpp anisotropy.hpp $(core)
	$(qcompiler) -DBGQ $(qflags) $< -o q_GGs.out -lz

wrongendian: wrongendian.cpp
	$(compiler) -pthread $< -o $@.out -lz

mmsp2png: mmsp2png.cpp $(core) /usr/include/IL/devil_cpp_wrapper.hpp
	$(compiler) $(flags) -I /usr/include/IL -include il.h $< -o $@ -lz -lIL -lILU -lILUT

clean:
	rm -rf graingrowth.out parallel_GG.out q_GG.out q_GGs.out
