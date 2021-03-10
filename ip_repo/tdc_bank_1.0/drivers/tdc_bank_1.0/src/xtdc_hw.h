#include "xil_io.h"

#define XTDC_WORD_SIZE 4

#define XTDC_DATA_OFFSET 0x00
#define XTDC_STATE_OFFSET 0x04

#define XTDC_SEL_OFFSET 0x08
#define XTDC_COARSE_OFFSET 0x0c
#define XTDC_FINE_OFFSET 0x10

#define XTDC_DEFAULT_CALIBRATE_IT 8192
#define XTDC_CALIBRATE_TARGET 16
#define XTDC_COARSE_MAX 0x3
#define XTDC_FINE_MAX 0xf

#define XTDC_Delay_64(fine, coarse) \
    ((((u64)(coarse) << 32) | ((u64)(fine) & 0xffffffff)))
#define XTDC_Fine_Mask(id) \
    ~((u32)(0x0000000f << (4 * (id))))
#define XTDC_Coarse_Mask(id) \
    ~((u32)(0x00000003 << (2 * (id))))
#define XTDC_Weight_Mask(id) \
    ~((u32)(0x000000ff << (8 * (id))))
#define XTDC_Weight(weights, id) \
    ((u32)(((weights) & ~XTDC_Weight_Mask(id)) >> (8 * (id))))

#define XTDC_ReadReg(addr, offset) \
    Xil_In32((addr) + (offset))
#define XTDC_WriteReg(addr, offset, data) \
    Xil_Out32((addr) + (offset), (data))

#define XTDC_Offset(count, len) \
    count * len * 2