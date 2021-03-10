#include "xfifo.h"
#include "xfifo_g.c"

int XFIFO_CfgInitialize(XFIFO *InstancePtr, XFIFO_Config *ConfigPtr, UINTPTR EffectiveAddress)
{
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    if (InstancePtr->IsStarted == XIL_COMPONENT_IS_STARTED)
    {
        return XST_DEVICE_IS_STARTED;
    }
    InstancePtr->Config.BaseAddr = EffectiveAddress;
    InstancePtr->Config.DeviceId = ConfigPtr->DeviceId;
    InstancePtr->Config.Depth = ConfigPtr->Depth;
    InstancePtr->Config.Width = ConfigPtr->Width;

    InstancePtr->IsReady = 0;
    InstancePtr->IsStarted = 0;
    InstancePtr->IsEmpty = 0;
    InstancePtr->IsFull = 0;
    InstancePtr->Count = 0;
    InstancePtr->Mode = XFIFO_MODE_SW;

    XFIFO_Reset(InstancePtr);

    return XST_SUCCESS;
}

void XFIFO_Reset(XFIFO *InstancePtr)
{
    Xil_AssertNonvoid(InstancePtr != NULL);

    u32 addr = InstancePtr->Config.BaseAddr;

    
    XFIFO_StartReset(addr, InstancePtr->Mode);
    XFIFO_SetCount(addr, InstancePtr->Config.Depth);
    XFIFO_StopReset(addr);

    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
    InstancePtr->IsStarted = 0;
    InstancePtr->IsEmpty = XFIFO_IsEmpty(addr);
    InstancePtr->IsFull = XFIFO_IsFull(addr);
    InstancePtr->Count = XFIFO_GetCount(addr);
}

u32 XFIFO_Read(XFIFO *InstancePtr, u32 Data[], u32 Start, u32 End, u32 Words)
{
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    if (InstancePtr->IsStarted == XIL_COMPONENT_IS_STARTED)
    {
        return XST_DEVICE_IS_STARTED;
    }

    u32 read = 0, count = InstancePtr->Count;
    u32 addr = InstancePtr->Config.BaseAddr;
    u32 x0;
    XFIFO_SetCount(addr, 0);
    InstancePtr->IsStarted = XIL_COMPONENT_IS_STARTED;

    while (read < End && !(InstancePtr->IsEmpty = XFIFO_IsEmpty(addr)))
    {
        XFIFO_StartRead(addr);
        if (read >= Start)
        {
            x0 = Words * read - Start;
            Data[x0] = XFIFO_ReadReg(addr, XFIFO_DATA0_OFFSET);
            if (Words > 1)
            {
                Data[x0 + 1] = XFIFO_ReadReg(addr, XFIFO_DATA1_OFFSET);
            }
            if (Words > 2)
            {
                Data[x0 + 2] = XFIFO_ReadReg(addr, XFIFO_DATA2_OFFSET);
            }
            if (Words > 3)
            {
                Data[x0 + 3] = XFIFO_ReadReg(addr, XFIFO_DATA3_OFFSET);
            }
        }
        XFIFO_StopRead(addr);
        read++;
    }
    InstancePtr->IsEmpty = XFIFO_IsEmpty(addr);
    InstancePtr->IsFull = XFIFO_IsFull(addr);
    InstancePtr->Count = XFIFO_GetCount(addr);
    InstancePtr->IsStarted = 0;
    return read - Start;
}

u32 XFIFO_Write(XFIFO *InstancePtr, u32 Count, XFIFO_WrAction Action)
{
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    u32 addr = InstancePtr->Config.BaseAddr;

    if (InstancePtr->IsStarted == XIL_COMPONENT_IS_STARTED)
    {
        return XST_DEVICE_IS_STARTED;
    }

    InstancePtr->IsStarted = XIL_COMPONENT_IS_STARTED;

    XFIFO_StartReset(addr, InstancePtr->Mode);
    XFIFO_SetCount(addr, Count);
    XFIFO_StopReset(addr);

    if (Action != NULL)
    {
        XFIFO_StartWrite(addr);
        Action();
        XFIFO_StopWrite(addr);
    }
    else
    {
        XFIFO_StartWrite(addr);
        while (!(InstancePtr->Reached = XFIFO_ReachedThs(addr)) && !(InstancePtr->IsFull = XFIFO_IsFull(addr)))
        {
        }
        XFIFO_StopWrite(addr);
    }

    InstancePtr->IsEmpty = XFIFO_IsEmpty(addr);
    InstancePtr->IsFull = XFIFO_IsFull(addr);
    InstancePtr->Reached = XFIFO_ReachedThs(addr);
    InstancePtr->IsStarted = 0;
    return InstancePtr->Count;
}