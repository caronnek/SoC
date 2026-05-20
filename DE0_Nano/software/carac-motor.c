#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

#include "system.h"
#include "io.h"

#define PWM_MAX 0xFFF

// Construction commande moteur 14 bits
uint16_t motor_cmd(uint8_t go, uint8_t backward, uint16_t speed)
{
    speed &= PWM_MAX;

    return (go << 13) | (backward << 12) | speed;
}

int main()
{
    uint16_t vitesse;

    uint16_t motorR;
    uint16_t motorL;

    uint32_t data;

    printf("Caracterisation moteur PWM\n");

    while (1)
    {
        // Balayage PWM
        for (vitesse = 0; vitesse <= PWM_MAX; vitesse += 0x20)
        {
            // GO = 1
            // DIR = 0 -> forward
            motorR = motor_cmd(1, 0, vitesse);
            motorL = motor_cmd(1, 0, vitesse);

            // Packing registre 32 bits
            data = ((uint32_t)motorL << 14) | motorR;

            // Ecriture Avalon
            IOWR(PWM_AVALON_INTERFACE_1_BASE, 0, data);

            // Affichage
            printf("PWM = 0x%03X (%4d)   DATA = 0x%08X\n",
                   vitesse,
                   vitesse,
                   data);

            // Attente 200 ms
            usleep(200000);
        }

        // STOP moteurs
        IOWR(PWM_AVALON_INTERFACE_1_BASE, 0, 0);

        printf("Fin balayage\n");

        // Pause 2 secondes
        usleep(2);
    }

    return 0;
}