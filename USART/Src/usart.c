#include "usart.h"
 /*Enable the USART by writing the UE bit in USART_CR1 register to 1.
2. Program the M bit in USART_CR1 to define the word length.
3. Program the number of stop bits in USART_CR2.
4. Select DMA enable (DMAT) in USART_CR3 if Multi buffer Communication is to take
place. Configure the DMA register as explained in multibuffer communication.
5. Select the desired baud rate using the USART_BRR register.
6. Set the TE bit in USART_CR1 to send an idle frame as first transmission.
7. Write the data to send in the USART_DR register (this clears the TXE bit). Repeat this
for each data to be transmitted in case of single buffer.
8. After writing the last data into the USART_DR register, wait until TC=1. This indicates
that the transmission of the last frame is complete. This is required for instance when
the USART is disabled or enters the Halt mode to avoid corrupting the last
transmission.*/
void Usart2_Enable_Bus_Pin()
{
     /*Enable Bus Port D for 2 pin Tx (PA2) and Rx (PA3) */
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
    /* Config Alternate function mode for Tx and  Input floating Rx */
    GPIOA->MODER &=~GPIO_MODER_MODER2_0;
    GPIOA->MODER |= GPIO_MODER_MODER2_1;

    /* Set input RA3 */
    GPIOA->MODER &=~GPIO_MODER_MODER3_0;
    GPIOA->MODER &=~GPIO_MODER_MODER3_1;
    /*set input floating */
    GPIOA->PUPDR &=~GPIO_PUPDR_PUPD3_0;
    GPIOA->PUPDR &=~GPIO_PUPDR_PUPD3_1;

    /*Enable clock USART2*/
    RCC->APB1ENR |= RCC_APB1ENR_USART2EN;

}
void Usart2_Init(void)
{
    USART2->CR1 |= USART_CR1_UE;                    // Enable USART2

    /* Config word length */
    USART2->CR1 &= ~USART_CR1_M;                    // 8 bit data
    /* Config 1 stop bit*/
    USART2->CR2 &= ~USART_CR2_STOP_0;
    USART2->CR2 &= ~USART_CR2_STOP_0;
    /* Config baurate */
    USART2->CR1 |= USART_CR1_OVER8;                 // oversampling by 8 
    /* Config 9600 KBps - USARTDIV = 0x681 */
    USART2->BRR |= 0x03;                            // DIV_Fraction = 0x03
    USART2->BRR |= (0xD0 << 4U);                    // DIV_Mantissa = 0xD0

}
