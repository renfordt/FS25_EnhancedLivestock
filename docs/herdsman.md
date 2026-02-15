# AI Herdsman

The AI Herdsman is an automated animal management system that handles routine tasks on your farm.

## Overview

The Herdsman can perform the following tasks automatically:

- **Buying** animals from the dealer
- **Selling** animals at market
- **Castrating** male animals
- **Naming** animals
- **Inseminating** females

## Wages

The Herdsman charges a monthly wage based on:

| Factor | Effect |
|--------|--------|
| Number of animals | More animals = higher wage |
| Services enabled | Each active service adds to cost |
| Animal types | Different rates per species |

### Wage Rates by Animal Type

| Animal Type | Base Wage per Animal |
|-------------|---------------------|
| Cattle | $20/month |
| Horses | $25/month |
| Sheep | $12.50/month |
| Pigs | $10/month |
| Chickens | $2/month |

## Configuring the Herdsman

Access Herdsman settings through the husbandry management screen.

### Buy Settings

| Setting | Description |
|---------|-------------|
| Enabled | Turn buying on/off |
| Budget Type | Fixed amount or percentage of farm funds |
| Budget Amount | Maximum spending limit |
| Max Animals | Maximum animals to buy per cycle |
| Breed | Specific breed or any |
| Diseases | Accept diseased animals? |
| Gender | Male, female, or any |
| Age Range | Minimum and maximum age |
| Quality Range | Minimum and maximum quality genetics |
| Health Range | Minimum and maximum health genetics |
| Fertility Range | Minimum and maximum fertility genetics |
| Productivity Range | Minimum and maximum productivity genetics |
| Metabolism Range | Minimum and maximum metabolism genetics |

### Sell Settings

| Setting | Description |
|---------|-------------|
| Enabled | Turn selling on/off |
| Max Animals | Maximum animals to sell per cycle |
| Mark Required | Only sell marked animals? |
| Diseases | Only sell diseased animals? |
| Gender | Male, female, or any |
| Age Range | Minimum and maximum age |
| Quality Range | Quality genetics filter |
| Health Range | Health genetics filter |
| Fertility Range | Fertility genetics filter |
| Productivity Range | Productivity genetics filter |
| Metabolism Range | Metabolism genetics filter |

### Castrate Settings

| Setting | Description |
|---------|-------------|
| Enabled | Turn castration on/off |
| Mark Required | Only castrate marked animals? |
| Diseases | Castrate diseased animals? |
| Age Range | Age window for castration |
| Quality Range | Quality genetics filter |
| Health Range | Health genetics filter |
| Fertility Range | Fertility genetics filter |
| Productivity Range | Productivity genetics filter |
| Metabolism Range | Metabolism genetics filter |

### Name Settings

| Setting | Description |
|---------|-------------|
| Enabled | Turn auto-naming on/off |

### Inseminate Settings

| Setting | Description |
|---------|-------------|
| Enabled | Turn auto-insemination on/off |
| Mark Required | Only inseminate marked animals? |

## Example Strategies

### Quality Breeding Program

**Buy Settings:**

- Quality: 125-175%
- Health: 100-175%
- Fertility: 100-175%

**Sell Settings:**

- Quality: 25-100%
- Age: 24+ months

This keeps high-quality animals for breeding while selling average performers.

### Meat Production Focus

**Buy Settings:**

- Gender: Any
- Quality: 125-175%
- Metabolism: 100-175%

**Castrate Settings:**

- Gender: Male (automatic)
- Age: 0-6 months
- Quality: 25-125%

**Sell Settings:**

- Age: 18-36 months (depending on species)

This maximizes meat quality while castrating males not needed for breeding.

### Disease Management

**Sell Settings:**

- Diseases: Yes
- Enabled: Yes

Automatically removes diseased animals from your herd to prevent spread.

## Tips

!!! tip "Effective Herdsman Use"
    - **Start conservative** - Begin with strict filters and loosen as needed
    - **Monitor finances** - Check that the Herdsman isn't overspending
    - **Review regularly** - Adjust settings as your herd develops
    - **Use marks** - Mark animals manually for special handling
    - **Balance automation** - Don't automate everything; some decisions need human judgment
