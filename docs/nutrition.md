# Nutrition System

Enhanced Livestock features a realistic nutrition system that replaces the vanilla flat food consumption with weight-based intake, feed nutrient tracking, and life stage requirements. What you feed your animals matters -- a trough full of straw won't sustain a lactating cow the same way TMR will.

## How It Works

The nutrition system calculates three things every in-game hour for each animal:

1. **How much** the animal needs to eat (based on body weight and life stage)
2. **What nutrients** the trough provides (energy, protein, dry matter)
3. **How well** the available feed meets the animal's requirements (nutrition score)

The resulting **nutrition score** (0 to 1) drives health changes, weight gain, and production output.

## Feed Quality

Not all feeds are created equal. Each feed type has a nutrient profile that determines how much energy and protein it provides per kilogram of dry matter.

### Feed Profiles

| Feed | Category | Energy (MJ/kg DM) | Protein (g/kg DM) | Dry Matter % |
|------|----------|-------------------:|-------------------:|-------------:|
| Straw | Roughage | 5.5 | 35 | 88% |
| Dry Grass | Roughage | 8.5 | 95 | 85% |
| Grass | Roughage | 10.5 | 160 | 20% |
| Silage | Roughage | 10.8 | 140 | 35% |
| Oat | Concentrate | 12.0 | 110 | 87% |
| Barley | Concentrate | 13.0 | 115 | 87% |
| Wheat | Concentrate | 13.5 | 120 | 87% |
| Corn | Concentrate | 14.2 | 90 | 87% |
| Sunflower | Protein | 11.0 | 280 | 90% |
| Canola | Protein | 12.5 | 350 | 90% |
| Soybean | Protein | 15.0 | 380 | 90% |
| TMR | Mixed | 11.5 | 165 | 45% |
| Forage | Mixed | 10.0 | 130 | 40% |
| Pig Food | Mixed | 13.0 | 170 | 88% |
| Chicken Food | Mixed | 12.5 | 180 | 88% |
| Horse Food | Mixed | 10.0 | 120 | 88% |
| Potato | Concentrate | 13.0 | 95 | 22% |
| Sugar Beet | Concentrate | 12.8 | 65 | 23% |

!!! tip "Best Feeds"
    **TMR** provides the best balance of energy and protein for cattle. For maximum milk production, aim for high-energy, high-protein feeds. Straw alone is nutritionally poor and will result in slow growth and declining health.

!!! info "Unknown Fill Types"
    Any feed type not listed above (e.g., from other mods) receives a default profile of 9.0 MJ energy, 100 g protein, and 50% dry matter. This ensures the system never breaks with modded feed types.

### Dry Matter

Dry matter percentage is important because it determines how much actual nutrition is in each liter of feed. Fresh grass is 80% water (20% DM), so animals need to eat much more of it by volume compared to dry grain (87% DM).

## Life Stages

Each animal is classified into a life stage based on its age, gender, and current condition (lactating, pregnant, castrated). The life stage determines how much the animal needs to eat relative to its body weight.

### Cattle

| Stage | Age | Gender | Condition | DMI (% Body Weight) |
|-------|-----|--------|-----------|--------------------:|
| Calf | 0-5 months | Any | -- | 2.5% |
| Yearling | 6-11 months | Any | -- | 2.8% |
| Lactating Cow | 12+ months | Female | Lactating | 3.5% |
| Dry Pregnant | 12+ months | Female | Pregnant | 2.2% |
| Heifer | 12+ months | Female | -- | 2.5% |
| Dry Cow | 12+ months | Female | -- | 2.0% |
| Steer | 6+ months | Male | Castrated | 2.8% |
| Bull | 12+ months | Male | -- | 2.2% |

!!! note "Lactating Cows"
    Lactating cows eat the most relative to their body weight (3.5%). A 600 kg lactating cow consumes about 21 kg of dry matter per day. Make sure your troughs are well-stocked.

### Pigs

