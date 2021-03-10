#define XRO_DATA_OFFSET 0x00
#define XRO_STATE_OFFSET 0x04
#define XRO_SEL_OFFSET 0x08

#define XRO_ReadReg(addr, offset) \
    Xil_In32((addr) + (offset))
#define XRO_WriteReg(addr, offset, data) \
    Xil_Out32((addr) + (offset), (data))