When you run the program, it grabs those eight hard-coded bytes—0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, and 0x9A—turns each one into its two-digit uppercase hex form, and prints them out on a single line separated by spaces. As soon as the last byte is printed it swaps the final space for a newline, so what you’ll see in your terminal is:
83 6A 88 DE 9A C3 54 9A
and your cursor will be sitting neatly at the start of the next line.

## Build & Run

# Assemble
nasm -f elf32 hw11translate2Ascii.asm -o hw11translate2Ascii.o

# Link
ld -m elf_i386 hw11translate2Ascii.o -o hw11translate2Ascii

# Execute
./hw11translate2Ascii
