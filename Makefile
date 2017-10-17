include ./PcapPlusPlus/Dist/mk/PcapPlusPlus.mk

all:
	g++ $(PCAPPP_INCLUDES) -c -o main.o main.cpp
	g++ $(PCAPPP_LIBS_DIR) -static-libstdc++ -o tpott main.o $(PCAPPP_LIBS)

clean:
	-@rm main.o  2>/dev/null || true
	-@rm tpott  2>/dev/null || true
