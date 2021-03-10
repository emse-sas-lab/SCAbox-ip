#include "xcrypton.h"
#include "xcrypton_g.c"

int XCRYPTON_CfgInitialize(XCRYPTON *InstancePtr, XCRYPTON_Config *ConfigPtr)
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

void XCRYPTON_Reset(const XCRYPTON *InstancePtr, u32 Mode)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCRYPTON_WriteReg(
        InstancePtr->Config.BaseAddr,
        XCRYPTON_STATUS_WR_OFFSET,
        XCRYPTON_SetStatus1(XCRYPTON_STATUS_RESET_MASK,
                        Mode));

    XCRYPTON_WriteReg(
        InstancePtr->Config.BaseAddr,
        XCRYPTON_STATUS_WR_OFFSET,
        XCRYPTON_SetStatus0(XCRYPTON_STATUS_RESET_MASK,
                        XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_STATUS_WR_OFFSET)));
}

void XCRYPTON_SetInput(const XCRYPTON *InstancePtr, const u32 Data[])
{
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN0_OFFSET, Data[0]);
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN1_OFFSET, Data[1]);
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN2_OFFSET, Data[2]);
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN3_OFFSET, Data[3]);
}

void XCRYPTON_SetKey(const XCRYPTON *InstancePtr, const u32 Data[])
{
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY0_OFFSET, Data[0]);
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY1_OFFSET, Data[1]);
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY2_OFFSET, Data[2]);
    XCRYPTON_WriteReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY3_OFFSET, Data[3]);
}

void XCRYPTON_GetInput(const XCRYPTON *InstancePtr, u32 Data[])
{
    Data[0] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN0_OFFSET);
    Data[1] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN1_OFFSET);
    Data[2] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN2_OFFSET);
    Data[3] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_IN3_OFFSET);
}

void XCRYPTON_GetKey(const XCRYPTON *InstancePtr, u32 Data[])
{
    Data[0] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY0_OFFSET);
    Data[1] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY1_OFFSET);
    Data[2] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY2_OFFSET);
    Data[3] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_KEY3_OFFSET);
}

void XCRYPTON_GetOutput(const XCRYPTON *InstancePtr, u32 Data[])
{
    Data[0] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_OUT0_OFFSET);
    Data[1] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_OUT1_OFFSET);
    Data[2] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_OUT2_OFFSET);
    Data[3] = XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_DATA_OUT3_OFFSET);
}

void XCRYPTON_Run(const XCRYPTON *InstancePtr)
{
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XCRYPTON_WriteReg(
        InstancePtr->Config.BaseAddr,
        XCRYPTON_STATUS_WR_OFFSET,
        XCRYPTON_SetStatus1(XCRYPTON_STATUS_START_MASK,
                        XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_STATUS_WR_OFFSET)));

    while (!XCRYPTON_GetStatus(
        XCRYPTON_STATUS_DONE_MASK,
        XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_STATUS_RD_OFFSET)))
    {
    }

    XCRYPTON_WriteReg(
        InstancePtr->Config.BaseAddr,
        XCRYPTON_STATUS_WR_OFFSET,
        XCRYPTON_SetStatus0(XCRYPTON_STATUS_START_MASK,
                        XCRYPTON_ReadReg(InstancePtr->Config.BaseAddr, XCRYPTON_STATUS_WR_OFFSET)));
}
