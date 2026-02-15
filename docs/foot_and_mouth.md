# Foot and Mouth Disease (FMD)

Foot and Mouth Disease is a highly contagious viral disease affecting cloven-hoofed animals. It causes painful lesions on feet and in the mouth, leading to severe production losses and significant economic impact across multiple species.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle, Sheep, Pigs |
| Transmission Rate | 10% per month |
| Immunity Period | 24 months |
| Recovery Time | None (no natural recovery) |
| Sale Value Impact | 50% reduction (0.5 multiplier) |
| Weight Gain Impact | 30% reduction (0.7 multiplier) |
| Fertility Impact | 50% reduction (0.5 multiplier) |

## Infection Risk

### Base Probability

FMD probability increases with age:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-5 | 0% |
| 6+ | 0.075% per month |

### Modifying Factors

The actual infection chance is modified by:

**Health Genetics Modifier**
- Health 1.75 (best): 0.01875% actual chance (75% reduction)
- Health 1.0 (average): 0.075% actual chance
- Health 0.25 (worst): 0.13125% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

### Transmission

FMD spreads rapidly between susceptible animals:

- **Base transmission rate**: 10% per month (very high)
- **Transmission chance**: `0.10 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of animals are immune, transmission is reduced by 90%

!!! warning "Rapid Spread"
    FMD has one of the highest transmission rates in the game. It can quickly spread through entire herds of cattle, sheep, or pigs, and even between different species sharing the same facility.

### Cross-Species Transmission

FMD can spread between cattle, sheep, and pigs in the same husbandry. All three species contribute to the infected animal count when calculating transmission probability.

## Symptoms and Effects

### Production Impact

FMD severely impacts production across affected species:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Milk (cattle) | 35% | 65% reduction |
| Pallet production | 90% | 10% reduction (wool/eggs) |

### Weight and Fertility

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 70% | 30% reduction |
| Fertility | 50% | Severely impaired breeding |

!!! warning "Severe Fertility Impact"
    FMD causes a 50% reduction in fertility, making it very difficult for affected animals to successfully breed.

### Fatality

FMD has significant mortality that decreases over time:

| Time | Fatality Rate | Cumulative Deaths |
|------|---------------|-------------------|
| 0 months (initial) | 20% | 20% dead |
| 6 months | 12% | ~30% dead total |
| 18 months | 3.5% | ~32% dead total |

!!! danger "High Initial Mortality"
    FMD has a 20% immediate fatality rate, with additional deaths occurring over the following months if untreated.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - 20% initial death risk
   - Severe milk production loss (65% reduction)
   - Severely reduced weight gain (30% penalty)
   - Severely impaired fertility (50% penalty)
   - 50% reduction in sale value
   - Highly contagious to other susceptible animals
   - Ongoing mortality risk over 18+ months

2. **Being Treated**
   - $250 cost per month
   - Production losses continue during treatment
   - After 3 months, becomes immune
   - No further mortality risk during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 24 months
   - No production penalties
   - No sale value penalty

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $250 |
| Duration | 3 months |
| Immunity Granted | 24 months |

### Treatment Process

1. Select the infected animal in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $250 treatment cost (charged to MEDICINE finance category)
4. Wait 3 months for treatment to complete
5. Animal recovers and gains 24 months of immunity
6. Production resumes normally

!!! warning "No Natural Recovery"
    FMD does not recover naturally. Affected animals must be treated or they will remain infected indefinitely with ongoing mortality risk.

### Cost-Benefit Analysis

| Approach | Cost | Risk | Outcome |
|----------|------|------|---------|
| Immediate treatment | $250 + 3 months lost production | Low mortality | Recovery in 3 months |
| No treatment | 50% value loss if sold | Ongoing 20%+ mortality | Animal remains sick indefinitely |

!!! tip "Treatment Recommendation"
    Always treat FMD immediately. The disease is devastating without treatment, and the 24-month immunity helps protect your herd long-term.

## Prevention

### Best Practices

**Biosecurity for Multi-Species Operations**
- **Quarantine new animals** - Isolate for observation period
- **Separate species housing** - Prevents cross-species transmission
- **Control farm access** - Limit visitors and vehicles
- **Equipment hygiene** - Clean and disinfect between use
- **Monitor all species** - FMD can affect cattle, sheep, and pigs

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity to reduce risk
- **Good hygiene** - Clean facilities regularly
- **Build herd immunity** - Recovered animals protect the herd (>70% immune = 90% transmission reduction)

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce FMD risk by up to 75%
- **Track susceptibility** - Identify and cull animals prone to disease
- **Selective breeding** - Prioritize health in breeding decisions

**Early Detection**
- Monitor for symptoms daily
- Watch for lameness, reduced production, drooling
- Check for mouth lesions and foot problems
- Immediate action on any suspected case

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Low health genetics | +75% at 0.25 health | Selective breeding |
| Overcrowding (>100%) | +100% (doubles risk) | Expand capacity or reduce herd |
| High transmission rate | 10% base spread | Immediate treatment and isolation |
| Multi-species operation | Cross-species spread | Separate housing for different species |
| Young animals (6+ months) | 0.075% base risk | Extra monitoring |

## Economic Impact

### Direct Costs

| Cost Type | Amount | Duration |
|-----------|--------|----------|
| Treatment | $250 | One-time per treatment |
| Lost milk production | 65% reduction | 3+ months |
| Lost weight gain | 30% reduction | 3+ months |
| Sale value reduction | 50% | While sick |
| Mortality losses | 20%+ of infected | Ongoing if untreated |

### Calculation Example

**Single cow with FMD (treated immediately):**
- Treatment cost: $250
- Milk loss: 3 months at ~65% reduction = ~$195
- Weight loss during illness
- **Total cost: ~$450-500**

**Single cow with FMD (untreated):**
- No treatment cost: $0
- 20%+ mortality risk
- Permanent 65% milk reduction
- 50% sale value reduction
- Ongoing fertility problems
- **Total cost: $500-1,000+ or death**

**Outbreak scenario (10 cattle, 3 infected, not treated):**
- 3 infected cows: 60% chance at least one dies
- High transmission to remaining 7 cows (10% × 3/10 = 3% base per cow)
- Potential herd-wide infection within months
- **Total cost: $2,000-5,000+ in losses**

**Outbreak with immediate treatment:**
- 3 infected cows treated: $750
- Transmission stopped after treatment begins
- 7 healthy cows protected
- **Total cost: ~$1,500**

!!! tip "Economic Imperative"
    Treat FMD immediately. The high transmission rate means delaying treatment can lead to herd-wide infection and catastrophic losses.

### Indirect Costs

- Long treatment duration (3 months)
- Severely impaired breeding program (50% fertility reduction)
- Potential cross-species spread in mixed operations
- Management time dealing with outbreak
- Potential culling of severely affected animals

## Management Strategy

!!! danger "FMD Management Protocol"
    1. **Prevention First**
       - Strict biosecurity for all cloven-hoofed animals
       - Quarantine new arrivals
       - Separate cattle, sheep, and pig housing
       - Maintain <80% capacity

    2. **Early Detection**
       - Daily monitoring of all susceptible species
       - Watch for lameness, drooling, reduced production
       - Check feet and mouths regularly
       - Act on first sign of disease

    3. **Immediate Treatment**
       - Treat infected animals immediately
       - $250 treatment prevents ongoing mortality
       - 3-month treatment duration
       - 24-month immunity is excellent protection

    4. **Outbreak Response**
       - Identify all infected animals across all species
       - Treat all confirmed cases
       - Separate treated animals if possible
       - Monitor remaining animals closely
       - Consider treating entire group in severe outbreak

    5. **Long-term Prevention**
       - Build herd immunity through strategic treatment
       - >70% immune = 90% transmission reduction
       - Breed for high health genetics
       - Maintain excellent biosecurity
       - Regular health monitoring

## Multi-Species Considerations

FMD affects cattle, sheep, and pigs. Mixed species operations face unique challenges:

| Consideration | Impact | Management |
|---------------|--------|------------|
| Cross-species transmission | All species can infect each other | Separate housing for different species |
| Shared water/feed | Increases transmission risk | Separate feeding and watering areas |
| Equipment | Can spread disease | Clean and disinfect between species |
| Outbreak management | All species must be checked | Monitor all cloven-hoofed animals |

!!! warning "Mixed Operations Alert"
    If you raise cattle, sheep, and pigs in the same facility, FMD can spread between all three species. An outbreak in one species threatens all your cloven-hoofed livestock.

## Real-World Context

!!! note "Devastating Disease"
    In the real world, Foot and Mouth Disease is one of the most economically devastating livestock diseases. It can cause billion-dollar losses through trade restrictions, culling programs, and production losses. The disease is highly contagious and spreads rapidly, making early detection and response critical.

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Cattle Management](cattle.md) - Cattle-specific husbandry
- [Sheep Management](sheep.md) - Sheep-specific husbandry
- [Pig Management](pigs.md) - Pig-specific husbandry
