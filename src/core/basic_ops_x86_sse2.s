	.file	"basic_ops_x86.c"
	.text
	.p2align 4,,15
.globl alignedMemCpySSE2
	.type	alignedMemCpySSE2, @function
alignedMemCpySSE2:
	pushl	%esi
	pushl	%ebx
	movl	20(%esp), %esi
	movl	12(%esp), %edx
	movl	16(%esp), %ecx
	shrl	$6, %esi
	testl	%esi, %esi
	je	.L4
	xorl	%eax, %eax
	xorl	%ebx, %ebx
	.p2align 4,,7
	.p2align 3
.L3:
	addl	$1, %ebx
	movdqa	(%ecx,%eax), %xmm0
	movdqa	%xmm0, (%edx,%eax)
	movdqa	16(%ecx,%eax), %xmm0
	movdqa	%xmm0, 16(%edx,%eax)
	movdqa	32(%ecx,%eax), %xmm0
	movdqa	%xmm0, 32(%edx,%eax)
	movdqa	48(%ecx,%eax), %xmm0
	movdqa	%xmm0, 48(%edx,%eax)
	addl	$64, %eax
	cmpl	%ebx, %esi
	jne	.L3
.L4:
	popl	%ebx
	popl	%esi
	ret
	.size	alignedMemCpySSE2, .-alignedMemCpySSE2
	.p2align 4,,15
.globl alignedMemClearSSE2
	.type	alignedMemClearSSE2, @function
alignedMemClearSSE2:
	movl	8(%esp), %ecx
	shrl	$6, %ecx
	testl	%ecx, %ecx
	je	.L10
	movl	4(%esp), %eax
	xorl	%edx, %edx
	pxor	%xmm0, %xmm0
	.p2align 4,,7
	.p2align 3
.L9:
	addl	$1, %edx
	movdqa	%xmm0, (%eax)
	movdqa	%xmm0, 16(%eax)
	movdqa	%xmm0, 32(%eax)
	movdqa	%xmm0, 48(%eax)
	addl	$64, %eax
	cmpl	%edx, %ecx
	jne	.L9
.L10:
	rep
	ret
	.size	alignedMemClearSSE2, .-alignedMemClearSSE2
	.p2align 4,,15
.globl alignedConvertToS16SSE2
	.type	alignedConvertToS16SSE2, @function
alignedConvertToS16SSE2:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$8, %esp
	movl	36(%esp), %eax
	movss	.LC0, %xmm6
	cmpb	$0, 44(%esp)
	movl	28(%esp), %edx
	movl	32(%esp), %ebx
	movl	%eax, %esi
	mulss	40(%esp), %xmm6
	jne	.L13
	testw	%ax, %ax
	jle	.L15
	movl	%eax, %edi
	shrw	$2, %di
	cmpw	$3, %ax
	movw	%ax, 2(%esp)
	leal	0(,%edi,4), %ebp
	ja	.L33
.L28:
	xorl	%ebp, %ebp
	.p2align 4,,7
	.p2align 3
.L23:
	movswl	%bp,%eax
	movl	$-32768, %edi
	leal	(%edx,%eax,8), %edx
	leal	(%ebx,%eax,4), %eax
	movl	$32767, %ebx
	.p2align 4,,7
	.p2align 3
.L25:
	movss	(%edx), %xmm0
	mulss	%xmm6, %xmm0
	cvttss2si	%xmm0, %ecx
	movss	4(%edx), %xmm0
	cmpl	$-32768, %ecx
	mulss	%xmm6, %xmm0
	cmovl	%edi, %ecx
	cmpl	$32767, %ecx
	cmovg	%ebx, %ecx
	movw	%cx, (%eax)
	cvttss2si	%xmm0, %ecx
	cmpl	$-32768, %ecx
	cmovl	%edi, %ecx
	cmpl	$32767, %ecx
	cmovg	%ebx, %ecx
	addl	$1, %ebp
	movw	%cx, 2(%eax)
	addl	$8, %edx
	addl	$4, %eax
	cmpw	%bp, %si
	jg	.L25
