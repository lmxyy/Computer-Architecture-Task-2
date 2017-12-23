# if [$# -eq 0]; then
#     riscv32-unknown-elf-as -o instr.o -march=rv32i instr.s 
#     riscv32-unknown-elf-ld instr.o -o instr.om
#     riscv32-unknown-elf-objcopy -O binary instr.om instr.bin
#     ../Tools/Bin_to_Text instr.bin > instr.data
#     cat instr.data
#     rm $1.o $1.om $1.bin    
# elif [$# -eq 1]; then
    riscv32-unknown-elf-as -o $1.o -march=rv32i $1.s 
    riscv32-unknown-elf-ld $1.o -o $1.om
    riscv32-unknown-elf-objcopy -O binary $1.om $1.bin
    ../Tools/Bin_to_Text $1.bin > instr.data
    cat instr.data
    rm $1.o $1.om $1.bin
# else
#     echo "Please please less than 2 paraments!"
# fi
