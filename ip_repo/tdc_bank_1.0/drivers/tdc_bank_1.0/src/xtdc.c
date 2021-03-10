#include "xtdc.h"
#include "xtdc_g.c"

u8 XTDC_StateWeight(u32 value)
{
    u8 weight = 0;
    for (; value > 0; value >>= 0x1)
    {
        weight += value & 0x1;
    }
    return weight;
}

int XTDC_BitPolarity(u32 value)
{
    return ((value & 0x80000000) == 0);
}

int XTDC_CfgInitialize(XTDC *InstancePtr, XTDC_Config *ConfigPtr)
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
    InstancePtr->Coarse = 0;
    InstancePtr->Fine = 0;

    return XST_SUCCESS;
}

void XTDC_WriteDelay(XTDC *InstancePtr, int Id, u32 fine, u32 coarse)
{
    u32 addr = InstancePtr->Config.BaseAddr;
    if (Id == -1)
    {
        XTDC_WriteReg(addr, XTDC_FINE_OFFSET, fine);
        XTDC_WriteReg(addr, XTDC_COARSE_OFFSET, coarse);
        return;
    }
    u32 old_fine = XTDC_ReadReg(addr, XTDC_FINE_OFFSET);
    u32 old_coarse = XTDC_ReadReg(addr, XTDC_COARSE_OFFSET);
    XTDC_WriteReg(addr, XTDC_FINE_OFFSET, (old_fine & XTDC_Fine_Mask(Id)) | (fine << (4 * Id)));
    XTDC_WriteReg(addr, XTDC_COARSE_OFFSET, (old_coarse & XTDC_Coarse_Mask(Id)) | (coarse << (2 * Id)));
}

u64 XTDC_ReadDelay(XTDC *InstancePtr, int Id)
{
    u32 addr = InstancePtr->Config.BaseAddr;
    u32 fine = XTDC_ReadReg(addr, XTDC_FINE_OFFSET);
    u32 coarse = XTDC_ReadReg(addr, XTDC_COARSE_OFFSET);
    if (Id == -1)
    {
        return XTDC_Delay_64(fine, coarse);
    }
    fine = (fine & ~XTDC_Fine_Mask(Id)) >> (4 * Id);
    coarse = (coarse & ~XTDC_Coarse_Mask(Id)) >> (2 * Id);
    return XTDC_Delay_64(fine, coarse);
}

u64 XTDC_Calibrate(XTDC *InstancePtr, int iterations, int verbose)
{
    iterations = iterations ? iterations : XTDC_DEFAULT_CALIBRATE_IT;
    u32 addr = InstancePtr->Config.BaseAddr;
    u32 best_fine = 0, best_coarse = 0;
    u32 value;
    float avg_value = 0.0;
    float current_best_value = 0.0;
	float best_value = 16.0;
	u32 raw;
    u32 target = InstancePtr->Config.Depth * 2 * iterations;
    int polarity;

    if (verbose)
    {
        printf("target: %lu\n", target / iterations);
        printf("iterations: %d\n", iterations);
    }

    XTDC_WriteDelay(InstancePtr, -1, 0, 0);
    for (int id = 0; id < InstancePtr->Config.Count; id++)
    {
        if (verbose)
        {
            printf("id: %d\n", id);
        }
        current_best_value = 0.0;
        XTDC_WriteReg(addr, XTDC_SEL_OFFSET, id);

        for (u32 coarse = 0; coarse <= XTDC_COARSE_MAX; coarse++)
        {
            for (u32 fine = 0; fine <= XTDC_FINE_MAX; fine++)
            {
                value = 0;
                polarity = 0;
                XTDC_WriteDelay(InstancePtr, id, fine, coarse);

                for (int i = 0; i < iterations; i++)
                {
                    raw = XTDC_ReadReg(addr, XTDC_STATE_OFFSET);
                    value += XTDC_StateWeight(raw);
                    polarity += XTDC_BitPolarity(raw);
                }

                avg_value = (float)(value) / iterations;

                if (verbose)
                {
                    printf("(%lx, %lx): pol= %d it= %d (avg=%5.2f, best=%5.2f)\n", fine, coarse, polarity, iterations,avg_value,current_best_value);
                }

                if((DIST(avg_value,best_value) < DIST(current_best_value,best_value)) && (polarity > (iterations / 2)))
                {
                    current_best_value = avg_value;
                    best_fine = fine;
                    best_coarse = coarse;
                }
            }
        }
        if(verbose)
        {
            printf("best: (%lx, %lx)\n", best_fine, best_coarse);
        }
        XTDC_WriteDelay(InstancePtr, id, best_fine, best_coarse);
    }
    return XTDC_ReadDelay(InstancePtr, -1);
}


