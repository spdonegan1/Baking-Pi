.section .init
.globl _start
_start:

/* load the GPIO region address into r0 */
ldr r0, =0x20200000

mov r1, #1
lsl r1, #18

str r1, [r0,#4]

lsr r1, #2

loop$: 

    /* turn on led */
    str r1,[r0,#40]

    /* set delay for timer */
    mov r2,#0x3F0000

    wait1$:
        sub r2,#1
        cmp r2,#0
        bne wait1$

    /* turn off led */
    str r1,[r0,#28]

    /* reset timer delay */
    mov r2,#0x3F0000

    wait2$:
        sub r2,#1
        cmp r2,#0
        bne wait2$

b loop$
