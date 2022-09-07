CC = riscv64-unknown-elf-gcc
CFLAGS = -I./include -nostdlib -fno-builtin -Wall -Wextra

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 8 -machine virt -bios none

IFLAGS = -npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1

OBJS = $(shell find src/ -name "*.[Sc]" | sed -e "s/.../obj/" -e "s/.$$/o/")

.DEFAULT_GOAL := all
all: os.elf

os.elf: $(OBJS)
	$(CC) $(CFLAGS) -T virt.lds -o os.elf $^

obj/%.o : src/%.S
	$(CC) $(CFLAGS) -c -o $@ $<

obj/%.o : src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

run: os.elf
	$(QEMU) $(QFLAGS) -kernel os.elf

.PHONY : fmt
fmt:
	find src/ -name "*.c" | xargs indent $(IFLAGS)
	find src/ -name "*~" | xargs rm -f
	find include/ -name "*.h" | xargs indent $(IFLAGS)
	find include/ -name "*~" | xargs rm -f

.PHONY : clean
clean:
	rm -f obj/* os.elf
