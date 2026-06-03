
#include"led.h"

void PortD_EnableBus(void)
{
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;  // Enable clock Port D for LED Blue
  GPIOD->MODER |= GPIO_MODER_MODER15_0;
}
void PortA_EnableBus(void)
{
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;  // Enable clock Port A for LED Blue
  GPIOA->MODER &= ~GPIO_MODER_MODER0;
  // config pull down for button
  GPIOA->PUPDR &= ~GPIO_PUPDR_PUPD0_0;
  GPIOA->PUPDR |= GPIO_PUPDR_PUPD0_1;
}
void Led_Control( uint8_t status)
{
  if(status != LED_ON)
  {
    GPIOD->ODR &= ~GPIO_ODR_OD15;
  }
  else
  {
    GPIOD->ODR |= GPIO_ODR_OD15;
  }
}