/* Get memory address of GPIO region */
.globl GetGpioAddress
GetGpioAddress:
  ldr r0, =0x20200000
  mov pc, lr

/* set function for GPIO pin
 * Inputs:
 * r0 : GPIO pin num
 * r1 : function for pin
 */
.globl SetGpioFunction
SetGpioFunction:
  /* ensure pin # is in range 0-53 */
  cmp r0, #53
    /* ensure function for pin is in range 0-7 */
    cmpls r1, #7
      /* return if either of previous conditions is not met */
      movhi pc, lr

  /* save lr */
  push {lr}
  
  /* r0 now contains GPIO address region
   * r2 now contains GPIO pin num
   */
  mov r2, r0  
  bl GetGpioAddress

  /* address = GPIO address region + 4 × (GPIO pin num ÷ 10)
  functionLoop$:
    cmp r2,#9
    subhi r2,#10
    addhi r0,#4
    bhi functionLoop$

  /* r2 = 3 * r2 */
  add r2, r2,lsl #1
  lsl r1,r2
  /* set the function at the address */
  str r1,[r0]

  /* return */
  pop {pc}

/* set val to pin 
 * Inputs:
 * r0 : pin num
 * r1 : pin val
 */
.globl SetGpio
SetGpio:
  pinNum .req r0
  pinVal .req r1

  /* verify valid pin num */
  cmp pinNum,#53
    movhi pc,lr
  
  push {lr}
  
  /* move pin num to r2 */
  mov r2,pinNum
  .unreq pinNum
  pinNum .req r2
  
  /* r0 now contains GPIO address */
  bl GetGpioAddress
  gpioAddr .req r0

  /* pinNum / 32  * 4 */
  pinBank .req r3
  lsr pinBank, pinNum, #5
  lsl pinBank, #2
  add gpioAddr, pinBank
  .unreq pinBank

  /* generate num with correct bit set */
  and pinNum, #31
  setBit .req r3
  mov setBit, #1
  lsl setBit, pinNum
  .unreq pinNum

  /* set the bit */
  teq pinVal, #0
  .unreq pinVal
  
  streq setBit, [gpioAddr,#40]
  strne setBit, [gpioAddr,#28]
  
  .unreq setBit
  .unreq gpioAddr
  
  pop {pc}
