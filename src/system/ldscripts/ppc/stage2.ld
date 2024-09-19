OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
OUTPUT_ARCH(powerpc)

PHDRS
{
  headers PT_PHDR PHDRS ;
  text PT_LOAD FILEHDR PHDRS FLAGS(5) ;
  data PT_LOAD ;
  dynamic PT_DYNAMIC ;
}

ENTRY(_start)
SECTIONS
{
	. = 0x80000000 + SIZEOF_HEADERS;

        .dynsym : { *(.dynsym) }
        .dynstr : { *(.dynstr) }
        .plt : { *(.plt) }
        .gnu.version : { *(.gnu.version) }
        .gnu.version_d : { *(.gnu.version_d) }
        .gnu.version_r : { *(.gnu.version_r) }

        /* text/read-only data */
        .text : {
                *(.text .stub .text.* .gnu.linkonce.t.*)
        } :text =0x90909090

        .rodata : { *(.rodata .rodata.* .gnu.linkonce.r.*) }

	/* writable data  */
	. = ALIGN(0x1000);
	__data_start = .;
	.data : { *(.data .gnu.linkonce.d.*) } :data

	 . = ALIGN(0x4);

	__ctor_list = .;
	.ctors : { *(.ctors) }
	__ctor_end = .;
        __dtor_list = .;
        .dtors : { *(.dtors) }
        __dtor_end = .;
	.got : { *(.got.plt) *(.got) }
	.dynamic : { *(.dynamic) } :dynamic :data

	. = ALIGN(0x8);

	/* uninitialized data (in same segment as writable data) */
	__bss_start = .;
        .sbss : { *(.sbss .sbss.* .gnu.linkonce.sb.*) }
        .bss : {
                *(.bss .bss.* .gnu.linkonce.b.*)
        } :data
	/* make sure to end on a page boundary */
	. = ALIGN(0x1000);

	_end = . ;

	/* Debug  */
	/* INCLUDE debuginfo.ld */
	/* debuginfo not found */

	  /* Stabs debugging sections.  */
  	.stab 0 : { *(.stab) }
	.stabstr 0 : { *(.stabstr) }
  	/* DWARF debug sections.
     	Symbols in the DWARF debugging sections are relative to the beginning
     	of the section so we begin them at 0.  */
  	/* DWARF 1 */
  	.debug          0 : { *(.debug) }
  	.line           0 : { *(.line) }
 	/* GNU DWARF 1 extensions */
  	.debug_srcinfo  0 : { *(.debug_srcinfo) }
  	.debug_sfnames  0 : { *(.debug_sfnames) }
 	/* DWARF 1.1 and DWARF 2 */
  	.debug_aranges  0 : { *(.debug_aranges) }
  	.debug_pubnames 0 : { *(.debug_pubnames) }
  	/* DWARF 2 */
  	.debug_info     0 : { *(.debug_info) }
  	.debug_abbrev   0 : { *(.debug_abbrev) }
  	.debug_line     0 : { *(.debug_line) }
 	.debug_frame    0 : { *(.debug_frame) }
  	.debug_str      0 : { *(.debug_str) }
  	.debug_loc      0 : { *(.debug_loc) }
  	.debug_macinfo  0 : { *(.debug_macinfo) }
  	/* SGI/MIPS DWARF 2 extensions */
  	.debug_weaknames 0 : { *(.debug_weaknames) }
  	.debug_funcnames 0 : { *(.debug_funcnames) }
  	.debug_typenames 0 : { *(.debug_typenames) }
 	.debug_varnames  0 : { *(.debug_varnames) }
  	/* These must appear regardless of  .  */

	/* Strip unnecessary stuff */
	/DISCARD/ : { *(.comment .note .eh_frame .dtors) }
}
