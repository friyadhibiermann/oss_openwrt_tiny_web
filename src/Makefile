compile:
	CC="$(CC)" CFLAGS="$(CFLAGS)" shc -r -B -f oss.sh
	mv oss.sh.x oss
	openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout uhttpd.key \
	-out uhttpd.crt -subj "/C=JB/ST=BANDUNG/L=OSS/O=ONIVERSAL INDONESIA, CV/OU=ServerOpenwrt"
clean:
	rm *.c
