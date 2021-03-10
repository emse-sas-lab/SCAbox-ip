#include "xpresent.h"
#include "xpresent_g.c"

int XPRESENT_CfgInitialize(XPRESENT *InstancePtr, XPRESENT_Config *ConfigPtr)
{
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    if (InstancePtr->IsStarted == XIL_COMPONENT_IS_STARTED)
    {
        return XST_DEVICE_IS_STARTED;
    }
    InstancePtr->Config.DeviceId = ConfigPtr->DeviceId;
    InstancePtr->Config.BaseAddr = ConfigPtr->BaseAddr;
    InstancePtr->IsStarted = 0;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}

void XPRESENT_Reset(const XPRESENT *InstancePtr, u32 Mode)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPRESENT_WriteReg(
        InstancePtr->Config.BaseAddr,
        XPRESENT_STATUS_WR_OFFSET,
        XPRESENT_SetStatus1(XPRESENT_STATUS_RESET_MASK,
                        Mode));

    XPRESENT_WriteReg(
        InstancePtr->Config.BaseAddr,
        XPRESENT_STATUS_WR_OFFSET,
        XPRESENT_SetStatus0(XPRESENT_STATUS_RESET_MASK,
                        XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_STATUS_WR_OFFSET)));
}

void XPRESENT_SetInput(const XPRESENT *InstancePtr, const u32 Data[])
{
    XPRESENT_WriteReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_IN0_OFFSET, Data[0]);
    XPRESENT_WriteReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_IN1_OFFSET, Data[1]);
}

void XPRESENT_SetKey(const XPRESENT *InstancePtr, const u32 Data[])
{
    XPRESENT_WriteReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY0_OFFSET, Data[0]);
    XPRESENT_WriteReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY1_OFFSET, Data[1]);
    XPRESENT_WriteReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY2_OFFSET, Data[2]);
    XPRESENT_WriteReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY3_OFFSET, Data[3]);
}

void XPRESENT_GetInput(const XPRESENT *InstancePtr, u32 Data[])
{
    Data[0] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_IN0_OFFSET);
    Data[1] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_IN1_OFFSET);
}

void XPRESENT_GetKey(const XPRESENT *InstancePtr, u32 Data[])
{
    Data[0] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY0_OFFSET);
    Data[1] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY1_OFFSET);
    Data[2] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY2_OFFSET);
    Data[3] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_KEY3_OFFSET);
}

void XPRESENT_GetOutput(const XPRESENT *InstancePtr, u32 Data[])
{
    Data[0] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_OUT0_OFFSET);
    Data[1] = XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_DATA_OUT1_OFFSET);
}

void XPRESENT_Run(const XPRESENT *InstancePtr)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPRESENT_WriteReg(
        InstancePtr->Config.BaseAddr,
        XPRESENT_STATUS_WR_OFFSET,
        XPRESENT_SetStatus1(XPRESENT_STATUS_START_MASK,
                        XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_STATUS_WR_OFFSET)));

    while (!XPRESENT_GetStatus(
        XPRESENT_STATUS_DONE_MASK,
        XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_STATUS_RD_OFFSET)))
    {
    }

    XPRESENT_WriteReg(
        InstancePtr->Config.BaseAddr,
        XPRESENT_STATUS_WR_OFFSET,
        XPRESENT_SetStatus0(XPRESENT_STATUS_START_MASK,
                        XPRESENT_ReadReg(InstancePtr->Config.BaseAddr, XPRESENT_STATUS_WR_OFFSET)));
}
