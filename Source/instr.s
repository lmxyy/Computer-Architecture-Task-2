.org 0x0
 	.global _start
_start:

	jal x1, label2
label2:	
	addi x15, x0, 80
	ori x1, x1, 0x80      #x1 = h00000084
	
