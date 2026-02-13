# Porcine Epidemic Diarrhea (PED)

Porcine Epidemic Diarrhea is a devastating viral disease that primarily affects young pigs, causing severe diarrhea, dehydration, and extremely high mortality rates in piglets. It is one of the most dangerous diseases for pig operations.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Pigs only |
| Transmission Rate | 7.5% per month |
| Immunity Period | 12 months |
| Recovery Time | 3 months (natural recovery possible) |
| Sale Value Impact | 35% reduction (0.65 multiplier) |
| Weight Gain Impact | 50% reduction (0.5 multiplier) |

## Infection Risk

### Base Probability

PED probability is highest in young animals and decreases dramatically with age:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-5 | 12.5% per month |
| 6-17 | 5% per month |
| 18-23 | 1% per month |
| 24+ | 0.1% per month |

!!! danger "Piglet Vulnerability"
    Young piglets (0-6 months) have a 12.5% monthly chance of contracting PED - this is one of the highest infection rates in the game. Piglets are extremely susceptible.

### Modifying Factors

The actual infection chance is modified by:

**Health Genetics Modifier**
- Health 1.75 (best): Reduces probability by 75%
- Health 1.0 (average): No change
- Health 0.25 (worst): Increases probability by 75%
- Formula: `base_probability × (2.0 - health_genetics)`

**Age-Based Risk Examples:**
- Piglet (0-5 months) with poor health (0.25): 12.5% × 1.75 = 21.875% monthly risk
- Piglet (0-5 months) with good health (1.75): 12.5% × 0.25 = 3.125% monthly risk
- Adult pig (24+ months) with average health: 0.1% monthly risk

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

### Transmission

PED spreads rapidly between pigs, especially in crowded conditions:

