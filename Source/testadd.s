.org 0x0
 	.global _start
_start:
	ori x1, x0, 0x80      #x1 = h00000080
	ori x2, x0, 0x1      #x2 = h00000001
	add x3, x1, x2	      #x3 = h0000081
