compile:
	 CC="$(CC)" CFLAGS="-Os -pipe -mips32r2 -mtune=mips32r2" shc -r -B -f fdi.sh
	 mv *.x fdi && rm *.x.c
clean:
	rm -rf *.x *.c *.o *.c fdi
