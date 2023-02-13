# This code only works on OJ that deploys by DMOJ 
# problem: https://oj.lequydon.net/problem/binarygen
# gcc -m64 -Wall, -e_start -nostdlib -o binary_string binary_string.S
.section .bss
.lcomm 		input, 1000000
.section .data
Wrong: 		.ascii "-1\n"
.section .text

.global _start

ReadLine:
	mov 	$0x0, %rax
	mov 	$0x0, %rdi
	mov 	$1000007, %rdx
	syscall
	ret

Atoi: 	# rax(rdi)
	push 	%rbp
	mov 	%rsp, %rbp

	xor 	%rcx, %rcx
	xor 	%rax, %rax
	xor 	%rsi, %rsi
	mov 	$0xa, %rbx

	.Ai_pre:
	cmpq 	$0x20, (%rdi, %rcx)
	jne 	.Ai_start
		inc 	%rcx
		jmp 	.Ai_pre
	
	.Ai_start:
	movb 	(%rdi, %rcx), %sil
	cmp 	$0xa, %sil
	je 		.Ai_finish
	cmp 	$0x20, %sil
	je 		.Ai_finish

		xor 	%rdx, %rdx
		mul 	%rbx
		sub 	$0x30, %sil
		add 	%rsi, %rax
		inc 	%rcx
		jmp 	.Ai_start

	.Ai_finish:
	add 	%rcx, %rdi
	inc 	%rdi

	mov 	%rbp, %rsp
	pop 	%rbp
	ret

Solve: # void ( rax, rdi )
	push 	%rax
	.S_start:
	cmpb 	$0x30, (%rdi, %rax)	
	je 		.S_change
	cmp 	$0, %rax
	je 		.S_wrong
		movb 	$0x30, (%rdi, %rax)
		dec 	%rax
		jmp 	.S_start
	
	.S_wrong:
	mov 	$0x1, %rax
	mov 	$0x1, %rdi
	leaq 	Wrong(%rip), %rsi
	mov 	$3, %rdx
	syscall
	add 	$0x8, %rsp
	jmp 	.S_done

	.S_change:
	movb	$0x31, (%rdi, %rax)

	mov 	$0x1, %rax
	mov 	%rdi, %rsi
	mov 	$0x1, %rdi
	pop 	%rdx
	syscall

	.S_done:

	ret

_start:
	leaq 	input(%rip), %rsi
	call 	ReadLine

	mov 	%rsi, %rdi
	call 	Atoi
	
	call 	Solve

	mov 	$0x3c, %rax
	mov 	$0x0, %rdi
	syscall
