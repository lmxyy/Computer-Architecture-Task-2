.org 0x0
 	.global _start
_start:
	ori x1, x0, 0x80      #x1 = h00000080
	sll x1, x1, 24	      #x1 = h80000000
	ori x1, x1, 0x10     #x1 = h80000010

	ori x2, x0, 0x80	#x2 = h00000080
	sll x2, x2, 24		#x2 = h80000000
	ori x2, x2, 0x1		#x2 = h80000001

	ori x3, x0, 0x0		#x3 = h00000000
	## add x3, x1, x2		#
