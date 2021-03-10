/**
 * @file aes.h
 * @author Sami Dahoux (s.dahoux@emse.fr)
 * @brief PRESENT 128 driver that allows direct and inverse encryption.
 */

#ifndef XPRESENT_H
#define XPRESENT_H

#include "xil_io.h"
#include "xstatus.h"
#include "xpresent_hw.h"

#define XPRESENT_ENCRYPT XPRESENT_STATUS_NULL_MASK
#define XPRESENT_DECRYPT XPRESENT_STATUS_INV_MASK

typedef struct
{
    u16 DeviceId;
    u32 BaseAddr;
} XPRESENT_Config;

typedef struct
{
    XPRESENT_Config Config;
    u32 IsReady;
    u32 IsStarted;
} XPRESENT;

XPRESENT_Config XPRESENT_ConfigTable[];

int XPRESENT_CfgInitialize(XPRESENT *InstancePtr, XPRESENT_Config *ConfigPtr);

/** 
 * @brief Resets the hardware device and set the encryption mode
 * @param mode set encryption or decryption
 */
void XPRESENT_Reset(const XPRESENT *InstancePtr, u32 Mode);

/**
 * @brief Writes input block data
 * @param Data input block data
 */
void XPRESENT_SetInput(const XPRESENT *InstancePtr, const u32 Data[]);

/**
 * @brief Writes key block data
 * @param Data key block data
 */
void XPRESENT_SetKey(const XPRESENT *InstancePtr, const u32 Data[]);

/**
 * @brief Reads input block data
 * @param Data input block data
 */
void XPRESENT_GetInput(const XPRESENT *InstancePtr, u32 Data[]);

/**
 * @brief Reads key block data
 * @param Data key block Data
 */
void XPRESENT_GetKey(const XPRESENT *InstancePtr, u32 Data[]);

/** 
 * @brief Reads outpout block data
 * @param Data output block Data
 */
void XPRESENT_GetOutput(const XPRESENT *InstancePtr, u32 Data[]);

/**
 * @brief Starts hardware PRESENT computing and wait until done
 */
void XPRESENT_Run(const XPRESENT *InstancePtr);

#endif //XPRESENT_H
