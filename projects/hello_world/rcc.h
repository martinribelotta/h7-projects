#ifndef __RCC_H__
#define __RCC_H__


#include <stm32h7xx_hal.h>

#define RCC_SECTION __attribute__((section(".rcc_init"), used))

#ifdef __cplusplus
extern "C" {
#endif

typedef struct rcc_init_s {
    RCC_OscInitTypeDef RCC_OscInitStruct;
    RCC_ClkInitTypeDef RCC_ClkInitStruct;
    RCC_PeriphCLKInitTypeDef PeriphClkInitStruct;
    uint32_t flashLatency;
    uint32_t voltageScale;
    uint32_t configSupply;
} rcc_init_t;

#ifdef __cplusplus
}
#endif

#endif // __RCC_H__
