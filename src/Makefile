compile:
	 CC="$(CC)" CFLAGS="$(TARGET_CFLAGS)" shc -r -B -f fdi.sh
	 CC="$(CC)" CFLAGS="$(TARGET_CFLAGS)" shc -r -B -f html
	 mv fdi.sh.x fdi && mv html.x html && rm *.x.c
clean:
	rm -rf *.x *.c *.o *.c fdi html
