
#include "xro.h"
#include "xro_g.c"

int XRO_CfgInitialize(XRO *InstancePtr, XRO_Config *ConfigPtr)
{
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    if (InstancePtr->IsStarted == XIL_COMPONENT_IS_STARTED)
    {
        return XST_DEVICE_IS_STARTED;
    }
    InstancePtr->Config.DeviceId = ConfigPtr->DeviceId;
    InstancePtr->Config.BaseAddr = ConfigPtr->BaseAddr;
    InstancePtr->Config.Depth = ConfigPtr->Depth;
    InstancePtr->Config.Count = ConfigPtr->Count;
    InstancePtr->IsStarted = 0;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}