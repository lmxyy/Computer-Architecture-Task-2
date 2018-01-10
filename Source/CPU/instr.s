.org 0x0
.global _start

_start:
	lui x2, 0x10000
	jal x1, tag
	ori x5, x0, 0x111
	ori x5, x0, 0x112
	ori x5, x0, 0x113
	ori x5, x0, 0x114
	ori x5, x0, 0x115
	ori x5, x0, 0x116
tag:	
	lui x15, 0x1
	addi x15, x15, 0xc4
	addi x14, x0, 0x48
## label1:	
	sb x14, 0x104(x0)
	addi x15, x15, 1
	lh x14, 0(x15)
