#!/usr/bin/env bash
# Given a target kernel entry address, compute and display the actual offset 
# for proper gdb introspection


usage() {
     echo "Usage:"
     echo " $0 [ -a <value>] Binary load address (hexformat)"
     echo " $0 [ -b <value>] Path to elf file"
     echo " $0 [ -s ]        Tone down verbosity"
     echo " $0 [ -h ]        Display help"
     echo "Default binary is: objects/haiku/ppc/debug_1/system/kernel/kernel_ppc"
     echo "Interactive mode if no options are set" 
}


VERBOSE=1
DEFAULT_BIN="objects/haiku/ppc/debug_1/system/kernel/kernel_ppc"

if [[ $# -gt 0 ]]; then
	while getopts ':p:b:a:hs' opt; do
		case "${opt}" in
			a)	ADDR=${OPTARG}
				;;
			b)
				KERNEL_BIN={$OPTARG}
				;;
			s)
				unset VERBOSE
				;;
			*)
				usage
				exit 1
				;;
		esac
	done
fi

if [[ -z $ADDR ]]; then
	echo "Enter kernel entry address: "
	read ADDR 
fi

if [[ -z $KERNEL_BIN ]]; then 
	KERNEL_BIN=$DEFAULT_BIN
fi	

if [[ -n $VERBOSE ]]; then 
	echo "reading $OBJ_DIR/$KERNEL_BIN"
fi

ELF=$(readelf -hS $KERNEL_BIN)
KERNEL_ENTRY=$(echo $ADDR | sed -nr "s/(kernel entry at )?((0x)?([[:xdigit:]]+))/\4/p" | awk '{ print toupper($0) }')
TXT=$(echo "$ELF" | sed -nr  "s/(.*\.text\s+PROGBITS\s+)([[:xdigit:]]+)(.*)/\2/p" |  awk '{ print toupper($0) }')
EP=$(echo "$ELF" | sed -nr  "s/(\s*Entry point address:\s+0x)([[:xdigit:]]*)/\2/p" |  awk '{ print toupper($0) }')

BIN_OFFSET=$(echo "obase=16;ibase=16;$EP - $TXT" | bc)
if [[ -n $VERBOSE ]]; then
	echo "Kernel entry at: " $KERNEL_ENTRY
	echo "Text section at: " $TXT
	echo "Entry point  at: " $EP
	echo "Offset .text/ep: " $BIN_OFFSET
fi
KRN_OFFSET=$(echo "obase=16;ibase=16;$KERNEL_ENTRY - $BIN_OFFSET" | bc)
echo "add-symbol-file $PWD/$KERNEL_BIN 0x$KRN_OFFSET"



