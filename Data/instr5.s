.org 0x0
.global _start

_start:
	lui x3, 0x80000		# (1) x3 = 0x80000000
	ori x1, x0, 0x1		# (1) x1 = 0x00000001
	j s1				# jump to s1

1:
	ori x1, x0, 0x111
	ori x1, x0, 0x110

s1:
	ori x1, x0, 0x002	# (2) x1 = 0x00000002
	jal x5, s2			# jump to s2 and set x5 = 0x1c

	ori x1, x0, 0x110
	ori x1, x0, 0x111
	bne x1, x0, s3		
	ori x1, x0, 0x110
	ori x1, x0, 0x111

s2:
	ori x1, x0, 0x003	# (3) x1 = 0x00000003
	or x2, x5, x0		# (3) x1 = 0x0000001c
	beq x3, x3, s3		# x3 == x3, jump to s3

	ori x1, x0, 0x111
	ori x1, x0, 0x110

s4:
	ori x1, x0, 0x005	# (5) x1 = 0x00000005
	bge x3, x1, s3		# (5) s3 < 0, not jump
	or x1, x0, 0x006	# (6) x1 = 0x00000006
	bgeu x3, x1, s5		# (6) x3 > 0, jump to s5

bad:
	ori x1, x0, 0x111

s7:
	ori x1, x0, 0x010	# (10) x1 = 0x00000010
	bne x1, x3, s8		# (10) x1 != x3, jump to s8

s6:
	ori x1, x0, 0x008	# (8) x1 = 0x00000008
	blt x1, x0, bad		# (8) x1 > 0, not jump
	ori x1, x0, 0x009	# (9) x1 = 0x00000009
	bltu x1, x3, s7		# (9) x1 < x3 jump to s7

s5:
	ori x1, x0, 0x007	# (7) x1 = 0x00000007
	blt x3, x1, s6		# (7) x3 < 0, jump to s6


s3:
	ori x1, x0, 0x004	# (4) x1 = 0x00000004
	bge	x1, x0, s4		# if x1 >= x0 then s4




s8:
	ori x1, x0, 0x011	# (11) x1 = 0x00000011
	bne x1, x1, bad		# (11) x1 = x1, not jump
	ori x1, x0, 0x012	# (12) x1 = 0x00000012

	ori x3, x0, 0x014	# (12) x3 = 0x00000014

_loop1:					# for x1 = 0x12 to 0x14
	addi x1, x1, 0x1	# x1++
	blt x1, x3, _loop1
						# x1 = 0x00000014
	srli x3, x1, 0x1	# x3 = x1/2 =0x0000000a

_loop2: 				# for x1 = 0x14 to -0x0a
	sub x1, x1, x3		# x1 -= x3
	bge x1, x0, _loop2
# x1 = 0xfffffff6
	nop
	nop
