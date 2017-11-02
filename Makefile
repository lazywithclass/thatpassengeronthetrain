include ./PcapPlusPlus/Dist/mk/PcapPlusPlus.mk

all:
	g++ -std=c++11 $(PCAPPP_INCLUDES) -c -o dist/main.o main.cpp
	g++ $(PCAPPP_LIBS_DIR) -o dist/tpott dist/main.o $(PCAPPP_LIBS)

clean:
	-@rm dist/*  2>/dev/null || true
