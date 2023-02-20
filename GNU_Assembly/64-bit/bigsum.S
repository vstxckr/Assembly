# compile: gcc -m64 -Wall -e_start -nostdlib -o bigsum bigsum.S
# run: ./bigsum
# input format:
# [...]arg1 [...]arg2[...]<enter>

# output:
# <result>
.section .bss
.lcomm buffer, 4000000
.lcomm Output, 2000000

.section .text
.global _start

ReadLine:
	mov 	$0x0, %rax
	mov 	$0x0, %rdi
	mov 	$1000000, %rdx
	syscall
	ret

LastAddr: # rdi (rdi)
	xor 	%rcx, %rcx

	.LA_pre:
	cmpb 	$0x30, (%rdi)
	jl 		.LA_pre_prog
	cmpb 	$0x39, (%rdi)
	jg 		.LA_pre_prog
		mov 	%rdi, %r8
		jmp 	.NL_start
	.LA_pre_prog:
	inc 	%rdi
	jmp 	.LA_pre

	.NL_start:
	cmpb 	$0xa, (%rdi, %rcx)
	je 		.NL_finish
	cmpb 	$0x20, (%rdi, %rcx)
	je 		.NL_finish
		inc 	%rcx
		jmp 	.NL_start

	.NL_finish:
	dec 	%rcx
	add 	%rcx, %rdi
	ret

BigSum: # (rax, rdi, rsi, rdx, rcx) 		# rax[] ; rdi[0..rcx] ; rdx[0..rcx] ;
	xor 	%rbx, %rbx
	xor 	%r8, %r8
	xor 	%r9, %r9

	.BS_start:
	dec 	%rax 
	dec 	%rsi 		 		# 	rax--; rsi--; rcx--;
	dec 	%rcx

	cmp 	$-0x1, %rcx  		# if (rcx != -1) {
	je 		.BS_end_rdx 

	movb 	(%rdi, %rsi), %r8b 	# 	r8 = rdi[rsi];
	movb 	(%rdx, %rcx), %r9b 	# 	r9 = rdx[rcx];
	
	sub 	$0x30, %r8 			# 	r8 -= 48;
	sub 	$0x30, %r9 			# 	r9 -= 48;
	
	add 	%r9, %r8 			# 	r8 += r9;
	add 	%rbx, %r8 			# 	r8 += rbx;

	cmp 	$10, %r8 			# 	if (r8 < 10)
	jge 	.BS_carry 			# 	{
		add 	$0x30, %r8 		# 		r8 += 48;
		movb 	%r8b, (%rax) 	# 		*rax = r8
		mov 	$0, %rbx 		# 		rbx = 0;
		jmp 	.BS_start 		# 	}
	.BS_carry: 					# 	else {
	sub 	$10, %r8 			# 		r8 -= 10;
	mov 	$1, %rbx 			# 		rbx = 1;

	add 	$0x30, %r8 			# 		r8 += 48;
	movb 	%r8b, (%rax) 		# 		*rax = r8;
	jmp 	.BS_start 			# 	}
								# }
	.BS_end_rdx:
	cmp 	$-1, %rsi  			
	jne 	.BS_tail
		cmp 	$0x1, %rbx
		jne 	.BS_done_checking
			movb 	$0x31, (%rax)
			dec 	%rax
			jmp 	.BS_Last
		.BS_done_checking:
		jmp 	.BS_Last

	.BS_tail:
	cmp 	$-0x1, %rsi
	je 		.BS_done
		movb 	(%rdi, %rsi), %r8b
		sub 	$0x30, %r8
		add 	%rbx, %r8

		cmp 	$10, %r8
		jge 	.BS_tail_carry
			add 	$0x30, %r8
			xor 	%rbx, %rbx
			movb 	%r8b, (%rax)
			jmp 	.BS_tail_next
		.BS_tail_carry:
		sub 	$10, %r8
		mov 	$1, %rbx
		add 	$0x30, %r8
		movb 	%r8b, (%rax)
	.BS_tail_next:
	dec 	%rax
	dec 	%rsi
	cmp 	$-0x1, %rsi
	je 		.BS_done
		jmp 	.BS_tail
	.BS_done:
	cmp 	$0x1, %rbx

	jne 		.BS_Last
	movb 	$0x31, (%rax)
	dec 	%rax
	.BS_Last:

	inc 	%rax
	ret


_start:
	leaq 	buffer(%rip), %rsi
	call 	ReadLine

	mov 	%rsi, %rdi
	call 	LastAddr

	add 	$2, %rdi
	push 	%r8
	push 	%rcx

	call 	LastAddr
	pop 	%rbx

	cmp 	%rbx, %rcx
	jle 	.Less
		pop 	%rdx
		mov 	%rcx, %rsi
		mov 	%rbx, %rcx
		mov 	%r8, %rdi
		jmp 	.Done
	.Less:
		mov 	%r8, %rdx
		pop 	%rdi
		mov 	%rbx, %rsi

	.Done:

	leaq 	Output(%rip), %rax

	add 	$2000000, %rax
	push 	%rax
	movb 	$0x00, (%rax)
	dec 	%rax
	movb 	$0x0a, (%rax)
	dec 	%rax

	inc 	%rsi
	inc 	%rcx
	call 	BigSum
	
	pop 	%rdx
	sub 	%rax, %rdx
	inc 	%rdx
	mov 	%rax, %rsi
	mov 	$0x1, %rax
	mov 	$0x1, %rdi
	syscall

	mov 	$0x3c, %rax
	mov 	$0x0, %rdi
	syscall
