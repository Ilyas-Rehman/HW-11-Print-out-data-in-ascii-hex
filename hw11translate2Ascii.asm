; Ilyas Rehman CMSC313 2:30 VI60131
; 32-bit NASM program to translate bytes to ASCII hex output
; Input:  inputBuf (8 bytes)
; Output: outputBuf (24 bytes = 8 * 3 chars) followed by newline

section .data
inputBuf:    db  0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A  ; given data bytes

section .bss
outputBuf:   resb 24                                      ; space for "XX " * 8

section .text
global _start

_start:
    mov     esi, inputBuf       ; ESI -> start of input
    mov     edi, outputBuf      ; EDI -> start of output
    mov     ecx, 8              ; loop counter = number of bytes

.loop_translate:
    mov     al, [esi]           ; load next byte into AL
    call    translate_byte      ; convert byte -> two hex chars + space
    inc     esi                 ; advance input pointer
    add     edi, 3              ; advance output pointer (2 chars + space)
    loop    .loop_translate     ; repeat for all bytes

    dec     edi                 ; back up to last space
    mov     byte [edi], 0x0A    ; replace final space with newline

    ; write(outputBuf, 24)
    mov     eax, 4              ; sys_write
    mov     ebx, 1              ; file descriptor 1 = stdout
    mov     ecx, outputBuf
    mov     edx, 24             ; number of bytes to write
    int     0x80

    ; exit(0)
    mov     eax, 1              ; sys_exit
    xor     ebx, ebx            ; status 0
    int     0x80

; Subroutine: translate_byte
; Converts AL (byte) to its two-digit uppercase hex ASCII in [EDI] and [EDI+1],
; then writes a space at [EDI+2].
translate_byte:
    push    eax                 ; save full register

    mov     ah, al              ; store original byte in AH

    ; High nibble conversion
    shr     al, 4               ; shift high nibble into low 4 bits
    and     al, 0x0F            ; mask off upper bits
    cmp     al, 9
    jg      .high_alpha
    add     al, '0'             ; 0–9 -> '0'–'9'
    jmp     .store_high
.high_alpha:
    add     al, 'A' - 10        ; 10–15 -> 'A'–'F'
.store_high:
    mov     [edi], al           ; store high hex char

    ; Low nibble conversion
    mov     al, ah              ; restore original byte
    and     al, 0x0F            ; isolate low 4 bits
    cmp     al, 9
    jg      .low_alpha
    add     al, '0'             ; 0–9 -> '0'–'9'
    jmp     .store_low
.low_alpha:
    add     al, 'A' - 10        ; 10–15 → 'A'–'F'
.store_low:
    mov     [edi+1], al         ; store low hex char

    mov     byte [edi+2], ' '   ; separator space

    pop     eax                 ; restore register
    ret
