# Enhanced Livestock

A comprehensive livestock overhaul for Farming Simulator 25.

Enhanced Livestock transforms the vanilla animal system by replacing the cluster-based approach with fully individual animals. Each animal has unique genetics, weight tracking, health management, and realistic reproduction mechanics.

## Key Features

### Individual Animals
Every animal is unique with its own:

- **Unique identifier** based on the UK cattle identification system
- **Birthday and country of origin**
- **Customizable name**
- **Visual ear tags** displaying country, farm ID, animal ID, name, and birthday
- **Nose rings** on supported animals

### Genetics System
Five genetic traits affect animal performance:

| Trait | Effect |
|-------|--------|
| Health | Disease resistance |
| Fertility | Reproduction success rate |
| Metabolism | Food consumption, weight targets |
| Productivity | Milk, wool, egg production |
| Quality | Meat quality, affects sale value |

Offspring inherit genetics from both parents through a weighted probability distribution.

### Realistic Breeding
- **Male animals required** for reproduction
- **Species-specific litter sizes** (e.g., cows: 0-3 calves)
- **Pregnancy tracking** with expected offspring count and due dates
- **Individual gestation periods** varying by animal

### Weight System
- Individual weight tracking for every animal
- Daily weight fluctuations based on food and water consumption
- Health consequences for unhealthy weight
- Weight directly affects market price

### Disease System
Realistic diseases with:

- Transmission between animals
- Age-based probability curves
- Time-based fatality rates
- Production modifiers
- Treatment options

### AI Herdsman
Automated animal management with configurable filters for:

- Buying and selling
- Castration
- Naming
- Insemination

## Visual Improvements

- **Increased visual animal capacity**: Up to 200 animals per husbandry (vanilla: 25)
- **Ear tag text**: Displays identification information
- **Nose rings**: On supported adult animals

## Getting Started

1. Install the mod in your FS25 mods folder
2. Enable the mod in-game
3. Load or start a save with animal husbandries
4. Access mod settings through the in-game menu

## Optional Dependencies

| Mod | Purpose |
|-----|---------|
| FS25_FontLibrary | Enhanced font rendering for ear tags |
| FS25_AnimalPackage_vanillaEdition | Additional animal models and variants |

## Credits

Based on [FS25 Realistic Livestock](https://github.com/Arrow-kb/FS25_RealisticLivestock) by Arrow-kb.
