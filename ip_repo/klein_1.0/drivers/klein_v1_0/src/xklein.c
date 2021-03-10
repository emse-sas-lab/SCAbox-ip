#include "xklein.h"
#include "xklein_g.c"

int XKLEIN_CfgInitialize(XKLEIN *InstancePtr, XKLEIN_Config *ConfigPtr)
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

void XKLEIN_Reset(const XKLEIN *InstancePtr, u32 Mode)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKLEIN_WriteReg(
        InstancePtr->Config.BaseAddr,
        XKLEIN_STATUS_WR_OFFSET,
        XKLEIN_SetStatus1(XKLEIN_STATUS_RESET_MASK,
                        Mode));

    XKLEIN_WriteReg(
        InstancePtr->Config.BaseAddr,
        XKLEIN_STATUS_WR_OFFSET,
        XKLEIN_SetStatus0(XKLEIN_STATUS_RESET_MASK,
                        XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_STATUS_WR_OFFSET)));
}

void XKLEIN_SetInput(const XKLEIN *InstancePtr, const u32 Data[])
{
    XKLEIN_WriteReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_IN0_OFFSET, Data[0]);
    XKLEIN_WriteReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_IN1_OFFSET, Data[1]);
}

void XKLEIN_SetKey(const XKLEIN *InstancePtr, const u32 Data[])
{
    XKLEIN_WriteReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY0_OFFSET, Data[0]);
    XKLEIN_WriteReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY1_OFFSET, Data[1]);
    XKLEIN_WriteReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY2_OFFSET, Data[2]);
    XKLEIN_WriteReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY3_OFFSET, Data[3]);
}

void XKLEIN_GetInput(const XKLEIN *InstancePtr, u32 Data[])
{
    Data[0] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_IN0_OFFSET);
    Data[1] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_IN1_OFFSET);
}

void XKLEIN_GetKey(const XKLEIN *InstancePtr, u32 Data[])
{
    Data[0] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY0_OFFSET);
    Data[1] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY1_OFFSET);
    Data[2] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY2_OFFSET);
    Data[3] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_KEY3_OFFSET);
}

void XKLEIN_GetOutput(const XKLEIN *InstancePtr, u32 Data[])
{
    Data[0] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_OUT0_OFFSET);
    Data[1] = XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_DATA_OUT1_OFFSET);
}

void XKLEIN_Run(const XKLEIN *InstancePtr)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKLEIN_WriteReg(
        InstancePtr->Config.BaseAddr,
        XKLEIN_STATUS_WR_OFFSET,
        XKLEIN_SetStatus1(XKLEIN_STATUS_START_MASK,
                        XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_STATUS_WR_OFFSET)));

    while (!XKLEIN_GetStatus(
        XKLEIN_STATUS_DONE_MASK,
        XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_STATUS_RD_OFFSET)))
    {
    }

    XKLEIN_WriteReg(
        InstancePtr->Config.BaseAddr,
        XKLEIN_STATUS_WR_OFFSET,
        XKLEIN_SetStatus0(XKLEIN_STATUS_START_MASK,
                        XKLEIN_ReadReg(InstancePtr->Config.BaseAddr, XKLEIN_STATUS_WR_OFFSET)));
}
