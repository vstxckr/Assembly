# problem: https://oj.lequydon.net/problem/avg3num
# gcc -m64 -Wl,-e_start -nostdlib -o avg_3 avg_3.S
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

	.Ai_pre:
	cmpb 	$0x20, (%rdi, %rcx)
	jne 	.Ai_start
	inc 	%rcx
	jmp 	.Ai_pre

	.Ai_start:

	xor 	%rsi, %rsi
	movb 	(%rdi, %rcx), %sil

	cmp 	$0xa, %sil
	je 		.Ai_finish
	cmp 	$0x20, %sil
	je 		.Ai_finish
		sub 	$0x30, %sil
		mul 	%rbx
		add 	%rsi, %rax
		inc 	%rcx
		jmp 	.Ai_start

	.Ai_finish:

	add 	%rdi, %rcx
	mov 	%rcx, %rdi

	mov 	%rbp, %rsp
	pop 	%rbp
	ret

Printline: # void (rax)
	push 	%rbp
	mov 	%rsp, %rbp

	mov 	$10, %rbx
	push 	$0x0
	push 	$0xa

	cmp 	$0x0, %rax
	jge 	.PS_start
		push 	%rax

		push 	$0x2d
		mov 	$0x1, %rax
		mov 	$0x1, %rdi
		mov 	%rsp, %rsi
		mov 	$0x1, %rdx
		syscall

		add 	$0x8, %rsp
		pop 	%rax

		dec 	%rax
		not 	%rax

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
	
_start:
	push 	%rbp
	mov 	%rsp, %rbp

	push 	$0x0
	push 	$0x0
	push 	$0x0

	leaq 	inp_1(%rip), %rsi
	call 	ReadLine

	mov 	%rsi, %rdi

	call 	Atoi
	movq 	%rax, -0x8(%rbp)

	call 	Atoi
	movq 	%rax, -0x10(%rbp)

	call 	Atoi
	movq 	%rax, -0x18(%rbp)

	movq 	-0x18(%rbp), %rax
	movq 	-0x10(%rbp), %rbx
	movq 	-0x8(%rbp), %rcx
	mov 	$0x3, %rdx
	
	mul  	%rdx
	sub 	%rbx, %rax
	sub 	%rcx, %rax

	call 	Printline

	mov 	$0x3c, %rax
	mov 	$0x0, %rdi
	syscall
