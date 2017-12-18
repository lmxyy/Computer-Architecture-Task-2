riscv32-unknown-elf-as -o $1.o -march=rv32i $1.s 
riscv32-unknown-elf-ld $1.o -o $1.om
riscv32-unknown-elf-objcopy -O verilog $1.om $1.data
cat $1.data
rm $1.o $1.om
