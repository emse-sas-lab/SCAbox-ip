/**
 * @file aes.h
 * @author Sami Dahoux (s.dahoux@emse.fr)
 * @brief AES 128 driver that allows direct and inverse encryption.
 */

#ifndef XAES_H
#define XAES_H

#include "xil_io.h"
#include "xstatus.h"
#include "xaes_hw.h"

#define XAES_ENCRYPT XAES_STATUS_NULL_MASK
#define XAES_DECRYPT XAES_STATUS_INV_MASK

typedef struct
{
    u16 DeviceId;
    u32 BaseAddr;
} XAES_Config;

typedef struct
{
    XAES_Config Config;
    u32 IsReady;
    u32 IsStarted;
} XAES;

XAES_Config XAES_ConfigTable[];

int XAES_CfgInitialize(XAES *InstancePtr, XAES_Config *ConfigPtr);

/** 
 * @brief Resets the hardware device and set the encryption mode
 * @param mode set encryption or decryption
 */
void XAES_Reset(const XAES *InstancePtr, u32 Mode);

/**
 * @brief Writes input block data
 * @param Data input block data
 */
void XAES_SetInput(const XAES *InstancePtr, const u32 Data[]);

/**
 * @brief Writes key block data
 * @param Data key block data
 */
void XAES_SetKey(const XAES *InstancePtr, const u32 Data[]);

/**
 * @brief Reads input block data
 * @param Data input block data
 */
void XAES_GetInput(const XAES *InstancePtr, u32 Data[]);

/**
 * @brief Reads key block data
 * @param Data key block Data
 */
void XAES_GetKey(const XAES *InstancePtr, u32 Data[]);

/** 
 * @brief Reads outpout block data
 * @param Data output block Data
 */
void XAES_GetOutput(const XAES *InstancePtr, u32 Data[]);

/**
 * @brief Starts hardware AES computing and wait until done
 */
void XAES_Run(const XAES *InstancePtr);

#endif //XAES_H
