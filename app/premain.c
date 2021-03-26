#include <stm32h7xx.h>

void _init(void)
{
    SCB_EnableICache();
    SCB_EnableDCache();
    HAL_Init();
    __enable_irq();
}

void HAL_MspInit(void)
{
    __HAL_RCC_SYSCFG_CLK_ENABLE();
}
