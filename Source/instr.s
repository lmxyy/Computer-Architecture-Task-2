.org 0x0
 	.global _start
_start:

	jal x0, label2
	jal x0, label1
label2:	
	ori x15, x0, 80
	ori x16, x0, 90
	
label1:	
	ori x17, x0, 0x0
	ori x1, x0, 0x80      #x1 = h00000080
	sll x1, x1, 24	      #x1 = h80000000
	ori x1, x1, 0x10      #x1 = h80000010

	ori x2, x0, 0x80	#x2 = h00000080
	sll x2, x2, 24		#x2 = h80000000
	ori x2, x2, 0x1		#x2 = h80000001

	ori x3, x0, 0x0		#x3 = h00000000
	add x3, x1, x2		#x3 = h00000011
	ori x3, x0, 0x0		#x3 = h00000000

	sub x3, x1, x3		#x3 = h80000010
	sub x3, x3, x2		#x3 = h0000000f

	addi x3, x3, 2		#x3 = h00000011
	ori x3, x0, 0x0		#x3 = h00000000

	ori x1, x0, 0x7ff	#x1 = h000007ff
	ori x3, x0, 0xf8	#x3 = h00000008
	slli x3, x3, 8		#x3 = h0000f800
	add x1, x3, x1		#x1 = h0000ffff

	slli x1, x1, 16		#x1 = hffff0000
	slt x2, x1, x0		#x2 = h00000001
	sltu x2, x1, x0		#x2 = h00000000

	slti x2, x1, 0x7ff 	#x2 = h00000001
	sltiu x2, x1, 0x7ff	#x2 = h00000000
