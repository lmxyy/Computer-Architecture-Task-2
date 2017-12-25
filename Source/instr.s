	.org 0x0
 	.global _start
_start:
	ori x1, x0, 0x1		#x1 = 0x00000001
	jal x0, label1
	ori x1, x0, 0x11
	ori x1, x0, 0x12
	
label1:	
	ori x1, x0, 0x002
	ori x1, x0, 0x003
	jal x31, label2		#x31 = 0x0000001c
	
	ori x1, x0, 0x005
	ori x1, x0, 0x006
	
label2:
label3:	
	ori x31, x0, 0x2c

	ori x15, x0, 0x111
	ori x16, x0, 0x112
	jal x0, label3
	
	
	
	
