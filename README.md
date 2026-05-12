# TP — Composant Spécialisé sur Qsys (Nios II / Avalon MM)

---

## Objectif

Concevoir et intégrer un **composant personnalisé** dans un système Nios II généré par Qsys (Quartus II 13.0), en utilisant l'interface bus **Avalon Memory-Mapped (Avalon MM)**. Le composant réalisé est un registre 16 bits dont la valeur est exportée vers des afficheurs 7 segments via un **Avalon Conduit Interface**.

---

## Architecture de l'implémentation

> `![Architecture du système](./architecture_component_tutorial.jpg)`

---

## Principe d'interfaçage avec le bus Avalon

Le bus **Avalon Memory-Mapped (Avalon MM)** est un protocole maître–esclave synchrone. Le processeur Nios II agit en **maître** ; notre composant custom agit en **esclave**.

### Signaux du slave Avalon MM

| Signal        | Direction (slave) | Rôle                                              |
|---------------|-------------------|---------------------------------------------------|
| `clk`         | entrée            | Horloge système                                   |
| `resetn`      | entrée            | Reset actif bas                                   |
| `address`     | entrée            | Adresse du registre sélectionné                   |
| `chipselect`  | entrée            | Active le composant pour la transaction           |
| `write`       | entrée            | Indique une écriture                              |
| `read`        | entrée            | Indique une lecture                               |
| `writedata`   | entrée (16 bits)  | Donnée à écrire dans le registre                  |
| `byteenable`  | entrée (2 bits)   | Sélection octet bas / haut                        |
| `readdata`    | sortie (16 bits)  | Donnée relue depuis le registre                   |
| `Q_export`    | sortie (16 bits)  | Conduit : valeur exportée vers les afficheurs     |



### Étapes de déclaration du composant dans Qsys

1. **Component Type** — nommer le composant (`reg16_avalon_interface`) et le groupe (`My Own IP Cores`).
2. **Files** — ajouter les fichiers HDL (`reg16_avalon_interface.vhd`, `reg16.vhd`) et lancer l'analyse.
3. **Signals** — associer chaque port à son interface et son type de signal :
   - `clock` → `clock_sink` / `clk`
   - `resetn` → `reset_sink` / `reset_n`
   - `writedata`, `readdata`, `write`, `read`, `chipselect`, `byteenable` → `avalon_slave_0`
   - `Q_export` → `conduit_end` / `export`
4. **Interfaces** — associer `avalon_slave_0` au clock (`clock_sink`) et au reset (`reset_sink`), mettre `Read wait = 0`.
5. **Finish** — sauvegarder le composant `.tcl` dans le dossier `ip_core/`.

---

## Arborescence du projet

```
DE1_Basic_Computer/
├── component_tutorial.vhd      # Top-level : instancie embedded_system + hex7seg
├── hex7seg.vhd                 # Décodeur BCD → 7 segments
│
├── ip_core/                    # Composants IP personnalisés
│   ├── reg16_avalon_interface.vhd
│   ├── reg16.vhd
│   └── reg16_avalon_interface_hw.tcl   # Descripteur Qsys du composant
│
├── /nios_system
│       └── /synthesis
│             └──  nios_system.vhd
├── nios_system.qsys            # Système Qsys (Nios II + mémoire + reg16)
│
└── app_software/
    └── component_tutorial.ncf    # Projet Altera Monitor Program
```

---

## Fichiers clés

| Fichier | Rôle |
|---|---|
| `nios_system.qsys` | Définition du système embarqué (Qsys) |
| `nios_system.vhd ` | Description hdl du nios  (Qsys) |
| `component_tutorial.vhd` | Module top-level FPGA |
| `hex7seg.vhd` | Conversion hexa → afficheur 7 segments |
| `ip_core/reg16_avalon_interface.vhd` | Wrapper Avalon MM du registre 16 bits |
| `ip_core/reg16.vhd` | Registre 16 bits |
| `ip_core/reg16_avalon_interface_hw.tcl` | Descripteur d'interface Qsys |
| `app_software/component_tutorial.ncf` | Test fonctionnel via Altera Monitor Program |

---

## Compilation et test

### 1. Générer le système Qsys

Ouvrir `nios_system.qsys` dans Qsys → onglet **Generation** → **Generate**.

### 2. Compiler avec Quartus II

```bash
quartus_sh --flow compile DE1_Basic_Computer
```

Ou via l'interface graphique : **Processing → Start Compilation**.

### 3. Programmer le FPGA

```bash
quartus_pgm -c USB-Blaster -m JTAG -o "p;output_files/component_tutorial.sof"
```

### 4. Test via Altera Monitor Program

- Ouvrir Monitor Program → nouveau projet → sélectionner `nios_system.qsys`
- Onglet **Memory** → **Query All Devices** → **Refresh Memory**
- Adresse `0x00800000` : valeur initiale `0000`
- Éditer la valeur → observer les changements sur `HEX0`…`HEX3`

---

## Résultats attendus

| Valeur écrite (hex) | Affichage HEX3..HEX0 |
|---|---|
| `0x0000` | `0 0 0 0` |
| `0x1234` | `1 2 3 4` |
| `0xABCD` | `A b C d` |

---

## Références

- Altera Corporation, *Making Qsys Components — For Quartus II 13.0*, University Program, May 2013
- Altera Corporation, *Avalon Interface Specifications*