.L15:
	movswl	%si,%esi
	addl	$8, %esp
	leal	0(,%esi,4), %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,7
	.p2align 3
.L13:
	testw	%ax, %ax
	jle	.L15
	movl	%eax, %ebp
	shrw	$2, %bp
	cmpw	$3, %si
	movw	%ax, 2(%esp)
	leal	0(,%ebp,4), %eax
	ja	.L34
.L27:
	xorl	%eax, %eax
	.p2align 4,,7
	.p2align 3
.L18:
	movswl	%ax,%edi
	leal	(%edx,%edi,8), %ecx
	leal	(%ebx,%edi,4), %edx
	movl	$-32768, %edi
	.p2align 4,,7
	.p2align 3
.L20:
	movss	(%ecx), %xmm0
	movl	$32767, %ebp
	mulss	%xmm6, %xmm0
	cvttss2si	%xmm0, %ebx
	movss	4(%ecx), %xmm0
	cmpl	$-32768, %ebx
	cmovl	%edi, %ebx
	cmpl	$32767, %ebx
	mulss	%xmm6, %xmm0
	cmovg	%ebp, %ebx
	movzbl	%bh, %ebp
	sall	$8, %ebx
	orl	%ebp, %ebx
	movl	$32767, %ebp
	movw	%bx, (%edx)
	cvttss2si	%xmm0, %ebx
	cmpl	$-32768, %ebx
	cmovl	%edi, %ebx
	cmpl	$32767, %ebx
	cmovg	%ebp, %ebx
	addl	$1, %eax
	movzbl	%bh, %ebp
	addl	$8, %ecx
	sall	$8, %ebx
	orl	%ebp, %ebx
	movw	%bx, 2(%edx)
	addl	$4, %edx
	cmpw	%ax, %si
	jg	.L20
	jmp	.L15
	.p2align 4,,7
	.p2align 3
.L34:
	testw	%ax, %ax
	je	.L27
	movaps	%xmm6, %xmm0
	xorl	%ecx, %ecx
	movdqa	.LC1, %xmm3
	shufps	$0, %xmm0, %xmm0
	movdqa	.LC2, %xmm2
	movss	%xmm6, 4(%esp)
	xorl	%edi, %edi
	movaps	%xmm0, %xmm7
	.p2align 4,,7
	.p2align 3
.L19:
	movaps	(%edx,%ecx,2), %xmm0
	movdqa	%xmm2, %xmm5
	movdqa	%xmm2, %xmm6
	addl	$1, %edi
	movaps	16(%edx,%ecx,2), %xmm4
	mulps	%xmm7, %xmm0
	mulps	%xmm7, %xmm4
	cvttps2dq	%xmm0, %xmm0
	movdqa	%xmm0, %xmm1
	pcmpgtd	%xmm3, %xmm1
	pand	%xmm1, %xmm0
	pandn	%xmm3, %xmm1
	por	%xmm0, %xmm1
	cvttps2dq	%xmm4, %xmm4
	movdqa	%xmm1, %xmm0
	pcmpgtd	%xmm2, %xmm0
	pand	%xmm0, %xmm5
	pandn	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	movdqa	%xmm4, %xmm0
	por	%xmm5, %xmm1
	pcmpgtd	%xmm3, %xmm0
	movdqa	.LC3, %xmm5
	pand	%xmm0, %xmm4
	pand	%xmm1, %xmm5
	pandn	%xmm3, %xmm0
	psrad	$8, %xmm5
	por	%xmm4, %xmm0
	pslld	$8, %xmm1
	movdqa	%xmm0, %xmm4
	pcmpgtd	%xmm2, %xmm4
	pand	%xmm4, %xmm6
	pandn	%xmm0, %xmm4
	movdqa	%xmm4, %xmm0
	movdqa	.LC3, %xmm4
	por	%xmm6, %xmm0
	pand	%xmm0, %xmm4
	pslld	$8, %xmm0
	psrad	$8, %xmm4
	movdqa	%xmm5, %xmm6
	punpcklwd	%xmm4, %xmm5
	punpckhwd	%xmm4, %xmm6
	movdqa	%xmm5, %xmm4
	punpcklwd	%xmm6, %xmm5
	punpckhwd	%xmm6, %xmm4
	punpcklwd	%xmm4, %xmm5
	movdqa	%xmm1, %xmm4
	punpcklwd	%xmm0, %xmm1
	punpckhwd	%xmm0, %xmm4
	movdqa	%xmm1, %xmm6
	punpcklwd	%xmm4, %xmm1
	punpckhwd	%xmm4, %xmm6
	punpcklwd	%xmm6, %xmm1
	por	%xmm1, %xmm5
	movdqa	%xmm5, (%ebx,%ecx)
	addl	$16, %ecx
	cmpw	%di, %bp
	ja	.L19
	cmpw	2(%esp), %ax
	movss	4(%esp), %xmm6
	jne	.L18
	jmp	.L15
	.p2align 4,,7
	.p2align 3
