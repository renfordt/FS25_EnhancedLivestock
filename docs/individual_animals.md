# Individual Animals

Enhanced Livestock completely replaces the vanilla cluster-based animal system with 100% individual animals. Each animal is a unique entity with its own properties, history, and genetics.

## Animal Identification

Every animal receives a unique identifier based on the UK cattle identification system:

```
[Country Code] [Farm ID] [Animal ID]
```

**Example:** `UK 123456 78901`

### Components

| Component | Description |
|-----------|-------------|
| Country Code | Two-letter code based on the map's location |
| Farm ID | Your farm's unique identifier |
| Animal ID | Unique number for the individual animal |

## Ear Tags

Animals display ear tags on both ears showing:

- **Left ear**: Country code, Farm ID
- **Right ear**: Animal ID, Name, Birthday

!!! tip "Ear Tag Visibility"
    You can toggle ear tag text visibility in the mod settings if you prefer a cleaner look or need better performance.

## Individual Properties

Each animal tracks the following properties:

### Basic Information
- **Name** - Customizable by the player
- **Birthday** - When the animal was born
- **Country of Origin** - Where the animal comes from
- **Age** - In months
- **Gender** - Male or female

### Physical Attributes
- **Weight** - Current weight in kg
- **Target Weight** - Ideal weight based on genetics
- **Health** - Current health percentage

### Genetics
Five inherited traits (see [Genetics](genetics.md) for details):

- Health
- Fertility
- Metabolism
- Productivity
- Quality

### Reproduction Status
- **Pregnancy status** - Pregnant or not
- **Expected offspring** - Number of babies expected
- **Due date** - When birth will occur

### Health Status
- **Diseases** - Current illnesses
- **Treatment status** - If receiving treatment

## Visual Markers

### Ear Tags
All animals display ear tags with identification information. The ear tag system shows:

- Country of origin
- Farm identification
- Individual animal number
- Name (if assigned)
- Birthday

### Nose Rings
Supported animals (primarily cattle) display nose rings when they reach maturity.

### Hindquarter Marking
Animals display partial identification marking on their hindquarters for easy identification from behind.

## Naming Animals

You can give custom names to your animals through:

1. The animal details screen
2. The AI Herdsman's auto-naming feature

Names appear on ear tags and in all animal lists.

## Visual Animal Limits

| Setting | Value |
|---------|-------|
| Vanilla limit | 25 animals per husbandry |
| Enhanced Livestock limit | Up to 200 animals per husbandry |

!!! warning "Performance"
    Higher visual animal counts may impact performance. Adjust the limit via the in-game slider based on your system's capabilities.
