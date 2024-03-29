CXXFLAGS=-O3 -funroll-loops -Wall -D_FORTIFY_SOURCE=2 -g -Wno-pointer-sign -DVERSION=1  -Wno-variadic-macros
CLANG_CFL=$(shell llvm-config-14 --cxxflags) -Wl,-znodelete -fno-rtti -fpic $(CXXFLAGS)
CLANG_LFL=$(shell llvm-config-14 --ldflags --libs)

CLANG=clang++-14
PASS=function.so
#PASS_SRC=functions_analysis.cpp
#PASS_SRC=funcAnalysis.cpp
PASS_SRC=funcCalls.cpp

example: example.rewritten.o
	$(CLANG) -o $@ $^

%.o: %.cpp
	$(CLANG) -g -c -o $@ $<
	
%.rewritten.o: %.cpp $(PASS)
	$(CLANG) -g -fno-discard-value-names -c -o $@ -flegacy-pass-manager -g -Xclang -load -Xclang $(PASS) $<

$(PASS): $(PASS_SRC)
	$(CLANG) $(CLANG_CFL) -g -shared $< -o $@
