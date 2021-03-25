#include "rcc.h"

RCC_SECTION const rcc_init_t rcc = {
    .RCC_OscInitStruct = {
        .OscillatorType = RCC_OSCILLATORTYPE_HSE,
        .HSEState = RCC_HSE_ON,
        .PLL = {
            .PLLState = RCC_PLL_ON,
            .PLLSource = RCC_PLLSOURCE_HSE,
            .PLLM = 4,
            .PLLN = 480,
            .PLLP = 2,
            .PLLQ = 20,
            .PLLR = 2,
            .PLLRGE = RCC_PLL1VCIRANGE_1,
            .PLLVCOSEL = RCC_PLL1VCOWIDE,
            .PLLFRACN = 0,
        },
    },
    .RCC_ClkInitStruct = {
        .ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK |
                     RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2 |
                     RCC_CLOCKTYPE_D3PCLK1 | RCC_CLOCKTYPE_D1PCLK1,
        .SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK,
        .SYSCLKDivider = RCC_SYSCLK_DIV1,
        .AHBCLKDivider = RCC_HCLK_DIV2,
        .APB3CLKDivider = RCC_APB3_DIV2,
        .APB1CLKDivider = RCC_APB1_DIV2,
        .APB2CLKDivider = RCC_APB2_DIV2,
        .APB4CLKDivider = RCC_APB4_DIV2,
    },
    .PeriphClkInitStruct = {
        .PeriphClockSelection = RCC_PERIPHCLK_FDCAN | RCC_PERIPHCLK_USART1 | RCC_PERIPHCLK_UART8 |
                                RCC_PERIPHCLK_SDMMC | RCC_PERIPHCLK_USB | RCC_PERIPHCLK_QSPI,
        .PLL2 = {
            .PLL2M = 4,
            .PLL2N = 110,
            .PLL2P = 2,
            .PLL2Q = 2,
            .PLL2R = 2,
            .PLL2RGE = RCC_PLL2VCIRANGE_1,
            .PLL2VCOSEL = RCC_PLL2VCOWIDE,
            .PLL2FRACN = 0,
        },
        .QspiClockSelection = RCC_QSPICLKSOURCE_PLL2,
        .SdmmcClockSelection = RCC_SDMMCCLKSOURCE_PLL,
        .FdcanClockSelection = RCC_FDCANCLKSOURCE_PLL,
        .Usart234578ClockSelection = RCC_USART234578CLKSOURCE_D2PCLK1,
        .Usart16ClockSelection = RCC_USART16CLKSOURCE_D2PCLK2,
        .UsbClockSelection = RCC_USBCLKSOURCE_PLL,
    }
};
