#ifndef __USART_H
#define __USART_H

#include "stm32f411xe.h"

extern void Usart2_Enable_Bus(void);
extern void Usart2_Init(void);
extern uint8_t Usart_Transmittion(uint8_t *Data);
extern void Usart2_Enable_Bus_Pin();

#endif /* __USART_H */
