# problem: https://oj.lequydon.net/problem/ucln
# gcc -m64 -Wl,-e_start -nostdlib -o gcd gcd.S
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
.section .bss
.lcomm Input_1, 20
.lcomm Input_2, 20

.section .text

.global _start


ReadLine:
	push 	%rbp
	mov 	%rsp, %rbp

	mov 	$0, %rax
	mov 	$0, %rdi
	movq 	0x10(%rbp), %rsi
	mov 	$15, %rdx
	syscall

	mov 	%rbp, %rsp
	pop 	%rbp
	ret


Printline:
	push 	%rbp
	mov 	%rsp, %rbp

	push 	%rax
	push 	%rcx
	push 	%rbx
	push 	%rdx
	push 	%rsi
	push 	%rdi

	push 	$0x0
	push 	$0xa
	mov 	$10, %rbx
	mov 	$1, %rcx
	
	.Ps_push:
		cmp 	$0, %rax
		je 		.Ps_print

			xor 	%rdx, %rdx
			div 	%rbx
			add 	$0x30, %rdx
			push 	%rdx
			inc 	%rcx
			jmp 	.Ps_push
	.Ps_print:
		cmpq 	$0x0, (%rsp)
		je 		.Pf_print
			
			mov 	$0x1, %rax
			mov 	$0x1, %rdi
			mov 	%rsp, %rsi
			mov 	$0x1, %rdx
			syscall
			add 	$0x8, %rsp
			jmp 	.Ps_print
	.Pf_print:

	add 	$0x8, %rsp

	pop 	%rdi
	pop 	%rsi
	pop 	%rdx
	pop 	%rbx
	pop 	%rcx
	pop 	%rax

	mov 	%rbp, %rsp
	pop 	%rbp
	ret


ConvertInt:
	xor 	%rcx, %rcx
	xor 	%rdx, %rdx
	xor 	%rax, %rax

	.CI1_loop:

		xor 	%rdi, %rdi
		movb 	(%rcx,%rbx), %dil
		cmp 	$0xa, %dil
		je 		.CI1_end

			mov 	%rax, %rdx
			shl 	$3, %rax
			shl 	$1, %rdx
			add 	%rdx, %rax

			sub 	$0x30, %dil

			add 	%rdi, %rax
			inc 	%rcx
			jmp 	.CI1_loop

	.CI1_end:
		push 	%rax
		inc  	%rcx

	.CI2_loop:

		xor 	%rdi, %rdi
		movb 	(%rcx,%rbx), %dil
		cmp 	$0xa, %dil
		je 		.Cf_loop

			mov 	%rax, %rdx
			shl 	$3, %rax
			shl 	$1, %rdx
			add 	%rdx, %rax

			sub 	$0x30, %dil

			add 	%rdi, %rax
			inc 	%rcx
			jmp 	.CI2_loop

	.Cf_loop:
		push 	%rax
		call 	Solve
		add 	$0x10, %rsp
		call 	Printline

	ret

Solve:
	push 	%rbp
	mov 	%rsp, %rbp

	xor 	%rdx, %rdx

	movq 	16(%rbp), %rax
	movq 	24(%rbp), %r9

	.s_loop:
		cmp 	$0, %rax
		je 		.f_loop
		cmp 	$0, %r9
		je 		.f_loop
			
			xor 	%rdx, %rdx
			div 	%r9
			mov 	%r9, %rax
			mov 	%rdx, %r9
			jmp 	.s_loop

	.f_loop:
	add 	%r9, %rax

	mov 	%rbp, %rsp
	pop 	%rbp
	ret

_start:
	push 	%rbp
	mov 	%rsp, %rbp

	leaq 	Input_1(%rip), %r9
	push 	%r9
	call 	ReadLine
	add 	$0x8, %rsp

	leaq 	Input_2(%rip), %r9
	push 	%r9
	call 	ReadLine
	add 	$0x8, %rsp

	leaq 	Input_1(%rip), %rbx
	call 	ConvertInt
		
	mov 	$0x3c, %rax
	mov 	$0x0, %rdi
	syscall
