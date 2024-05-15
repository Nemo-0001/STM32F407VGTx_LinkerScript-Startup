/*
    @file   Linker_Script.ld
    @author Abdallah Alnemr
    @brief  Linker script for STM32F407VGTx MCU
*/

/* Highest address of the user mode stack because the Stack is descending scheme*/
_estack = ORIGIN(RAM) + LENGTH(RAM); /* End of "RAM" */

/* Define the min heap & stack size to avoid overflow of the memory */
_Min_Heap_Size = 0x200 ;  /* Required amount of heap */
_Min_Stack_Size = 0x400 ; /* Required amount of stack */

/* Memory_Definition -> 
Label_Name(Attribute_List ->> [x -> executable] - [r -> read only] - [readable & writable]) : ORIGIN = Start_Memory_Address,   LENGTH = Memory_Length */
MEMORY
{
   CCMRAM (xrw)    : ORIGIN = 0x10000000,   LENGTH = 64K
   RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 128K
   FLASH  (rx)     : ORIGIN = 0x08000000,   LENGTH = 1024K
}

/* Sections */
SECTIONS{
  /* The startup code into "FLASH" */
  .isr_vector :
  {
    . = ALIGN(4);
    *(.isr_vector)
    . = ALIGN(4);
  } >FLASH

  /* .text section, The program code and other data into "FLASH" */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    . = ALIGN(4);
    _etext = .;        /* Define a global symbols at end of code */
  } >FLASH

  /* .rodata section, Constant data into "FLASH" */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  /* Used by the startup code to initialize the data */
  _sidata = LOADADDR(.data);

  /* .data section, Initialized data sections into "RAM" */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* Create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    . = ALIGN(4);
    _edata = .;        /* Define a global symbol at data end */
  } >RAM AT> FLASH

  /* .bss section, Uninitialized data section into "RAM" */
  .bss :
  {
    _sbss = .;         /* Define a global symbol at bss start */
    *(.bss)            /* .bss sections */
    *(.bss*)           /* .bss* sections */
    . = ALIGN(4);
    _ebss = .;         /* Define a global symbol at bss end */
  } >RAM

  /* .User_Heap_Stack section, used to check that there is enough   "RAM" left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM
}
