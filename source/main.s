.section .init
.globl _start
_start:

b main
.section .text

main:

  /* Set the stack point to 0x8000 */
  mov sp,#0x8000

  /* setup the pin for the OK LED */
  pinNum .req r0
  pinFunc .req r1
  mov pinNum,#16
  mov pinFunc,#1
  bl SetGpioFunction
  .unreq pinNum
  .unreq pinFunc

  loop$:

    /* turn on LED */
    pinNum .req r0
    pinVal .req r1
    mov pinNum,#16
    mov pinVal,#0
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    /* delay */
    decr .req r0
    mov decr,#0x3F0000
    wait1$: 
      sub decr,#1
      teq decr,#0
      bne wait1$
    .unreq decr

    /* turn off LED */
    pinNum .req r0
    pinVal .req r1
    mov pinNum,#16
    mov pinVal,#1
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    /* delay */
    decr .req r0
    mov decr,#0x3F0000
    wait2$:
      sub decr,#1
      teq decr,#0
      bne wait2$
    .unreq decr

  b loop$
