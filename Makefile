CFLAGS  = -Wall -Wextra -Wpedantic -O3
LDLIBS  = -lm
OFILES  = ptest.o sieve210.o
TARGET  = ptest

all:    ptest

${TARGET}: ${OFILES}
	${CC} -o $@ ${OFILES} ${LDLIBS}

clean:  
	${RM} ${OFILES}

realclean distclean: clean
	${RM} ${TARGET}

