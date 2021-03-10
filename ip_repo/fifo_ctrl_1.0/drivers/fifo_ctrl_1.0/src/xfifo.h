/**
 * @file fifo_hw.h
 * @author Sami Dahoux (s.dahoux@emse.fr)
 * @brief Driver for the FIFO controller IP contained in the test system vivado_sca
 * 
 * The FIFO controller performs asymmetric operations on a FIFO :
 * - pushes values from a hardware device
 * - pops values into the CPU
 * 
 * Pushes can only be initiated and stopped by this software. 
 * The value are added to the FIFO at a sampling rate that depends on the hardware and the addition stops when the FIFO is full.
 * 
 * Pops can be initiated and stopped by this software.
 * The popped values can be read via the corresponding API.
 */

#ifndef XFIFO_H
#define XFIFO_H

#include "xil_io.h"
#include "xstatus.h"
#include "xfifo_hw.h"

#define XFIFO_MODE_SW XFIFO_STATUS_NULL_MASK
#define XFIFO_MODE_HW XFIFO_STATUS_MODE_MASK

#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef void (*XFIFO_WrAction)(void);

typedef struct
{
    u16 DeviceId;
    u32 BaseAddr;
    u32 Depth;
    u32 Width;
} XFIFO_Config;

typedef struct
{
    XFIFO_Config Config;
    u32 IsReady;
    u32 IsStarted;
    u32 IsEmpty;
    u32 IsFull;
    u32 Mode;
    u32 Count;
    u32 Reached;
} XFIFO;

/**
 * @brief Checks if the FIFO is empty
 * @return 1 if the FIFO is empty 0 otherwise
 */
#define XFIFO_IsEmpty(BaseAddr)              \
    XFIFO_GetStatus(XFIFO_STATUS_EMPTY_MASK, \
                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_RD_OFFSET))

/**
 * @brief Checks if the FIFO is full
 * @return 1 if the FIFO is full 0 otherwise
 */
#define XFIFO_IsFull(BaseAddr)              \
    XFIFO_GetStatus(XFIFO_STATUS_FULL_MASK, \
                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_RD_OFFSET))

#define XFIFO_ReachedThs(BaseAddr)             \
    XFIFO_GetStatus(XFIFO_STATUS_REACHED_MASK, \
                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_RD_OFFSET))

/**
 * @brief Set read status signal to 1 into the hardware
 */
#define XFIFO_StartRead(BaseAddr)                           \
    XFIFO_WriteReg((BaseAddr),                              \
                   XFIFO_STATUS_WR_OFFSET,                  \
                   XFIFO_SetStatus1(XFIFO_STATUS_READ_MASK, \
                                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_WR_OFFSET)))

/**
 * @brief Set read status signal to 0 into the hardware
 */
#define XFIFO_StopRead(BaseAddr)                            \
    XFIFO_WriteReg((BaseAddr),                              \
                   XFIFO_STATUS_WR_OFFSET,                  \
                   XFIFO_SetStatus0(XFIFO_STATUS_READ_MASK, \
                                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_WR_OFFSET)))

/**
 * @brief Set the write status signal to 1
 */
#define XFIFO_StartWrite(BaseAddr)                           \
    XFIFO_WriteReg((BaseAddr),                               \
                   XFIFO_STATUS_WR_OFFSET,                   \
                   XFIFO_SetStatus1(XFIFO_STATUS_WRITE_MASK, \
                                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_WR_OFFSET)))
/**
 * @brief Set the write status signal to 0
 */
#define XFIFO_StopWrite(BaseAddr)                            \
    XFIFO_WriteReg((BaseAddr),                               \
                   XFIFO_STATUS_WR_OFFSET,                   \
                   XFIFO_SetStatus0(XFIFO_STATUS_WRITE_MASK, \
                                    XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_WR_OFFSET)))

#define XFIFO_StartReset(BaseAddr, Mode) \
    XFIFO_WriteReg(                      \
        (BaseAddr),                      \
        XFIFO_STATUS_WR_OFFSET,          \
        XFIFO_SetStatus1(XFIFO_STATUS_RESET_MASK, (Mode)))

#define XFIFO_StopReset(BaseAddr)                 \
    XFIFO_WriteReg(                               \
        (BaseAddr),                               \
        XFIFO_STATUS_WR_OFFSET,                   \
        XFIFO_SetStatus0(XFIFO_STATUS_RESET_MASK, \
                         XFIFO_ReadReg((BaseAddr), XFIFO_STATUS_WR_OFFSET)))

#define XFIFO_SetCount(BaseAddr, Count)   \
    XFIFO_WriteReg((BaseAddr),            \
                   XFIFO_COUNT_IN_OFFSET, \
                   (Count))

#define XFIFO_GetCount(BaseAddr) \
    XFIFO_ReadReg((BaseAddr),    \
                  XFIFO_COUNT_OUT_OFFSET)

XFIFO_Config XFIFO_ConfigTable[];

int XFIFO_CfgInitialize(XFIFO *InstancePtr, XFIFO_Config *ConfigPtr, UINTPTR EffectiveAddress);

/**
 * @brief Flushes the FIFO
 */
void XFIFO_Reset(XFIFO *InstancePtr);

/**
 * @brief Pops all the values contained in the FIFO
 * 
 * @param Data buffer for contained values
 * @param Start Index of first value to read.
 * @param End Ending index.
 * @return number of elements read until the FIFO is empty or `XFIFO_ERR_NONE`
 */
u32 XFIFO_Read(XFIFO *InstancePtr, u32 Data[], u32 Start, u32 End, u32 Words);

u32 XFIFO_Write(XFIFO *InstancePtr, u32 End, XFIFO_WrAction Action);

#endif //XFIFO_H