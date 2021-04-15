#include <stm32h7xx.h>

void SysTick_Handler(void)
{
    HAL_IncTick();
}
