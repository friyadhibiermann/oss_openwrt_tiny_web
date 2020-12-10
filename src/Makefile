compile:
	 CC="$(CC)" CFLAGS="$(TARGET_CFLAGS)" shc -r -B -oss
	 CC="$(CC)" CFLAGS="$(TARGET_CFLAGS)" shc -r -B -f html
	 mv oss.x oss && mv html.x html && rm *.x.c
clean:
	rm -rf *.x *.c *.o *.c oss html
