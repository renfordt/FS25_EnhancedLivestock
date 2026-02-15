# Genetics System

Enhanced Livestock introduces a comprehensive genetics system where each animal has individual genetic traits that affect their performance, health, and value. Genetics are the foundation of breeding strategy and long-term herd improvement.

## Genetic Traits

Every animal has four core genetic traits. A fifth trait (**Productivity**) is present only on cows, sheep, and chickens.

All traits use a value range of **0.25 to 1.75**, where 1.0 represents average.

### Health

Affects disease resistance, health recovery rate, and lifespan.

- **Disease susceptibility:** The disease probability modifier is calculated as `2.0 - health`. An animal with health 1.75 has only 0.25x the base disease probability, while health 0.25 results in 1.75x.
- **Health recovery:** The hourly health recovery delta is multiplied by the health genetic value.
- **Death resistance:** Health genetics reduce the chance of death from both low health and old age. Death chance is multiplied by `2.0 - health`.

### Fertility

Determines reproductive success rate.

- Directly affects the chance of successful natural breeding.
- A fertility value of **0** means the animal is **infertile** and cannot reproduce. There is a 0.1% chance of an animal being born infertile.
- For AI bulls, fertility is mapped to insemination success rate: fertility 1.3 maps to ~65% success, fertility 1.75 maps to ~100% success.

**Freemartin effect:** In cattle, when a female calf is born as a twin alongside a male calf, the female has a 97% chance of becoming infertile (fertility set to 0).

### Metabolism

Controls food consumption, target weight, and weight gain/loss rates.

- **Food consumption:** Daily food intake is multiplied directly by the metabolism value. A metabolism of 1.5 means 50% more food consumed.
- **Target weight:** Adjusted by metabolism using the formula: `targetWeight + (((targetWeight * metabolism) - targetWeight) / 2.5)`. Higher metabolism results in a higher target weight.
- **Weight gain:** Growth rate is multiplied by metabolism. When an animal is losing weight, the metabolism modifier is inverted (`1 + (1 - metabolism)`), meaning high-metabolism animals also lose weight faster.
- **Weight loss when overweight:** The rate at which overweight animals return to target weight is influenced by metabolism.

### Quality

Determines meat quality and directly affects sale price.

- The quality value acts as a multiplier on the animal's sell price through two mechanisms:
    - A flat modifier: `sellPrice + (sellPrice * 0.25 * (quality - 1))`
    - A weight-proportional modifier: `sellPrice + (sellPrice * 0.6 / targetWeight) * weight * (quality - 1)`
- For horses, quality is used as a direct multiplier on the final sale price.
- With EPP Butcher integration, quality maps to a butcher yield modifier ranging from 0.7x (quality 0.25) to 1.3x (quality 1.75).
- Castrated animals receive an additional 15% sale price bonus.

### Productivity

**Only present on cows, sheep, and chickens.** Pigs and horses do not have this trait.

- Acts as a direct multiplier on production output:
    - **Cows:** Milk production (liters/day multiplied by productivity)
    - **Sheep:** Wool production
    - **Chickens:** Egg production
- An animal with productivity 1.5 produces 50% more than average; one with 0.5 produces 50% less.

## Trait Rating Display

The UI displays genetic values as text ratings with color coding:

| Value Range | Individual Trait Rating | Color |
|-------------|------------------------|-------|
| 0 (fertility only) | Infertile | Red |
| < 0.35 | Extremely Low | Red |
| 0.35 - 0.69 | Very Low | Orange-Red |
| 0.70 - 0.89 | Low | Orange |
| 0.90 - 1.09 | Average | Yellow |
| 1.10 - 1.39 | High | Light Green |
| 1.40 - 1.64 | Very High | Green |
| >= 1.65 | Extremely High | Bright Green |

### Overall Genetics Rating

The overall rating is calculated by summing all trait values and dividing by the maximum possible sum (1.75 per trait). For animals with productivity, the sum uses 5 traits; for others, 4 traits.

| Factor (sum / max) | Overall Rating |
|---------------------|----------------|
| < 0.05 | Extremely Bad |
| 0.05 - 0.19 | Very Bad |
| 0.20 - 0.34 | Bad |
| 0.35 - 0.64 | Average |
| 0.65 - 0.79 | Good |
| 0.80 - 0.94 | Very Good |
| >= 0.95 | Extremely Good |

## Initial Genetics Generation

When a new animal is generated (not bred), each trait is assigned using a weighted probability distribution:

| Probability | Value Range | Category |
|-------------|-------------|----------|
| 5% | 0.25 - 0.35 | Extremely Low |
| 20% | 0.35 - 0.90 | Low |
| 50% | 0.90 - 1.10 | Average |
| 20% | 1.10 - 1.65 | High |
| 5% | 1.65 - 1.75 | Extremely High |