- **Base transmission rate**: 7.5% per month
- **Transmission chance**: `0.075 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of animals are immune, transmission is reduced by 90%

## Symptoms and Effects

### Production Impact

PED causes severe diarrhea, dramatically altering manure production:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Liquid manure | 400% | 4x increase (severe diarrhea) |
| Solid manure | 25% | 75% reduction |

!!! warning "Manure Management Impact"
    PED causes a 4x increase in liquid manure production. Ensure adequate liquid manure storage capacity during outbreaks.

### Weight Impact

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 50% | Pigs gain weight very slowly |

### Fatality

PED has very high fatality rates, especially initially:

| Time | Fatality Rate | Cumulative Deaths |
|------|---------------|-------------------|
| 0 months (initial) | 85% | 85% dead immediately |
| 1 month | 7.5% (of survivors) | ~86% dead total |
| 2 months | 0.025% (of survivors) | ~86% dead total |

!!! danger "Devastating Mortality"
    PED has an 85% immediate fatality rate. Most infected piglets die within hours to days of showing symptoms. Even with treatment, survival rates are poor.

### Age-Based Mortality

The fatality rates above apply to all ages, but younger animals are:
1. More likely to contract the disease (12.5% vs 0.1%)
2. More likely to die from it (less developed immune systems)

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - 85% chance of immediate death
   - If survives: 7.5% chance of death in month 1
   - Severe diarrhea (4x liquid manure)
   - Severe weight loss (50% penalty)
   - 35% reduction in sale value
   - Highly contagious to other pigs
   - Can recover naturally after 3 months (75% chance per month)

2. **Being Treated**
   - $150 cost per month
   - Still face initial 85% mortality
   - After 1 month treatment, becomes immune
   - Production impacts continue during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 12 months
   - No production penalties
   - No sale value penalty

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $150 |
| Duration | 1 month |
| Immunity Granted | 12 months |

### Treatment Process

1. Select the infected pig in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $150 treatment cost (charged to MEDICINE finance category)
4. Wait 1 month for treatment to complete
5. Pig recovers and gains 12 months of immunity (if it survives)
6. Production resumes normally

!!! warning "Treatment Limitations"
    Treatment does NOT prevent the initial 85% fatality rate. Most infected pigs will die before treatment can take effect. Treatment is most effective for the 15% that survive the initial infection.

### Natural Recovery

Animals can recover naturally without treatment:
- After 3 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 12-month immunity
- Saves $150 treatment cost
- Higher total mortality waiting for natural recovery (more time for fatality checks)

## Prevention

### Best Practices

**Biosecurity - Critical for Pig Operations**
- **Quarantine all new arrivals** - Minimum 30 days
- **Limit farm access** - Control who enters pig areas
- **Clean vehicles** - Disinfect trucks and equipment
- **Dedicated boots/clothing** - Separate gear for pig areas
- **No farm-to-farm movement** - Highest risk factor

**Age-Based Management**
- **Separate young pigs** - Keep piglets isolated from older animals
- **All-in/all-out** - Group management by age
- **Clean between groups** - Disinfect facilities thoroughly
- **Delay farrowing during outbreaks** - Don't introduce vulnerable piglets

**Husbandry Management**
- **Avoid overcrowding** - Critical for young pigs
- **Excellent sanitation** - Clean facilities daily during outbreaks
- **Adequate spacing** - Reduce transmission opportunity
- **Good ventilation** - Helps reduce viral load

**Genetic Selection**
- **Breed for health** - High health genetics dramatically reduce risk
- **Cull low-health animals** - Especially important in breeding stock
- **Track susceptibility** - Identify resistant family lines

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Young age (0-6 months) | 12.5% base risk | Separate age groups, excellent biosecurity |
| Low health genetics | +75% at 0.25 health | Selective breeding |
| Overcrowding (>100%) | +100% (doubles risk) | Maintain adequate space, especially for piglets |
| High transmission rate | 7.5% base spread | Immediate isolation and treatment |
| New animal introductions | High risk | Strict quarantine protocols |

## Economic Impact

### Direct Costs

| Cost Type | Amount | Notes |
|-----------|--------|-------|
| Treatment | $150 per pig | Often doesn't save piglets |
| Piglet mortality | 85% of infected | Catastrophic losses |
| Sale value reduction | 35% | For survivors |
| Lost weight gain | 50% reduction | During illness |

### Calculation Example

**10 young piglets exposed to PED:**
- Base infection rate: 12.5% = ~1-2 piglets infected per month
- Infected piglet mortality: 85% = Most infected die
- Transmission to others: 7.5% × 1/10 = 0.75% additional risk per remaining piglet
- **Expected outcome**: 1-2 dead piglets per month during outbreak

**10 young piglets, 3 infected, untreated:**
- 3 infected piglets: 2-3 die immediately (85% mortality)
- 0-1 survivors with severe symptoms
- Transmission to 7 healthy piglets over coming months
- **Total loss**: 50-100% of group if unchecked

**Outbreak with immediate treatment and isolation:**
- 3 infected piglets: 2-3 die despite treatment
- Treatment cost: 3 × $150 = $450
- 0-1 survivors recover
- Isolation prevents transmission to healthy piglets
- **Total loss**: $450 + 2-3 piglets vs potential loss of entire group

!!! tip "Management Recommendation"
    With an 85% fatality rate, preventing PED is far more cost-effective than treating it. Focus resources on biosecurity, especially for young pigs.

### Indirect Costs

- Complete loss of farrowing cycles during outbreaks
- Facility downtime for deep cleaning
- Psychological impact of high piglet mortality
- Lost breeding program momentum
- Reputation damage for breeding operations
- Ongoing biosecurity infrastructure costs

## Management Strategy

!!! danger "PED Management Protocol"
    1. **Prevention is Everything**
       - PED has 85% mortality - prevention is the only real defense
       - Strict biosecurity for all pig operations
       - Quarantine ALL new animals for 30+ days
       - Separate young and old pigs completely

    2. **Age-Specific Protection**
       - Piglets are extremely vulnerable (12.5% monthly risk)
       - Never mix age groups during outbreaks
       - All-in/all-out management for young pigs
       - Delay breeding during active outbreaks

    3. **Outbreak Response**
       - Isolate infected animals immediately
       - Treat survivors (most will die anyway)
       - Protect uninfected young pigs at all costs
       - Deep clean facilities
       - Consider culling entire affected group in severe cases

    4. **Facility Management**
       - Separate housing for different age groups
       - Dedicated equipment for each group
       - Easy-to-clean surfaces
       - Adequate liquid manure storage (4x increase during outbreak)

    5. **Long-term Prevention**
       - Build herd immunity in adult pigs (survivors immune 12 months)
       - Never introduce virus to young pigs intentionally
       - Breed for high health genetics
       - Maintain excellent biosecurity permanently

## Breeding Considerations

!!! warning "Farrowing During PED Risk"
    - Do NOT breed sows during PED outbreaks
    - Delay farrowing until facility is confirmed clean
    - New piglets are the most vulnerable animals on the farm
    - 12.5% monthly infection risk + 85% mortality = catastrophic losses
    - Wait until herd immunity is established (>70% immune)

## Real-World Context

!!! note "Devastating Disease"
    In the real world, Porcine Epidemic Diarrhea caused billions of dollars in losses to the US pork industry when it emerged in 2013. Mortality rates in piglets can approach 100%. The disease remains a major threat to pig producers worldwide. The game's mechanics accurately reflect the catastrophic nature of PED in young pigs.

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Pig Management](pigs.md) - Pig-specific husbandry
- [Breeding Guide](breeding.md) - Breeding management strategies