| Stage | Age | Gender | Condition | DMI (% Body Weight) |
|-------|-----|--------|-----------|--------------------:|
| Piglet | 0-2 months | Any | -- | 5.0% |
| Grower | 3-5 months | Any | -- | 4.0% |
| Lactating Sow | 6+ months | Female | Lactating | 5.0% |
| Gestating Sow | 6+ months | Female | Pregnant | 2.5% |
| Boar | 6+ months | Male | -- | 2.5% |
| Finisher | 6+ months | Any | -- | 3.0% |

### Sheep

| Stage | Age | Gender | Condition | DMI (% Body Weight) |
|-------|-----|--------|-----------|--------------------:|
| Lamb | 0-5 months | Any | -- | 4.0% |
| Hogget | 6-11 months | Any | -- | 3.5% |
| Lactating Ewe | 12+ months | Female | Lactating | 4.5% |
| Pregnant Ewe | 12+ months | Female | Pregnant | 2.5% |
| Ewe | 12+ months | Female | -- | 2.8% |
| Ram | 12+ months | Male | -- | 2.5% |

### Horses

| Stage | Age | Gender | Condition | DMI (% Body Weight) |
|-------|-----|--------|-----------|--------------------:|
| Foal | 0-5 months | Any | -- | 3.0% |
| Yearling | 6-11 months | Any | -- | 2.5% |
| Lactating Mare | 12+ months | Female | Lactating | 3.0% |
| Pregnant Mare | 12+ months | Female | Pregnant | 2.2% |
| Mare | 12+ months | Female | -- | 2.0% |
| Stallion | 12+ months | Male | -- | 2.0% |

### Chickens

| Stage | Age | Gender | Condition | DMI (% Body Weight) |
|-------|-----|--------|-----------|--------------------:|
| Chick | 0-2 months | Any | -- | 6.0% |
| Pullet | 3-5 months | Any | -- | 5.0% |
| Laying Hen | 6+ months | Female | -- | 4.0% |
| Rooster | 6+ months | Male | -- | 3.5% |

## Nutrition Score

The nutrition score (0 to 1) measures how well the available feed meets an animal's requirements. It is recalculated every in-game hour.

### Calculation

The score is the product of two factors:

1. **Availability** -- Is there enough food in the trough for all animals?
2. **Quality** -- Does the feed provide sufficient energy and protein?

```
Nutrition Score = Availability x min(Energy Ratio, Protein Ratio)
```

- **Availability ratio** = Total dry matter in trough / (number of animals x daily DM need per animal), capped at 1.0
- **Energy ratio** = Trough average energy / animal's required energy per kg DM, capped at 1.2
- **Protein ratio** = Trough average protein / animal's required protein per kg DM, capped at 1.2

!!! warning "Empty Troughs"
    An empty trough gives a nutrition score of 0. This causes health decline, weight loss, and zero production output.

### What the Score Means

| Score Range | Interpretation |
|-------------|---------------|
| 0.0 | Starving -- no food available |
| 0.1 - 0.3 | Poor nutrition -- wrong feed type or severe shortage |
| 0.4 - 0.6 | Moderate -- feed is available but nutritionally lacking |
| 0.7 - 0.8 | Good -- adequate nutrition for maintenance and growth |
| 0.9 - 1.0 | Excellent -- optimal nutrition, maximum growth and production |

### Effects on Animals

| System | Effect |
|--------|--------|
| **Health** | Blends body condition (60%) and current score (40%) to determine health changes |
| **Weight gain** | Growth rate scales with nutrition score; poor nutrition = slow or no growth |
| **Milk/Eggs/Wool** | Production output multiplied by `score x 1.25` (capped at 1.0) |
| **Manure** | Not affected -- waste output is constant regardless of nutrition |

## Body Condition

Body condition is a rolling average of the nutrition score over approximately 7 in-game days (168 hours). It represents the animal's long-term nutritional state rather than moment-to-moment feeding.

- **New animals** start with a body condition of 0.5 (average)
- Body condition moves slowly -- a single missed meal won't crash it
- A consistently well-fed animal gradually builds up body condition toward 1.0
- A consistently underfed animal's body condition declines toward 0

