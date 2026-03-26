build:
	docker build --platform=linux/amd64 -t asm32-dev .

run:
	docker run --platform=linux/amd64 -it --rm -v "$$PWD":/workspace asm32-dev

setup:
	setup:
		mkdir -p include
		curl -o include/io.inc https://raw.githubusercontent.com/Dman95/SASM/master/BSD/share/sasm/include/io.inc
		mkdir -p common
		printf '#include <stdio.h>\n\nFILE *get_stdin(void) { return stdin; }\nFILE *get_stdout(void) { return stdout; }\n' > common/io_helper.c
