#define XPRESENT_WORDS_SIZE 4
#define XPRESENT_BYTES_SIZE 16

#define XPRESENT_DATA_IN0_OFFSET 0x00
#define XPRESENT_DATA_IN1_OFFSET 0x04

#define XPRESENT_DATA_OUT0_OFFSET 0x18
#define XPRESENT_DATA_OUT1_OFFSET 0x1C

#define XPRESENT_DATA_KEY0_OFFSET 0x20
#define XPRESENT_DATA_KEY1_OFFSET 0x24
#define XPRESENT_DATA_KEY2_OFFSET 0x28
#define XPRESENT_DATA_KEY3_OFFSET 0x2c

#define XPRESENT_STATUS_WR_OFFSET 0x30
#define XPRESENT_STATUS_RD_OFFSET 0x34

#define XPRESENT_STATUS_NULL_MASK 0x0
#define XPRESENT_STATUS_RESET_MASK 0x1
#define XPRESENT_STATUS_START_MASK 0x2
#define XPRESENT_STATUS_DONE_MASK 0x1

#define XPRESENT_SetStatus1(status, reg) \
    (reg | status)
#define XPRESENT_SetStatus0(status, reg) \
    (reg & ~status)
#define XPRESENT_GetStatus(status, reg) \
    (reg & status)

#define XPRESENT_ReadReg(addr, offset) \
    Xil_In32((addr) + (offset))
#define XPRESENT_WriteReg(addr, offset, data) \
    Xil_Out32((addr) + (offset), (data))