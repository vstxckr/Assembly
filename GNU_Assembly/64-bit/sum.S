# problem: https://oj.lequydon.net/problem/tongsn10
# gcc -m64 -Wl,-e_start -nostdlib -o sum sum.S
.section .bss

.lcomm inp_1 , 20

.section .text
.global _start

ReadLine: # (rsi)
	push 	%rax
	push 	%rdi
	push 	%rdx
	
	mov 	$0x0, %rax
	mov 	$0x0, %rdi
	mov 	$0x14, %rdx
	syscall

	pop 	%rdx
	pop 	%rdi
	pop 	%rax
	ret

Atoi: # rax (rdi)
	push 	%rbp
	mov 	%rsp, %rbp

	mov 	$0xa, %rbx
	xor 	%rax, %rax
	xor 	%rcx, %rcx

	.Ai_start:

	xor 	%rsi, %rsi
	movb 	(%rdi, %rcx), %sil

	cmp 	$0xa, %sil
	je 		.Ai_finish
		sub 	$0x30, %sil
		mul 	%rbx
		add 	%rsi, %rax
		inc 	%rcx
		jmp 	.Ai_start

	.Ai_finish:

	mov 	%rbp, %rsp
	pop 	%rbp
	ret

Printline: # void (rax)
	push 	%rbp
	mov 	%rsp, %rbp

	mov 	$10, %rbx
	push 	$0x0
	push 	$0xa

	.PS_start:
	xor 	%rdx, %rdx
	cmp 	$0, %rax
	je 		.PS_finish
		div 	%rbx
		add 	$0x30, %rdx
		push 	%rdx
		jmp 	.PS_start
		
	.PS_finish:
	cmpq 	$0x0, (%rsp)
	je 		.done
		mov 	$0x1, %rax
		mov 	$0x1, %rdi
		mov 	%rsp, %rsi
		mov 	$0x1, %rdx
		syscall
		add 	$0x8, %rsp
		jmp 	.PS_finish
	.done:

	add 	$0x8, %rsp
	
	mov 	%rbp, %rsp
	pop 	%rbp
	ret
	
Solve: 	# rax (rdi)
	xor 	%rcx, %rcx
	xor 	%rbx, %rbx
	xor 	%r9, %r9

	inc 	%r9
	inc 	%rcx
	inc 	%rdi

	.S_start:
	cmp 	%rdi, %rcx	
	je 		.S_finish

		mov 	%r9, %rax
		mul 	%rcx
		mov 	%rax, %r9

		add 	%rax, %rbx
		inc 	%rcx
		jmp 	.S_start

	.S_finish:
	mov 	%rbx, %rax
	ret

_start:

	leaq 	inp_1(%rip), %rsi
	call 	ReadLine

	mov 	%rsi, %rdi
	call 	Atoi

	mov 	%rax, %rdi
	call 	Solve

	call 	Printline

	mov 	$0x3c, %rax
	mov 	$0x0, %rdi
	syscall
