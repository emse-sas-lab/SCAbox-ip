#define XKLEIN_WORDS_SIZE 4
#define XKLEIN_BYTES_SIZE 16

#define XKLEIN_DATA_IN0_OFFSET 0x00
#define XKLEIN_DATA_IN1_OFFSET 0x04

#define XKLEIN_DATA_OUT0_OFFSET 0x18
#define XKLEIN_DATA_OUT1_OFFSET 0x1C

#define XKLEIN_DATA_KEY0_OFFSET 0x20
#define XKLEIN_DATA_KEY1_OFFSET 0x24
#define XKLEIN_DATA_KEY2_OFFSET 0x28
#define XKLEIN_DATA_KEY3_OFFSET 0x2c

#define XKLEIN_STATUS_WR_OFFSET 0x30
#define XKLEIN_STATUS_RD_OFFSET 0x34

#define XKLEIN_STATUS_NULL_MASK 0x0
#define XKLEIN_STATUS_RESET_MASK 0x1
#define XKLEIN_STATUS_START_MASK 0x2
#define XKLEIN_STATUS_DONE_MASK 0x1

#define XKLEIN_SetStatus1(status, reg) \
    (reg | status)
#define XKLEIN_SetStatus0(status, reg) \
    (reg & ~status)
#define XKLEIN_GetStatus(status, reg) \
    (reg & status)

#define XKLEIN_ReadReg(addr, offset) \
    Xil_In32((addr) + (offset))
#define XKLEIN_WriteReg(addr, offset, data) \
    Xil_Out32((addr) + (offset), (data))