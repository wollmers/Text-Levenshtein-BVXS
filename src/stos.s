.intel_syntax noprefix
.globl _stos_memset
_stos_memset:
mov rcx, rdx
mov rdx, rdi
mov al, sil
rep stos byte ptr [rdi]
mov rax, rdx
ret
