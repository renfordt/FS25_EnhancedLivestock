# Individual Animals

Enhanced Livestock completely replaces the vanilla cluster-based animal system with 100% individual animals. Each animal is a unique entity with its own properties, history, and genetics.

## Animal Identification

Every animal receives a unique identifier inspired by real-world cattle identification systems:

```
[Country Code] [Farm ID] [Animal ID]
```

**Example:** `UK 123456 789012`

### Components

| Component | Description |
|-----------|-------------|
| Country Code | Two-letter code based on the map's geographic location |
| Farm ID | Six-digit herd number for your farm |
| Animal ID | Six-digit unique number for the individual animal |

A check digit is calculated from the combined Farm ID and Animal ID to validate the identifier.

### Country Codes

The country code is determined automatically based on the map being played. Supported maps are assigned to the following countries:

| Code | Country | Example Maps |
|------|---------|-------------|
| UK | United Kingdom | Riverview, Oak Bridge Farm, Calmsden Farm |
| US | United States | Riverbend Springs, Frankenmuth, Alma Missouri |
| CH | China | Hutan Pantai |
| FR | France | Pallegney |
| PL | Poland | Zielonka, Zacieczki, Szpakowo, Starowies, Lipinki, Sobolewo |
| DE | Germany | Oberschwaben, Schwesing Bahnhof, New Bartelshagen, North Frisian 25 |
| EE | Estonia | Tassi Farm |
| CZ | Czech Republic | HORSCH AgroVation |

Unrecognized maps default to the UK country code. Animals born on different maps retain their original country of origin.

## Individual Properties

Each animal tracks the following properties:

### Basic Information
- **Name** - Customizable by the player; auto-generated for horses
- **Birthday** - Day, month, and year the animal was born
- **Country of Origin** - Where the animal was born (stored as area code index)
- **Age** - In months, incremented on their birthday each month
- **Gender** - Male or female
- **Breed** - Specific subtype (e.g., Holstein, Angus, Landrace)

### Physical Attributes
- **Weight** - Current weight in kg
- **Target Weight** - Ideal weight adjusted by metabolism genetics
- **Health** - Current health percentage (0-100%)

### Genetics
Five inherited traits (see [Genetics](genetics.md) for details):

- Health (disease resistance)
- Fertility (reproduction success)
- Metabolism (food consumption, weight targets)
- Productivity (milk, wool, egg output — cows, sheep, and chickens only)
- Quality (meat quality, sale value)

All traits range from 0.25 to 1.75, where 1.0 is average.

### Reproduction Status
- **Pregnancy status** - Whether the animal is pregnant and current progress (0-100%)
- **Expected offspring** - Number and genetics of unborn calves/lambs/etc.
- **Due date** - Calculated expected birth date
- **Months since last birth** - Recovery tracking (minimum 3 months before next breeding)
- **Lactation** - Whether the animal is currently producing milk (cows/goats, up to 10 months post-birth)
- **Insemination data** - Stored semen information if artificially inseminated

### Health Status
- **Diseases** - Current active illnesses with treatment status, immunity, and carrier state
- **Health monitor** - Optional subscription-based monitoring (monthly fee based on animal size)

### Lineage
- **Mother ID** - Identifier of the mother
- **Father ID** - Identifier of the father
- **Children** - List of offspring identifiers

### Horse-Specific Properties
- **Dirt** - Cleanliness level (0-100%)
- **Fitness** - Physical fitness (0-100%)
- **Riding** - Daily riding time tracking

### Castration
- Males can be castrated, which permanently prevents reproduction
- Castrated animals gain weight 15% faster and sell for 15% more

## Ear Tags

Animals display ear tags on both ears showing identification information. The ear tag system supports two rendering methods:

- **FontLibrary** - High-quality text rendering when the optional `FS25_FontLibrary` mod is installed
- **Shader-based fallback** - Built-in character display using shader parameters

### Left Ear Tag
Displays the official identification:

- **Country code** (top) - Two-letter country of origin
- **Farm ID** (middle) - Six-digit farm/herd number
- **Animal ID** (bottom) - Six-digit unique animal number

### Right Ear Tag
Displays personal information:

- **Name** - The animal's name (auto-scaled to fit)
- **Birthday** - Date of birth in DD/MM/YY format

### Ear Tag Colours
Ear tag colours (both tag background and text) are customizable through the in-game colour picker. Default colours are yellow tags with black text.

!!! tip "Ear Tag Text Visibility"
    You can toggle ear tag text on or off in the mod settings. Disabling ear tag text hides all text elements and can improve performance with large herds.

## Other Visual Markers

### Nose Rings
Male animals display nose rings on supported models (primarily cattle). The nose ring is visible whenever the animal model includes the nose ring attachment point.

### Hindquarter ID
Animals display a partial identification number on their hindquarters for easy identification from behind. This shows the last four digits of the animal's unique ID, split across two lines.

### Mark Indicator
When an animal has an active mark, a coloured indicator is displayed on the animal. The indicator colour is determined by the animal's breed.

### Health Monitor
Animals with an active health monitor display a visual indicator on their model. The monitor remains visible even after the subscription is cancelled (shown in a "removed" state).

## Marks

Animals can be flagged with marks for organizational purposes. Each mark has a priority level that determines which mark is displayed when multiple are active.

| Mark | Priority | Description |
|------|----------|-------------|
| PLAYER | 1 (highest) | Manually set by the player |
| AI_MANAGER_DISEASE | 2 | Flagged by herdsman for disease treatment |
| AI_MANAGER_SELL | 3 | Flagged by herdsman for sale |
| AI_MANAGER_INSEMINATE | 4 | Flagged by herdsman for insemination |
| AI_MANAGER_CASTRATE | 5 (lowest) | Flagged by herdsman for castration |

Marks are displayed in animal lists and as visual indicators on the animal model. The highest-priority active mark determines what is shown.

## Naming Animals

You can give custom names to your animals through:

1. The animal details screen
2. The AI Herdsman's auto-naming feature

Names appear on the right ear tag and in all animal lists. Horses always have a name assigned.

## Visual Animal Limits

| Setting | Value |
|---------|-------|
| Vanilla limit | 25 animals per husbandry |
| Enhanced Livestock limit | Up to 200 animals per husbandry |

The visual animal limit controls how many individual 3D animal models are rendered in each husbandry. All animals exist in the simulation regardless of this limit — it only affects visual rendering.

!!! warning "Performance"
    Higher visual animal counts may impact performance. Adjust the limit via the in-game slider based on your system's capabilities.
