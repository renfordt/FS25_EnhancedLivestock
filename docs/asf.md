# African Swine Fever (ASF)

African Swine Fever is one of the most devastating viral diseases affecting pigs, with extremely high mortality rates and no treatment available. It spreads rapidly through pig populations and has catastrophic economic consequences.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Pigs only |
| Transmission Rate | 15% per month |
| Immunity Period | 24 months |
| Recovery Time | None (no natural recovery) |
| Sale Value Impact | 90% reduction (0.1 multiplier) |
| Weight Gain Impact | 70% reduction (0.3 multiplier) |

## Infection Risk

### Base Probability

The probability of contracting ASF is constant across all ages:

| Age (months) | Base Probability |
|--------------|------------------|
| All ages | 0.05% per month |

### Modifying Factors

The actual infection chance is modified by:

**Health Genetics Modifier**
- Health 1.75 (best): 0.0125% actual chance (75% reduction)
- Health 1.0 (average): 0.05% actual chance
- Health 0.25 (worst): 0.0875% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

### Transmission

ASF spreads extremely rapidly between pigs:

- **Base transmission rate**: 15% per month (highest transmission rate in the game)
- **Transmission chance**: `0.15 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of animals are immune, transmission is reduced by 90%

!!! danger "Explosive Transmission"
    ASF has the highest transmission rate of any disease in the game. A single infected pig can rapidly infect an entire herd if not immediately addressed.

## Symptoms and Effects

### Production Impact

ASF severely impacts manure production:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid manure | 30% | 70% reduction |
| Liquid manure | 200% | 2x increase (diarrhea) |

### Weight Impact

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 30% | Pigs gain weight extremely slowly |

!!! warning "Catastrophic Weight Loss"
    ASF causes the most severe weight gain penalty of any pig disease. Infected animals essentially stop growing.

### Fatality

ASF is nearly always fatal:

| Time | Fatality Rate | Cumulative Deaths |
|------|---------------|-------------------|
| 0 months (initial) | 80% | 80% dead immediately |
| 1 month | 95% (of survivors) | 99% dead total |

!!! danger "Near-Certain Death"
    ASF has a 80% immediate fatality rate, and 95% of survivors die within the first month. Only about 1% of infected animals survive beyond one month, and they remain carriers.

## Disease Progression

### Active Disease States

1. **Active (Infected)**
   - 80% chance of immediate death
   - If survives: 95% chance of death within 1 month
   - Severe weight gain reduction (70% penalty)
   - Altered manure production
   - 90% reduction in sale value
   - Highly contagious to other pigs

2. **Rare Survivor (Carrier)**
   - ~1% of infected pigs survive beyond 1 month
   - Remain carriers indefinitely
   - Can spread disease to healthy pigs
   - Severe production penalties continue
   - Should be culled immediately

3. **Immune (Survivors Only)**
   - If an animal somehow survives, gains 24-month immunity
   - Cannot be reinfected during immunity period
   - Production returns to normal after recovery

## Treatment

**No treatment is available for ASF:**

| Treatment Type | Available |
|----------------|-----------|
| Medicine | No |
| Vaccine | No |
| Natural recovery | No |

!!! danger "No Treatment Available"
    There is no treatment for African Swine Fever. The only management option is culling infected animals immediately to prevent spread.

### Management Options

1. **Immediate Culling**
   - Sell infected pigs immediately (accept the 90% value loss)
   - Prevents spread to healthy animals
   - Minimizes total herd losses

2. **Herd Depopulation**
   - In severe outbreaks, consider selling entire herd
   - Restock with healthy animals
   - Prevents catastrophic losses

3. **Quarantine**
   - Separate suspected animals immediately
   - Monitor for symptoms
   - Cull if confirmed positive

## Prevention

### Best Practices

**Biosecurity**
- **Critical importance** - ASF has no treatment, prevention is everything
- Monitor all animals daily for signs of infection
- Immediately isolate any sick-appearing pigs
- Maintain excellent facility hygiene

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity to reduce risk by 30%
- **Never exceed capacity** - Overcrowding doubles disease risk
- **Build herd immunity** - Survivors (rare) provide herd protection at >70%

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce ASF risk by up to 75%
- **Cull low-health animals** - Animals with poor health genetics are much more susceptible
- **Track disease history** - Identify and remove susceptible family lines

**Purchase Management**
- **Inspect all new pigs immediately** upon arrival
- **Quarantine new arrivals** if possible
- **Check health status** before introducing to main herd

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Low health genetics | +75% at 0.25 health | Selective breeding for health |
| Overcrowding (>100%) | +100% (doubles risk) | Expand capacity or reduce herd |
| High transmission rate | 15% base spread | Immediate culling of infected animals |
| No treatment | 99% mortality | Prevention is the only option |

## Economic Impact

### Direct Costs

| Cost Type | Amount | Notes |
|-----------|--------|-------|
| Sale value loss (infected) | 90% reduction | Infected pigs worth only 10% |
| Calf loss | ~99% mortality | Nearly all infected animals die |
| Herd contamination | Potentially entire herd | Rapid spread to all animals |
| Restocking costs | $100-300/pig | Must rebuild herd from scratch |

### Calculation Example

**Single infected pig (immediate culling):**
- Purchase/raise cost: $200
- Sale value when infected: $20 (90% loss)
- **Net loss: $180 per infected pig**

**Outbreak scenario (10 pigs, 3 infected, not culled):**
- 3 pigs die or sold at 90% loss: -$540
- Transmission to 4 more pigs over 1 month: -$720
- 7 pigs total affected/dead: -$1,260
- Potential total herd loss if unchecked: -$2,000+
- **Cost of not acting: $1,260-2,000+**

**Outbreak with immediate culling:**
- 3 infected pigs sold immediately: -$540
- Transmission prevented
- 7 healthy pigs saved: $1,400 value preserved
- **Cost of immediate action: $540**

!!! tip "Economic Imperative"
    Immediately cull any pig showing ASF symptoms. The cost of losing one pig at 90% value is far less than the cost of losing your entire herd.

### Indirect Costs

- Complete herd depopulation in worst cases
- Facility downtime and cleaning
- Lost breeding programs and genetics
- Emotional toll of mass culling
- Reputation damage for breeding operations

## Management Strategy

!!! danger "ASF Management Protocol"
    1. **Daily Monitoring**
       - Check all pigs daily for signs of illness
       - Watch for lethargy, loss of appetite, fever
       - Immediate action on any suspected case

    2. **Immediate Culling**
       - Sell suspected ASF cases immediately
       - Do not wait for confirmation
       - Accept the 90% value loss to save the herd

    3. **Outbreak Response**
       - If multiple pigs infected, consider selling entire herd
       - Clean and disinfect facilities thoroughly
       - Wait before restocking
       - Restock with high-health genetics only

    4. **Prevention Focus**
       - Maintain <80% capacity at all times
       - Breed exclusively for high health genetics
       - Never purchase low-health pigs
       - Excellent biosecurity and hygiene

    5. **Zero Tolerance**
       - One infected pig is an emergency
       - Act within the same game day
       - No exceptions, no waiting

## Configuration

ASF is enabled/disabled by the global disease system setting:

- **Disease System Enabled**: ASF can occur with 0.05% base monthly probability
- **Disease System Disabled**: No diseases, all animals healthy

## Real-World Context

!!! note "Historical Impact"
    In the real world, African Swine Fever has devastated pig industries worldwide, causing billions of dollars in losses. There is still no vaccine or treatment available. The game's severe mortality and transmission rates accurately reflect the real disease's catastrophic nature.

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Pig Management](pigs.md) - Pig-specific husbandry
