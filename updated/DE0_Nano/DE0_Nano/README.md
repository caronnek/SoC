# Line Follower Robot – FPGA Co-Design

## Description

Ce projet porte sur la conception d’un **robot suiveur de ligne** basé sur une architecture de **co-design matériel/logiciel sur FPGA**.  
Le système a été développé de manière progressive, en plusieurs versions, chaque étape apportant des améliorations fonctionnelles et architecturales.

La plateforme utilisée est la **DE0-Nano (FPGA Cyclone IV)** avec une **SDRAM de 32 Mo**, en utilisant :
- **VHDL** pour les blocs matériels temps réel  
- **C** pour le logiciel embarqué (processeur NIOS II)  
- **Quartus & Qsys** pour la conception et l’intégration du système  

Le robot est équipé de **7 capteurs infrarouges**, d’un **ADC LTC2308** et de deux moteurs commandés par **PWM**.

---

## Objectif

Concevoir un système autonome capable de :
- détecter une ligne noire,
- calculer sa position,
- ajuster la vitesse des moteurs,
- suivre la ligne en temps réel,
- gérer la perte de ligne (rotation),
- réaliser des **aller-retours automatiques**.

---

## Architecture du système

### Partie matérielle (FPGA – VHDL)
- Lecture des capteurs via ADC (SPI)  
- Seuillage des signaux  
- Calcul de la position de la ligne  
- Automates :
  - suivi de ligne  
  - rotation  
- Génération PWM pour les moteurs  

### Partie logicielle (NIOS II – C)
- Supervision du système  
- Gestion des états (suivi, rotation, arrêt)  

### Intégration (Qsys / Avalon)
- Interconnexion des blocs  
- Accès à la SDRAM (programme + données)  
- Communication processeur / périphériques  

---

## Évolution du projet

- **V2_SDRAM** : architecture de base (NIOS II + SDRAM + PIO)  
- **V3_caract** : caractérisation des moteurs  
- **V4_capt_sol_seuil** : acquisition et seuillage des capteurs  
- **V4_cpteur_sol** : calcul de la position de la ligne  
- **V5_suivi_ligne** : implémentation du suivi de ligne  
- **V6_rotation_ligne** : gestion de la rotation  
- **V7_aller_retour** : comportement complet avec supervision  

---

## Principe de fonctionnement

1. Les capteurs IR détectent la ligne  
2. L’ADC envoie les données au FPGA  
3. La position de la ligne est calculée  
4. Les moteurs sont commandés par PWM :
   - vitesses égales → ligne droite  
   - vitesses différentes → correction  
5. Si la ligne est perdue :
   - rotation → recentrage → reprise  

---

## Technologies utilisées

- FPGA **DE0-Nano (Cyclone IV)**
- **Quartus / Qsys**
- **VHDL**
- **C (NIOS II)**
- ADC **LTC2308**
- PWM & moteurs DC  

---


