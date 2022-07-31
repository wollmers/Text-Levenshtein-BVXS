
CC = cc
#CFLAGS = -std=c99 -pedantic -Wall -O9
#CFLAGS = -std=c99 -pedantic -Wall -Ofast
CFLAGS = -std=c99 -pedantic -Wall -O3
#CFLAGS = -std=c11 -pedantic -Wall -O3
#CFLAGS = -std=c99 -march=native -pedantic -Wall -O3
# -funsigned-char make char unsigned
#CFLAGS = -std=c11 -mpopcnt -pedantic -Wall -O1
#CFLAGS =  -Wall -O3
#CFLAGS =  -Wall -O9
#CFLAGS = clang -O3  -funroll-loops

#LFLAGS := -lm -v
LFLAGS := -lm

AS := as
#AFLAGS := -g $(m$(erms))
AFLAGS := -g
C := stos.o 

CCPP = g++
#CPPFLAGS = -std=c++11 -Wall -g -finput-charset=utf-8


all: levtest levtestcpp levtestarr

clean:
	rm -rf *.o levtest levtestcpp levtestarr

rebuild: clean all
 

levtest.o: 
	$(CC) $(CFLAGS) -c -o levtest.o levtest.c 

levtest: levtest.o $(C)
	$(CC) $(LFLAGS) -o levtest levtest.o $(C)

lcstestarr.o: 
	$(CC) $(CFLAGS) -c -o levtestarr.o levtestarr.c
	
levtestarr: levtestarr.o 
	$(CC) $(CFLAGS) -o levtestarr levtestarr.o

levtestcpp.o: 
	$(CCPP) -std=c++11 -Wall -g -finput-charset=utf-8 -O3 -c -o levtestcpp.o levtestcpp.cpp

levtestcpp: levtestcpp.o 
	$(CCPP) -std=c++11 -Wall -g -finput-charset=utf-8 -O3 -o levtestcpp levtestcpp.o

stos.o:
	$(AS) $(AFLAGS) -o stos.o stos.s

	
