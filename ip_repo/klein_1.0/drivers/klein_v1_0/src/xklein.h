/**
 * @file aes.h
 * @author Sami Dahoux (s.dahoux@emse.fr)
 * @brief KLEIN 128 driver that allows direct and inverse encryption.
 */

#ifndef XKLEIN_H
#define XKLEIN_H

#include "xil_io.h"
#include "xstatus.h"
#include "xklein_hw.h"

#define XKLEIN_ENCRYPT XKLEIN_STATUS_NULL_MASK
#define XKLEIN_DECRYPT XKLEIN_STATUS_INV_MASK

typedef struct
{
    u16 DeviceId;
    u32 BaseAddr;
} XKLEIN_Config;

typedef struct
{
    XKLEIN_Config Config;
    u32 IsReady;
    u32 IsStarted;
} XKLEIN;

XKLEIN_Config XKLEIN_ConfigTable[];

int XKLEIN_CfgInitialize(XKLEIN *InstancePtr, XKLEIN_Config *ConfigPtr);

/** 
 * @brief Resets the hardware device and set the encryption mode
 * @param mode set encryption or decryption
 */
void XKLEIN_Reset(const XKLEIN *InstancePtr, u32 Mode);

/**
 * @brief Writes input block data
 * @param Data input block data
 */
void XKLEIN_SetInput(const XKLEIN *InstancePtr, const u32 Data[]);

/**
 * @brief Writes key block data
 * @param Data key block data
 */
void XKLEIN_SetKey(const XKLEIN *InstancePtr, const u32 Data[]);

/**
 * @brief Reads input block data
 * @param Data input block data
 */
void XKLEIN_GetInput(const XKLEIN *InstancePtr, u32 Data[]);

/**
 * @brief Reads key block data
 * @param Data key block Data
 */
void XKLEIN_GetKey(const XKLEIN *InstancePtr, u32 Data[]);

/** 
 * @brief Reads outpout block data
 * @param Data output block Data
 */
void XKLEIN_GetOutput(const XKLEIN *InstancePtr, u32 Data[]);

/**
 * @brief Starts hardware KLEIN computing and wait until done
 */
void XKLEIN_Run(const XKLEIN *InstancePtr);

#endif //XKLEIN_H
