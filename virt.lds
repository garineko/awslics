OUTPUT_ARCH(riscv)

ENTRY(_start)

MEMORY {
        ram (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS {
        PROVIDE(_ram_start = ORIGIN(ram));
        PROVIDE(_ram_end = ORIGIN(ram) + LENGTH(ram));

        .text : {
                . = ALIGN(4K);
                PROVIDE(_text_start = .);
                * (.text .text.*)
                PROVIDE(_text_end = .);
        } > ram

        .rodata : {
                . = ALIGN(4K);
                PROVIDE(_rodata_start = .);
                * (.rodata .rodata.*)
                * (.srodata .srodata.*)
                PROVIDE(_rodata_end = .);
        } > ram

        .data : {
                . = ALIGN(4K);
                PROVIDE(_data_start = .);
                PROVIDE(_global_pointer = _data_start + 2K);
                * (.data .data.*)
                * (.sdata .sdata.*)
                PROVIDE(_data_end = .);
        } > ram

        .bss : {
                . = ALIGN(4K);
                PROVIDE(_bss_start = .);
                * (.bss .bss.*)
                * (.sbss .sbss.*)
                * (COMMON)
                PROVIDE(_bss_end = .);
        } > ram

        PROVIDE(_stack_size = 4K);
        PROVIDE(_maximum_hart = 8);
        PROVIDE(_stack_start = _ram_end - _stack_size * _maximum_hart);
        PROVIDE(_stack_end = _ram_end);

        PROVIDE(_heap_start = _bss_end);
        PROVIDE(_heap_end = _stack_start);
}