.L33:
	testw	%bp, %bp
	.p2align 4,,3
	.p2align 3
	je	.L28
	movaps	%xmm6, %xmm0
	xorl	%eax, %eax
	movdqa	.LC1, %xmm3
	shufps	$0, %xmm0, %xmm0
	movdqa	.LC2, %xmm2
	xorl	%ecx, %ecx
	movaps	%xmm0, %xmm5
	.p2align 4,,7
	.p2align 3
.L24:
	movaps	(%edx,%eax,2), %xmm0
	addl	$1, %ecx
	movdqa	%xmm2, %xmm7
	movaps	16(%edx,%eax,2), %xmm4
	mulps	%xmm5, %xmm0
	mulps	%xmm5, %xmm4
	cvttps2dq	%xmm0, %xmm0
	movdqa	%xmm0, %xmm1
	pcmpgtd	%xmm3, %xmm1
	pand	%xmm1, %xmm0
	pandn	%xmm3, %xmm1
	por	%xmm0, %xmm1
	cvttps2dq	%xmm4, %xmm4
	movdqa	%xmm1, %xmm0
	pcmpgtd	%xmm2, %xmm0
	pand	%xmm0, %xmm7
	pandn	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	movdqa	%xmm4, %xmm0
	por	%xmm7, %xmm1
	pcmpgtd	%xmm3, %xmm0
	movdqa	%xmm2, %xmm7
	pand	%xmm0, %xmm4
	pandn	%xmm3, %xmm0
	por	%xmm4, %xmm0
	movdqa	%xmm0, %xmm4
	pcmpgtd	%xmm2, %xmm4
	pand	%xmm4, %xmm7
	pandn	%xmm0, %xmm4
	movdqa	%xmm4, %xmm0
	movdqa	%xmm1, %xmm4
	por	%xmm7, %xmm0
	punpckhwd	%xmm0, %xmm4
	punpcklwd	%xmm0, %xmm1
	movdqa	%xmm1, %xmm0
	punpcklwd	%xmm4, %xmm1
	punpckhwd	%xmm4, %xmm0
	punpcklwd	%xmm0, %xmm1
	movdqa	%xmm1, (%ebx,%eax)
	addl	$16, %eax
	cmpw	%cx, %di
	ja	.L24
	cmpw	%bp, 2(%esp)
	jne	.L23
	jmp	.L15
	.size	alignedConvertToS16SSE2, .-alignedConvertToS16SSE2
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC0:
	.long	1191181824
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC1:
	.long	-32768
	.long	-32768
	.long	-32768
	.long	-32768
	.align 16
.LC2:
	.long	32767
	.long	32767
	.long	32767
	.long	32767
	.align 16
.LC3:
	.long	65280
	.long	65280
	.long	65280
	.long	65280
	.ident	"GCC: (Ubuntu 4.4.0-0ubuntu2) 4.4.0"
	.section	.note.GNU-stack,"",@progbits