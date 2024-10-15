
OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
OUTPUT_ARCH(powerpc)

ENTRY(_start)
SEARCH_DIR("libgcc");

PHDRS
{
	headers PT_PHDR PHDRS ;
	inter PT_INTERP ;
	text PT_LOAD FILEHDR PHDRS FLAGS(5) ;
	data PT_LOAD ;
	dynamic PT_DYNAMIC ;
}

SECTIONS
{
  . = 0x80000000 + SIZEOF_HEADERS;

  .interp 	  : { *(.interp) } :inter :text
  .hash 	  : { *(.hash) }
  .dynsym 	  : { *(.dynsym) }
  .dynstr 	  : { *(.dynstr) }
  .gnu.version 	  : { *(.gnu.version) }
  .gnu.version_d  : { *(.gnu.version_d) }
  .gnu.version_r  : { *(.gnu.version_r) }
  .rela.dyn : 
    {
      *(.rela.init)
      *(.rela.text .rela.text.* .rela.gnu.linkonce.t*)
      *(.rela.fini)
      *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r*)
      *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)
      *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)
      *(.rela.ctors)
      *(.rela.dtors)
      *(.rela.got)
      *(.rela.got1)
      *(.rela.got2)
      *(.rela.sdata .rela.sdata.* .rela.gnu.linkonce.s.*)
      *(.rela.sbss .rela.sbss.* .rela.gnu.linkonce.sb.*)
      *(.rela.sdata2 .rela.sdata2.* .rela.gnu.linkonce.s2.*)
      *(.rela.sbss2 .rela.sbss2.* .rela.gnu.linkonce.sb2.*)
      *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)
      *(.rela.data.rel.ro)
      *(.rela.fixup)
      *(.rela.glink) 
      *(.rela.branch_lt) 
      PROVIDE_HIDDEN (__rela_iplt_start = .);
      *(.rela.iplt)
      PROVIDE_HIDDEN (__rela_iplt_end = .);
    }
  .rela.plt       :
    {
    	*(.rela.plt)
    }
  .init           :
    {
   	KEEP (*(SORT_NONE(.init)))
    }
  .plt            : { *(.plt) }
  .iplt           : { *(.iplt) }
  .text           :
    {
    	*(.glink)
    	*(.text.unlikely .text.*_unlikely .text.unlikely.*)
    	*(.text.exit .text.exit.*)
    	*(.text.startup .text.startup.*)
    	*(.text.hot .text.hot.*)
  	*(.text .stub .text.* .gnu.linkonce.t.*)
   	*(.fixup)
    	/* .gnu.warning sections are handled specially by elf32.em.  */
    	*(.gnu.warning)
    } =0x90909090
  .fini           :
    {
   	KEEP (*(SORT_NONE(.fini)))
    }
  .got1		: { *(.got1) }
  .got2		: { *(.got2) }
  . = ALIGN(0x8);
  altcodepatch_begin = .;
  .altcodepatch : { *(.altcodepatch) }
  altcodepatch_end = .;
  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);
 
  .rodata 	: { *(.rodata .rodata.* .gnu.linkonce.r.*) }
  .rodata1      : { *(.rodata1) }
  .sdata2       :
  {
    /* PROVIDE (_SDA2_BASE_ = 32768); */
    *(.sdata2 .sdata2.* .gnu.linkonce.s2.*)
  }
  .sbss2          : { *(.sbss2 .sbss2.* .gnu.linkonce.sb2.*) }
  .eh_frame_hdr : { *(.eh_frame_hdr) *(.eh_frame_entry .eh_frame_entry.*) }
  .eh_frame       : ONLY_IF_RO { KEEP (*(.eh_frame)) *(.eh_frame.*) }
  .gcc_except_table   : ONLY_IF_RO { *(.gcc_except_table
  .gcc_except_table.*) }
  .gnu_extab   : ONLY_IF_RO { *(.gnu_extab*) }
  /* Adjust the address for the data segment.  We want to adjust up to
   * the same address within the page on the next page up. */
  . = ALIGN (0x1000) - ((0x1000 - .) & (0x1000 - 1)); . = DATA_SEGMENT_ALIGN (CONSTANT (MAXPAGESIZE), CONSTANT (COMMONPAGESIZE));
  /* Exception handling  */
  .eh_frame       : ONLY_IF_RW { KEEP (*(.eh_frame)) *(.eh_frame.*) } 
  .gnu_extab      : ONLY_IF_RW { *(.gnu_extab) }
  .gcc_except_table   : ONLY_IF_RW { *(.gcc_except_table .gcc_except_table.*) }
  .exception_ranges   : ONLY_IF_RW { *(.exception_ranges .exception_ranges*) }
  /* Thread Local Storage sections  */
  .tdata          : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
  .tbss           : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) } 
  _haiku_revision : { *(_haiku_revision) }
  .preinit_array     :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  }
  .init_array     :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
    KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
    PROVIDE_HIDDEN (__init_array_end = .);
  }
  .fini_array     :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
    KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
    PROVIDE_HIDDEN (__fini_array_end = .);
  }
 
  __ctor_list = .;
  .ctors          :
  {
    /* gcc uses crtbegin.o to find the start of
     * the constructors, so we make sure it is
     * first.  Because this is a wildcard, it
     * doesn't matter if the user does not
     * actually link against crtbegin.o; the
     * linker won't look for a file to match a
     * wildcard.  The wildcard also means that it
     * doesn't matter which directory crtbegin.o
     * is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
     * the crtend.o file until after the sorted ctors.
     * The .ctor section from the crtend file contains the
     * end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  }
  __ctor_end = .;
  __dtor_list = .;
  .dtors          :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  }
  __dtor_end = .;
  . = ALIGN(0x8);
  .data.rel.ro : { *(.data.rel.ro.local* .gnu.linkonce.d.rel.ro.local.*) *(.data.rel.ro .data.rel.ro.* .gnu.linkonce.d.rel.ro.*) }
  .dynamic : { *(.dynamic) } :dynamic :data
  . = DATA_SEGMENT_RELRO_END (0, .);
  . = ALIGN(0x1000);
  __data_start = .;
 .data           :
   {
    	*(.data .data.* .gnu.linkonce.d.*)
	SORT(CONSTRUCTORS)
   } :data 
  .data1          : { *(.data1) }
  . = ALIGN(0x1000);
  /* PROVIDE (_GOT_START_ = .); */
  .got            : { *(.got) }
  .got.plt        : { *(.got.plt) }
 /*  PROVIDE (_GOT_END_ = .); */
  .branch_lt	  : { *(.branch_lt) } 
  /* We want the small data sections together, so single-instruction offsets
   * can access them all, and initialized data all before uninitialized, so
   * we can shorten the on-disk segment size.  */
  .sdata          :
  {
    __global_pointer$ = . + 0x800;
    /* PROVIDE (_SDA_BASE_ = 32768); */
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata .srodata.*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } 
   . = ALIGN(0x8);
   /* uninitialized data (in same segment as writable data) */
   __bss_start = .;
  .sbss : {
  	*(.dynsbss)
    	*(.sbss .sbss.* .gnu.linkonce.sb.*)
    	*(.scommon)
  }
  .bss : {
	*(.dynbss)
	*(.bss .bss.* .gnu.linkonce.b.*)
	*(COMMON)
	. = ALIGN(. != 0 ? 32 / 8 : 1);
  }  
  /* make sure to end on a page boundary */
  . = ALIGN(0x1000);
  . = DATA_SEGMENT_END(.);
  _end = . ;

	/* Debug  */
	INCLUDE debuginfo.ld 

	/* Strip unnecessary stuff */
	/DISCARD/ : { *(.comment .note .eh_frame .dtors .debug_*) }
}


