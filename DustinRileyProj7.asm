INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
intro BYTE "Bitwise Multiplication of Unsigned Integers", 0
base BYTE "Enter the multiplicand: ", 0
multi BYTE "Enter the multiplier: ", 0
result BYTE "The product is ", 0
prompt BYTE "Do you want to do another calculation? y/n (all lower case): ", 0
temp DWORD 0
.code
BitwiseMultiply proc
	mov cl, -1							;reset cl
	mov eax, 0							;set eax to 0
	BM1:
		cmp edx, 0						;compare multiplier to 0
		je BM3							;jump if equal, to BM3
		add cl, 1						;add 1 to cl
		shr edx, 1						;shift multiplier bits right once (edx / 2^cl)
		jc BM2							;jump if carry flag is set, to BM2 (a 1 got shifted off the right end)
		jmp BM1							;jump to BM1
	BM2:
		mov temp, ebx					;copy ebx to temp
		shl ebx, cl						;shift ebx left (cl) times (ebx * 2^cl) essentially
		add eax, ebx					;add to eax
		mov ebx, temp					;reset ebx to its original multiplicand value
		jmp BM1							;jump to BM1
	BM3:
		ret
BitwiseMultiply endp

main proc
	L1:
		mov edx, OFFSET intro			;point edx to intro start
		call WriteString				;writes intro to console
		call Crlf						;writes new line to console
		call Crlf						;writes new line to console
		mov edx, OFFSET base			;point edx to base start
		call WriteString				;writes base to console
		call ReadDec					;reads 32bit unsigned decimal(base10) integer from keyboard to eax
		mov ebx, eax					;moves contents of eax to ebx
		mov edx, OFFSET multi			;point edx to multi start
		call WriteString				;writes multi to console
		call ReadDec					;reads 32bit unsigned decimal(base10) integer from keyboard to eax
		mov edx, eax					;moves contents of eax to edx
		call BitwiseMultiply			;calls BitwiseMultiply process returning product in eax
		call Crlf						;writes new line to console
		mov edx, OFFSET result			;point edx to result start
		call WriteString				;writes result to console
		call WriteDec					;writes product to console from eax
		call Crlf						;writes new line to console
	L2:
		mov edx, OFFSET prompt			;point edx to prompt start
		call WriteString				;writes prompt to console
		call ReadChar					;reads character from keyboard to al
		call Crlf						;writes new line to console
		call Crlf						;writes new line to console
		cmp al, 121						;compare character to ascii y (121)
		je L1							;jump if equal, to L1
		cmp al, 110						;compare character to ascii n (110)
		je L3							;jump if equal, to L3
		jmp L2							;jump to L2 (y/n not entered)
	L3:
		call WaitMsg					;waits for any key press
		invoke ExitProcess, 0
main endp
end main