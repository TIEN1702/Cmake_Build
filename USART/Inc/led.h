#ifndef __LED_
#define __LED_

#include "stm32f411xe.h"
#define LED_ON    1U
#define LED_OFF   0U

extern void PortD_EnableBus(void);
extern void PortA_EnableBus(void);
extern void Led_Control( uint8_t status);

#endif