!!! info "Body Condition vs Nutrition Score"
    The **nutrition score** changes every hour based on trough contents. **Body condition** is a smoothed average that reflects long-term feeding quality. Health calculations use both: 60% body condition + 40% current nutrition score. This means a well-conditioned animal can tolerate a brief food shortage better than a poorly-conditioned one.

Body condition is saved with each animal and synced in multiplayer.

## Pregnancy and Nutrition

Pregnant animals have increased nutritional requirements, especially in the final trimester. The system applies trimester multipliers to energy requirements:

### Pregnancy Trimester Multipliers

| Species | Trimester 1 | Trimester 2 | Trimester 3 |
|---------|:-----------:|:-----------:|:-----------:|
| Cattle | 1.0x energy | 1.1x energy | 1.3x energy, 0.95x DMI |
| Pigs | 1.0x energy | 1.1x energy | 1.25x energy, 1.1x DMI |
| Sheep | 1.0x energy | 1.15x energy | 1.4x energy, 0.92x DMI |
| Horses | 1.0x energy | 1.05x energy | 1.2x energy, 0.98x DMI |

!!! note "Late Pregnancy DMI Reduction"
    In cattle and sheep, the DMI (dry matter intake) actually *decreases* in late pregnancy because the growing fetus compresses the rumen, reducing the animal's physical capacity to eat. This is realistic -- you need to provide higher-quality feed (more energy-dense) in the last trimester to compensate.

## Weight Gain

The nutrition system uses **Average Daily Gain (ADG)** with a maturity taper instead of the vanilla linear growth model. Young animals grow fastest, and growth naturally slows as they approach their target weight.

### Maximum ADG by Species

| Species | Male | Female |
|---------|-----:|-------:|
| Cattle | 1.40 kg/day | 1.00 kg/day |
| Pigs | 0.95 kg/day | 0.85 kg/day |
| Sheep | 0.30 kg/day | 0.25 kg/day |
| Horses | 0.80 kg/day | 0.70 kg/day |
| Chickens | 0.015 kg/day | 0.012 kg/day |

Growth rate is modified by:

- **Maturity** -- Growth slows as the animal approaches target weight
- **Nutrition score** -- Poor nutrition reduces growth proportionally
- **Metabolism genetics** -- Higher metabolism = faster growth
- **Castration** -- Castrated males grow 15% faster
- **Lactation** -- Lactating animals grow 25% slower (energy diverted to milk)
- **Disease** -- Some diseases reduce weight gain

## Water Consumption

Water intake is calculated based on dry matter consumption:

```
Daily Water = Daily DMI (kg) x 4.5 liters
```

Lactating animals drink 50% more water. This replaces the vanilla age-curve water calculation.

## Food Scale Setting

The in-game **Food Scale** setting still works with the nutrition system. It acts as a multiplier on the dry matter intake calculation, allowing players to adjust overall consumption rates up or down.

## Console Commands

Two debug commands are available in singleplayer for inspecting the nutrition system:

### elGetNutritionScore

Displays the targeted animal's nutrition information:

```
elSetTargetAnimal COW 1 10001
elGetNutritionScore
```

Output includes: life stage, weight, body condition, nutrition score, daily requirements (DMI, energy, protein), and trough composition.

### elGetLifeStage

Displays the targeted animal's life stage classification and detailed requirements:

```
elSetTargetAnimal COW 1 10001
elGetLifeStage
```

Output includes: stage name, DMI percentage, energy/protein requirements, hourly consumption rates, and maximum ADG.

## Compatibility

### Savegame Compatibility

- **Existing saves** work without issues. Animals without a saved body condition default to 0.5.
- If the nutrition system fails to load for any reason, all calculations fall back to the vanilla age-based system automatically.

### Mod Compatibility

- **Custom feed types** from other mods receive a default nutrient profile (9.0 MJ, 100g protein, 50% DM). They will work but may not be nutritionally optimal.
- The system reads trough contents from the vanilla `spec_husbandryFood` API, so it is compatible with any mod that uses the standard husbandry food system.
