#define XAES_WORDS_SIZE 4
#define XAES_BYTES_SIZE 16

#define XAES_DATA_IN0_OFFSET 0x00
#define XAES_DATA_IN1_OFFSET 0x04
#define XAES_DATA_IN2_OFFSET 0x08
#define XAES_DATA_IN3_OFFSET 0x0C

#define XAES_DATA_OUT0_OFFSET 0x10
#define XAES_DATA_OUT1_OFFSET 0x14
#define XAES_DATA_OUT2_OFFSET 0x18
#define XAES_DATA_OUT3_OFFSET 0x1C

#define XAES_DATA_KEY0_OFFSET 0x20
#define XAES_DATA_KEY1_OFFSET 0x24
#define XAES_DATA_KEY2_OFFSET 0x28
#define XAES_DATA_KEY3_OFFSET 0x2c

#define XAES_STATUS_WR_OFFSET 0x30
#define XAES_STATUS_RD_OFFSET 0x34

#define XAES_STATUS_NULL_MASK 0x0
#define XAES_STATUS_RESET_MASK 0x1
#define XAES_STATUS_START_MASK 0x2
#define XAES_STATUS_INV_MASK 0x4
#define XAES_STATUS_DONE_MASK 0x1

#define XAES_SetStatus1(status, reg) \
    (reg | status)
#define XAES_SetStatus0(status, reg) \
    (reg & ~status)
#define XAES_GetStatus(status, reg) \
    (reg & status)

#define XAES_ReadReg(addr, offset) \
    Xil_In32((addr) + (offset))
#define XAES_WriteReg(addr, offset, data) \
    Xil_Out32((addr) + (offset), (data))