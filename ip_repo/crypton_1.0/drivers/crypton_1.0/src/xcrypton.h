/**
 * @file crypton.h
 * @author Sami Dahoux (s.dahoux@emse.fr)
 * @brief CRYPTON 128 driver that allows direct and inverse encryption.
 */

#ifndef XCRYPTON_H
#define XCRYPTON_H

#include "xil_io.h"
#include "xstatus.h"
#include "xcrypton_hw.h"

#define XCRYPTON_ENCRYPT XCRYPTON_STATUS_NULL_MASK
#define XCRYPTON_DECRYPT XCRYPTON_STATUS_INV_MASK

typedef struct
{
    u16 DeviceId;
    u32 BaseAddr;
} XCRYPTON_Config;

typedef struct
{
    XCRYPTON_Config Config;
    u32 IsReady;
    u32 IsStarted;
} XCRYPTON;

XCRYPTON_Config XCRYPTON_ConfigTable[];

int XCRYPTON_CfgInitialize(XCRYPTON *InstancePtr, XCRYPTON_Config *ConfigPtr);

/** 
 * @brief Resets the hardware device and set the encryption mode
 * @param mode set encryption or decryption
 */
void XCRYPTON_Reset(const XCRYPTON *InstancePtr, u32 Mode);

/**
 * @brief Writes input block data
 * @param Data input block data
 */
void XCRYPTON_SetInput(const XCRYPTON *InstancePtr, const u32 Data[]);

/**
 * @brief Writes key block data
 * @param Data key block data
 */
void XCRYPTON_SetKey(const XCRYPTON *InstancePtr, const u32 Data[]);

/**
 * @brief Reads input block data
 * @param Data input block data
 */
void XCRYPTON_GetInput(const XCRYPTON *InstancePtr, u32 Data[]);

/**
 * @brief Reads key block data
 * @param Data key block Data
 */
void XCRYPTON_GetKey(const XCRYPTON *InstancePtr, u32 Data[]);

/** 
 * @brief Reads outpout block data
 * @param Data output block Data
 */
void XCRYPTON_GetOutput(const XCRYPTON *InstancePtr, u32 Data[]);

/**
 * @brief Starts hardware CRYPTON computing and wait until done
 */
void XCRYPTON_Run(const XCRYPTON *InstancePtr);

#endif //XCRYPTON_H
