#include "xaes.h"
#include "xaes_g.c"

int XAES_CfgInitialize(XAES *InstancePtr, XAES_Config *ConfigPtr)
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

void XAES_Reset(const XAES *InstancePtr, u32 Mode)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAES_WriteReg(
        InstancePtr->Config.BaseAddr,
        XAES_STATUS_WR_OFFSET,
        XAES_SetStatus1(XAES_STATUS_RESET_MASK,
                        Mode));

    XAES_WriteReg(
        InstancePtr->Config.BaseAddr,
        XAES_STATUS_WR_OFFSET,
        XAES_SetStatus0(XAES_STATUS_RESET_MASK,
                        XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_STATUS_WR_OFFSET)));
}

void XAES_SetInput(const XAES *InstancePtr, const u32 Data[])
{
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN0_OFFSET, Data[0]);
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN1_OFFSET, Data[1]);
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN2_OFFSET, Data[2]);
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN3_OFFSET, Data[3]);
}

void XAES_SetKey(const XAES *InstancePtr, const u32 Data[])
{
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY0_OFFSET, Data[0]);
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY1_OFFSET, Data[1]);
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY2_OFFSET, Data[2]);
    XAES_WriteReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY3_OFFSET, Data[3]);
}

void XAES_GetInput(const XAES *InstancePtr, u32 Data[])
{
    Data[0] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN0_OFFSET);
    Data[1] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN1_OFFSET);
    Data[2] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN2_OFFSET);
    Data[3] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_IN3_OFFSET);
}

void XAES_GetKey(const XAES *InstancePtr, u32 Data[])
{
    Data[0] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY0_OFFSET);
    Data[1] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY1_OFFSET);
    Data[2] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY2_OFFSET);
    Data[3] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_KEY3_OFFSET);
}

void XAES_GetOutput(const XAES *InstancePtr, u32 Data[])
{
    Data[0] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_OUT0_OFFSET);
    Data[1] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_OUT1_OFFSET);
    Data[2] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_OUT2_OFFSET);
    Data[3] = XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_DATA_OUT3_OFFSET);
}

void XAES_Run(const XAES *InstancePtr)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAES_WriteReg(
        InstancePtr->Config.BaseAddr,
        XAES_STATUS_WR_OFFSET,
        XAES_SetStatus1(XAES_STATUS_START_MASK,
                        XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_STATUS_WR_OFFSET)));

    while (!XAES_GetStatus(
        XAES_STATUS_DONE_MASK,
        XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_STATUS_RD_OFFSET)))
    {
    }

    XAES_WriteReg(
        InstancePtr->Config.BaseAddr,
        XAES_STATUS_WR_OFFSET,
        XAES_SetStatus0(XAES_STATUS_START_MASK,
                        XAES_ReadReg(InstancePtr->Config.BaseAddr, XAES_STATUS_WR_OFFSET)));
}
