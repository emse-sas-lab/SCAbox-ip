#define XFIFO_WORD_SIZE 4

#define XFIFO_DATA0_OFFSET 0x00
#define XFIFO_DATA1_OFFSET 0x04
#define XFIFO_DATA2_OFFSET 0x08
#define XFIFO_DATA3_OFFSET 0x0c
#define XFIFO_STATUS_RD_OFFSET 0x10
#define XFIFO_STATUS_WR_OFFSET 0x14
#define XFIFO_COUNT_OUT_OFFSET 0x18
#define XFIFO_COUNT_IN_OFFSET 0x1c

#define XFIFO_STATUS_EMPTY_MASK 0x1
#define XFIFO_STATUS_FULL_MASK 0x2
#define XFIFO_STATUS_REACHED_MASK 0x4

#define XFIFO_STATUS_NULL_MASK 0x0
#define XFIFO_STATUS_RESET_MASK 0x1
#define XFIFO_STATUS_READ_MASK 0x2
#define XFIFO_STATUS_WRITE_MASK 0x4
#define XFIFO_STATUS_MODE_MASK 0x8

#define XFIFO_SetStatus1(status, reg) \
    (reg | status)
#define XFIFO_SetStatus0(status, reg) \
    (reg & ~status)

#define XFIFO_GetStatus(status, reg) \
    (reg & status)

#define XFIFO_ReadReg(addr, offset) \
    Xil_In32((addr) + (offset))

#define XFIFO_WriteReg(addr, offset, data) \
    Xil_Out32((addr) + (offset), (data))
