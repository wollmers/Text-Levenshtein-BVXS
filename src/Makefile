
CC = cc
#CFLAGS = -std=c99 -pedantic -Wall -O9
#CFLAGS = -std=c99 -pedantic -Wall -Ofast
CFLAGS = -std=c99 -pedantic -Wall -O3
# -funsigned-char make char unsigned
#CFLAGS = -std=c11 -mpopcnt -pedantic -Wall -O1
#CFLAGS =  -Wall -O3
#CFLAGS =  -Wall -O9
#CFLAGS = clang -O3  -funroll-loops

CCPP = g++
#CPPFLAGS = -std=c++11 -Wall -g -finput-charset=utf-8


all: levtest levtestcpp

clean:
	rm -rf *.o levtest levtestcpp

rebuild: clean all
 

lcstest.o: 
	$(CC) $(CFLAGS) -c -o levtest.o levtest.c 

levtest: levtest.o 
	$(CC) $(CFLAGS) -o levtest levtest.o

levtestcpp.o: 
	$(CCPP) -std=c++11 -Wall -g -finput-charset=utf-8 -O3 -c -o levtestcpp.o levtestcpp.cpp

levtestcpp: levtestcpp.o 
	$(CCPP) -std=c++11 -Wall -g -finput-charset=utf-8 -O3 -o levtestcpp levtestcpp.o


	
