        .global _start

        .section .text

_start:
        csrr t0, mhartid
        mv tp, t0
        bnez t0, park
        csrw satp, zero
        .option push
        .option norelax
        la gp, _global_pointer
        .option pop
        la a0, _bss_start
        la a1, _bss_end
        bgeu a0, a1, clear_bss_done

clear_bss:
        sd zero, (a0)
        addi a0, a0, 8
        bltu a0, a1, clear_bss

clear_bss_done:
        li t0, 0xffff
        csrw medeleg, t0
        csrw mideleg, t0
        la sp, _stack_start
        la a0, _stack_size
        addi a1, tp, 1
        mul a0, a0, a1
        add sp, sp, a0
        li t0, -1
        csrw pmpaddr0, t0
        li t0, 0x1f
        csrw pmpcfg0, t0
        li t1, (1 << 11) | (1 << 7) | (1 << 3)
        csrw mstatus, t1
        la t2, start_kernel
        csrw mepc, t2
        la t3, mtrap_vector
        csrw mtvec, t3
        li t4, (1 << 11) | (1 << 7) | (1 << 3)
        csrw mie, t4
        la ra, park
        mret

park:
        wfi
        j park