**Special case for fertility:** There is an additional 0.1% chance the animal is born infertile (fertility = 0), checked before the normal distribution.

## Inheritance

When animals breed, offspring genetics are calculated using **Gaussian (normal) distribution inheritance** via the `BreedingMath` module.

### How It Works

1. **Mid-parent value:** The average of both parents' trait values is calculated: `(parent1 + parent2) / 2`
2. **Gaussian sampling:** The offspring value is drawn from a normal distribution centered on the mid-parent value with a standard deviation of **0.15** (10% of the full 0.25-1.75 range).
3. **Clamping:** The result is clamped to [0.25, 1.75].

This means offspring genetics **can exceed or fall below both parents' values** probabilistically. Two average parents can occasionally produce exceptional offspring, and two excellent parents can occasionally produce average offspring.

### Special Inheritance Rules

- **Fertility:** Each offspring has a 0.1% chance of being infertile regardless of parent genetics.
- **Productivity:** Only inherited if the mother has the productivity trait. If the father lacks it, a default value of 1.0 is used for his contribution.
- **Freemartin cattle:** When cattle twins include both male and female calves, the female has a 97% chance of infertility.

### Breeding Strategy

To improve your herd's genetics over generations:

- **Select high-quality breeding stock** - Choose animals with the traits you want to improve
- **Cull low performers** - Remove animals with poor genetics from your breeding program
- **Use AI bulls strategically** - Higher-tier bulls have guaranteed high genetics
- **Be patient** - Gaussian inheritance means improvement is probabilistic, not guaranteed each generation
- **Balance traits** - Don't focus on just one trait; the overall rating considers all traits together

## Animal Dealer & Farm Quality

### Farm Quality

Each farm in the dealer network has a randomly generated quality value (0.25 to 1.75). This quality determines the genetics of animals available for purchase from that farm.

**How genetics are generated from farm quality:**

Each trait is randomly generated within a range of **farm quality ± 0.30**, clamped to [0.25, 1.75].

For example:
- Farm quality **1.50** → each trait ranges from 1.20 to 1.75 (clamped)
- Farm quality **0.50** → each trait ranges from 0.25 to 0.80 (clamped)
- Farm quality **1.00** → each trait ranges from 0.70 to 1.30

**Farm quality display in the dealer:**

| Quality Value | Rating |
|--------------|--------|
| >= 1.65 | Extremely Good |
| 1.40 - 1.64 | Very Good |
| 1.10 - 1.39 | Good |
| 0.90 - 1.09 | Average |
| 0.70 - 0.89 | Bad |
| 0.35 - 0.69 | Very Bad |
| < 0.35 | Extremely Bad |

### Purchase Price

The purchase price is the animal's calculated sale price multiplied by **1.075** (a 7.5% markup over sale value).

## Artificial Insemination Bull Tiers

AI bulls in the semen catalog are assigned tiers based on the supplying farm's quality. Each tier has distinct genetics ranges and probabilities.

### Tier Genetics Ranges

| Tier | Genetics Range | Description |
|------|---------------|-------------|
| Young Genomic | 1.00 - 1.75 | Wide range, unproven but potentially excellent |
| Proven | 1.00 - 1.50 | Narrower range, consistent but moderate |
| Elite | 1.30 - 1.60 | High floor, reliably good |
| Legend | 1.60 - 1.75 | Top-tier genetics guaranteed |

### Tier Probabilities

Base probabilities for tier assignment:

| Tier | Base Probability |
|------|-----------------|
| Young Genomic | 50% |
| Proven | 35% |
| Elite | 13% |
| Legend | 2% |

Higher farm quality shifts probabilities toward better tiers. The quality factor scales from 0 (farm quality 1.35) to 1 (farm quality 1.75), reducing Young Genomic probability by up to 40% and increasing Elite probability by up to 150% and Legend probability by up to 300%.

### AI Bull Success Rate

The insemination success rate is derived from the bull's fertility genetics:

- Fertility 1.30 → ~65% base success rate
- Fertility 1.75 → ~100% base success rate
- A ±2.5% random variation is applied

## Viewing Genetics

You can view an animal's genetics through:

- **Animal details screen** - Shows all individual trait ratings with color coding
- **Animal dealer** - Displays genetics of animals for sale, with breeder quality rating
- **AI Herdsman interface** - Allows filtering animals by genetic trait ranges (min/max for each trait)
- **Animal filter dialog** - Filter animal lists by all 5 genetic traits

## Console Commands

Use `elSetAnimalGenetics` to modify genetics in singleplayer:

```
elSetTargetAnimal COW 1 10001
elSetAnimalGenetics health 1.75
elSetAnimalGenetics fertility 0.25
```

Valid trait names: `health`, `fertility`, `metabolism`, `productivity`, `quality`
Valid value range: 0.25 to 1.75
