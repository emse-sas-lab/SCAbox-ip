#ifndef XRO_H
#define XRO_H

#include "xil_io.h"
#include "xstatus.h"
#include "xro_hw.h"

typedef struct
{
    u16 DeviceId;
    u32 BaseAddr;
    u8 Depth;
    u8 Count;
} XRO_Config;

typedef struct
{
    XRO_Config Config;
    u32 IsReady;
    u32 IsStarted;
} XRO;


XRO_Config XRO_ConfigTable[];

#define XRO_SetId(BaseAddr, Id) \
    XRO_WriteReg((BaseAddr), XRO_SEL_OFFSET, (Id))

#define XRO_ReadState(BaseAddr) \
    XRO_ReadReg((BaseAddr), XRO_STATE_OFFSET)

#define XRO_ReadData(BaseAddr) \
    XRO_ReadReg((BaseAddr), XRO_DATA_OFFSET)

int XRO_CfgInitialize(XRO *InstancePtr, XRO_Config *ConfigPtr);

#endif //XRO_H