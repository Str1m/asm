ASM=nasm
CC=gcc

ASMFLAGS=-f elf32 -I../include/
CFLAGS=-m32
LDFLAGS=-m32 -no-pie

TARGET=main
ASM_SRC=main.asm
ASM_OBJ=$(ASM_SRC:.asm=.o)
C_SRC=io_helper.c
C_OBJ=$(C_SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(ASM_OBJ) $(C_OBJ)
	$(CC) $(LDFLAGS) $(ASM_OBJ) $(C_OBJ) -o $(TARGET)

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) $(ASM_OBJ) $(C_OBJ)
