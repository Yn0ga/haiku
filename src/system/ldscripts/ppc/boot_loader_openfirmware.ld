OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
OUTPUT_ARCH(powerpc)

ENTRY(_start)
SECTIONS
{
	. = 0x202000 + SIZEOF_HEADERS;

	/* text/read-only data */
	.text :	{ *(.text .text.* .gnu.linkonce.t.*) }

	. = ALIGN(0x4);
	__ctor_list = .;
	.ctors : { *(.ctors) *(.init_array) }
	__ctor_end = .;

	.rodata : { *(.rodata .rodata.*) }
	.sdata2 : { *(.sdata2) }

	/* writable data  */
	. = ALIGN(0x1000);
	__data_start = .;
	.data : { *(.data .gnu.linkonce.d.*) }
	.data.rel.ro : { *(.data.rel.ro.local .data.rel.ro*) }
	.data.rel.local : { *(.data.rel.local*) }
	.got : { *(.got .got2) }
	.sdata : { *(.sdata .sdata.* .gnu.linkonce.s.*) }

	/* uninitialized data (in same segment as writable data) */
	__bss_start = .;
	.sbss : { *(.sbss .sbss.* .gnu.linkonce.sb.*) }
	.bss : { *(.bss .bss.* .gnu.linkonce.b.*) }

	. = ALIGN(0x1000);
	_end = . ;

	/* Debug */
	INCLUDE debuginfo.ld
	/* Strip unnecessary stuff */
	/DISCARD/ : { *(.comment .note .eh_frame .dtors .stab .stabstr .debug*) }
}
