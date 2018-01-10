## Provided by Zhou Fan
.org 0x0
 	.global _start
_start:
	lui x2, 0x10000
	jal x1, tag
tag:
	addi x15, x0, 28
label:
	lb x14, 0(x15)
	sb x14, 0x104(x0)
	addi x15, x15, 1
	bne x14, x0, label
	
