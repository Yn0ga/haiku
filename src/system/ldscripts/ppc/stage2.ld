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
	. = 0x8e000000 + SIZEOF_HEADERS;

	/* text/read-only data */
	.text :	{ *(.text .gnu.linkonce.t.*) } :text

	__ctor_list = .;
	.ctors : { *(.ctors) }
	__ctor_end = .;

	.rodata : { *(.rodata) }

	/* writable data  */
	. = ALIGN(0x1000);
	__data_start = .;
	.data : { *(.data .gnu.linkonce.d.*) } :data

	/* uninitialized data (in same segment as writable data) */
	__bss_start = .;
	.bss : { *(.bss) } :data

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
