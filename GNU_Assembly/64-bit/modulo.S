# problem: https://oj.lequydon.net/problem/mod
# gcc -m64 -Wl, -e_start -nostdlib -o modulo modulo.S
.section .text

.global _start

ReadLine: #void(void)
	mov 	$0x0, %rax
	mov 	$0x0, %rdi
	mov 	$40, %rdx
	syscall
	ret

Atoi: # rax(rdi)
	push 	%rbp
	mov 	%rsp, %rbp

	xor 	%rcx, %rcx
	xor 	%rax, %rax
	xor 	%rsi, %rsi
	mov 	$10, %rbx

	.Ai_pre:
	cmpb 	$0x20, (%rdi, %rcx)
	jne 	.Ai_start
		inc 	%rcx
		jmp 	.Ai_pre
	
	.Ai_start:
	movb 	(%rdi, %rcx), %sil

	cmp 	$0x20, %sil
	je 		.Ai_finish
	cmp 	$0xa, %sil
	je 		.Ai_finish

		mul 	%rbx
		sub 	$0x30, %sil
		add 	%rsi, %rax
		inc 	%rcx
		jmp 	.Ai_start

	.Ai_finish:

	add 	%rcx, %rdi
	
	mov 	%rbp, %rsp
	pop 	%rbp
	ret

PrintLine: #(rax)
	push 	%rbp
	mov 	%rsp, %rbp

	cmp 	$0x0, %rax
	jne 	.PL_pre
		push 	$0x0
		movb 	$0xa, (%rsp)
		dec 	%rsp
		movb 	$0x30, (%rsp)

		mov 	$0x1, %rax
		mov 	$0x1, %rdi
		mov 	%rsp, %rsi
		mov 	$0x2, %rdx
		syscall
		
		jmp 	.PL_done

	.PL_pre:
	push 	$0x0
	push 	$0x0
	push 	$0x0
	push 	$0x0

	add 	$0x16, %rsp
	movb 	$0xa, (%rsp)
	xor 	%rcx, %rcx

	mov 	$0xa, %rbx
	inc 	%rcx

	.PL_start:
	cmp 	$0x0, %rax
	je 		.PL1_start
		dec 	%rsp
		inc 	%rcx
		xor 	%rdx, %rdx
		div 	%rbx
		add 	$0x30, %rdx

		movb 	%dl, (%rsp)
		jmp 	.PL_start

	.PL1_start:
	mov 	$0x1, %rax
	mov 	$0x1, %rdi
	mov 	%rsp, %rsi
	mov 	%rcx, %rdx
	syscall
	
	.PL_done:

	mov 	%rbp, %rsp
	pop 	%rbp
	ret

_start:
	push 	%rbp
	mov 	%rsp, %rbp

	push 	$0x0 		#input %rbp - 40
	push 	$0x0
	push 	$0x0
	push 	$0x0
	push 	$0x0

	leaq 	-40(%rbp), %rsi
	call 	ReadLine

	mov 	%rsi, %rdi

	call 	Atoi
	movq 	%rax, %r9

	call 	Atoi
	movq 	%rax, %r8

	mov 	%r9, %rax

	div 	%r8
	mov 	%rdx, %rax
	call 	PrintLine

	mov 	$0x3c, %rax
	mov 	$0x0, %rdi
	syscall
