# Internal Parasites (Stomach Worms and Liver Flukes)

Internal parasites, primarily stomach worms (*Haemonchus contortus*, barber pole worm) and liver flukes, cause anemia, weight loss, bottle jaw, and poor wool production in sheep. They represent the biggest ongoing health challenge in sheep farming, with a critically short 3-month immunity period requiring frequent management.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Sheep only |
| Transmission Rate | 4% per month |
| Immunity Period | 3 months (very short) |
| Recovery Time | 4 months (natural) |
| Sale Value Impact | 35% reduction (0.65 multiplier) |
| Seasonal Pattern | Spring/Summer 1.5x, Autumn 1.0x, Winter 0.5x |

!!! warning "Short Immunity Challenge"
    Internal Parasites have only a 3-month immunity period - the shortest of any treatable disease. Sheep can be reinfected quickly, making this a recurring management challenge requiring strategic deworming programs.

## Infection Risk

### Base Probability

Internal Parasites can affect sheep of all ages with consistent probability:

| Age (months) | Base Probability |
|--------------|------------------|
| 0+ | 0.3% per month |

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.075% actual chance (75% reduction)
- Health 1.0 (average): 0.3% actual chance
- Health 0.25 (worst): 0.525% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Seasonal Modifier (Critical)**
- **Spring** (Mar-May): 1.5x probability (warm, wet = high larvae survival)
- **Summer** (Jun-Aug): 1.5x probability (optimal conditions for parasites)
- **Autumn** (Sep-Nov): 1.0x probability (baseline)
- **Winter** (Dec-Feb): 0.5x probability (cold kills larvae)

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A sheep with average health (1.0) in summer at >100% capacity:
- Base: 0.3%
- × Health: 1.0
- × Season: 1.5
- × Overcrowding: 2.0
- **= 0.9% monthly chance** (very high during warm seasons)

### Transmission

Internal Parasites spread through fecal contamination of pastures:

- **Base transmission rate**: 4% per month
- **Transmission chance**: `0.04 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × seasonal_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of sheep are immune, transmission is reduced by 90%
- **Note**: Only 3-month immunity means herd immunity is temporary and difficult to maintain

!!! info "Pasture Contamination Cycle"
    Infected sheep shed parasite eggs in manure → larvae develop on pasture → sheep graze contaminated grass → larvae burrow into gut lining → mature worms produce eggs → cycle repeats. Breaking this cycle requires both treatment and pasture management.

## Symptoms and Effects

### Production Impact

Internal Parasites significantly reduce wool production and increase manure output:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Wool (Pallets) | 50% | 50% reduction in wool production |
| Solid Manure | 150% | 1.5x increase (irritation causes more manure) |

!!! warning "Wool Production Devastation"
    The 50% wool reduction represents one of the most severe production penalties in the game. For wool sheep, internal parasites can cut income in half.

### Fatality

Internal Parasites become increasingly dangerous if left untreated:

| Time After Infection | Fatality Rate | Cumulative Deaths |
|----------------------|---------------|-------------------|
| Month 0-5 | 0% | 0% |
| Month 6 | 3% | 3% |
| Month 12+ | 8% | ~11% total |

!!! warning "Progressive Deterioration"
    While not immediately fatal, untreated parasite burdens progressively weaken sheep through chronic blood loss (anemia) and malnutrition. Death rates increase the longer parasites remain untreated.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Anemia (pale gums, weakness)
   - Bottle jaw (fluid accumulation under jaw)
   - Weight loss despite adequate feed
   - Poor wool quality and 50% production loss
   - 150% manure increase
   - Can spread to other sheep (4% transmission)
   - Progressive fatality (0% → 8% over 12 months)
   - 35% reduction in sale value

2. **Being Treated**
   - $50 cost for 1 month (very affordable)
   - Production penalties continue during treatment
   - After 1 month, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for **only 3 months**
   - No production penalties
   - No sale value penalty
   - **Short immunity requires repeat treatments**

### Natural Recovery

Sheep can recover naturally without treatment:
- After 4 months with parasites, 75% chance of natural recovery each month
- Natural recovery grants the same 3-month immunity
- Saves $50 treatment cost
- Higher death risk during untreated period (11% vs ~3% if treated)
- 4-6 months of 50% wool production loss vs. 1 month if treated

!!! note "Natural Recovery Considerations"
    With only $50 treatment cost, natural recovery is rarely economical. The extended wool production loss (50% for 4-6 months vs. 1 month) costs far more than treatment.

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $50 |
| Duration | 1 month |
| Total Cost | $50 |
| Immunity Granted | 3 months (short) |

### Treatment Process

1. Select the infected sheep in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $50 treatment cost (MEDICINE finance category)
4. Deworming medication administered
5. Wait 1 month for treatment to complete
6. Sheep recovers and gains 3 months of immunity
7. Wool production returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Immunity Duration | Total Loss |
|----------|------|------------------|-------------------|------------|
| Immediate treatment | $50 | 1 month | 3 months | $50 + 1 month wool loss |
| Wait for natural recovery | $0 | 4-6 months average | 3 months | 0 + 4-6 months wool loss |

!!! tip "Treatment is Always Economical"
    For wool sheep, one month of lost wool production (~$20-30 value) nearly pays for the $50 treatment. Waiting 4-6 months for natural recovery loses $80-180 in wool production to save $50 in treatment costs - a terrible trade.

## Prevention

### Best Practices

**Pasture Management (Critical)**
- **Rotational grazing** - Move sheep to clean pasture every 2-4 weeks
- **Rest paddocks** - Leave grazed pastures empty for 3+ months to kill larvae
- **Mixed species grazing** - Cattle/horses eat sheep parasite larvae without harm
- **Avoid wet pastures** - Larvae thrive in moisture
- **Don't overgraze** - Short grass forces sheep to graze closer to manure

**Strategic Deworming**
- **Treat in spring** - Before seasonal peak (1.5x risk)
- **Treat high-risk animals** - Lambs, thin ewes, heavily pregnant ewes
- **Rotate dewormers** - Prevent resistance development
- **Target treatment** - Don't deworm entire flock unnecessarily
- **Monitor fecal egg counts** - Test to determine when treatment is needed

**Environmental Management**
- **Avoid overcrowding** - Keep below 80% capacity
- **Clean water sources** - Prevent fecal contamination
- **Good drainage** - Dry conditions reduce larvae survival
- **Remove manure** - From housing areas regularly

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce infection risk by up to 75%
- **Parasite resistance** - Some bloodlines naturally resist parasites
- **FAMACHA scoring** - Assess anemia visually to identify susceptible individuals
- **Cull chronic cases** - Remove sheep requiring frequent treatment

**Nutrition**
- **Good body condition** - Well-fed sheep resist parasites better
- **Protein supplementation** - Helps rebuild blood lost to worms
- **Minerals** - Copper, selenium support immune function

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce flock |
| Spring/Summer seasons | +50% | Strategic deworming before peak season |
| Wet pastures | Very high | Drainage, avoid low-lying areas |
| Continuous grazing | Very high | Rotational grazing system |
| No pasture rest | Very high | Rest paddocks 3+ months |
| Young lambs | High | Monitor closely, deworm as needed |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Duration |
|----------------|--------|----------|
| Treatment | $50 | One-time per infection |
| Lost wool production | 50% for duration | Major impact for wool sheep |
| Sale value reduction | 35% | While sick |
| Death loss | 3-11% depending on duration | Progressive risk |
| Repeat treatments | $50 every 3+ months | Due to short immunity |

### Calculation Examples

**Wool sheep with Internal Parasites (treated immediately):**
- Treatment: $50
- Wool loss: 1 month at 50% = ~$15-25 lost
- Death risk: ~3%
- **Total cost: $50 + $20 wool = ~$70**

**Wool sheep with Internal Parasites (natural recovery, 5 months):**
- Treatment: $0
- Wool loss: 5 months at 50% = ~$75-125 lost
- Death risk: ~8%
- **Total cost: $0 + $100 wool loss = ~$100 (worse than treatment!)**

**Flock of 50 sheep, 10 infected, spring:**
- If all 10 treated immediately: 10 × $50 = $500
- Wool loss prevented: 10 sheep × 4 months saved × $20/month = $800
- Transmission prevented during treatment
- **Treatment saves money even ignoring transmission**

**Flock with poor pasture management (ongoing parasite pressure):**
- 50 sheep, 20% infected every 3-4 months (10 sheep)
- Annual treatments: 10 sheep × 4 treatments = 40 treatments
- Annual cost: 40 × $50 = $2,000
- **vs. improving pasture management: $500 one-time, reduces infections 75%**

### Indirect Costs

- **Dewormer resistance** - Overuse creates resistant parasites requiring expensive alternatives
- **Permanent production loss** - Chronic parasite burdens cause lasting damage
- **Management time** - Frequent monitoring and treatment
- **Pasture management costs** - Fencing for rotational grazing
- **Lost genetic progress** - Culling chronically infected animals
- **Lamb growth** - Parasitized ewes produce less milk, slower-growing lambs

### Annual Cost of Parasites

For a flock of 100 sheep with moderate parasite pressure:
- Expected infections: 20-30 sheep per year
- Treatment costs: 25 × $50 = $1,250
- Wool losses (if untreated): 25 × 5 months × $20 = $2,500
- Deaths: 25 × 8% × $150 = $300
- **Total impact: $1,250-4,000+ annually**

## Management Strategy

!!! tip "Internal Parasite Control Protocol"
    **1. Rotational Grazing (Most Important)**
    - Move sheep to fresh pasture every 2-4 weeks
    - Rest grazed paddocks for 3+ months
    - This breaks the parasite lifecycle more effectively than any drug
    - Mixed species grazing with cattle/horses highly effective

    **2. Strategic Deworming (Not Blanket Treatment)**
    - Treat in late winter/early spring before seasonal peak
    - Target high-risk animals: thin sheep, lambs, pregnant ewes
    - Don't deworm entire flock - leaves some worms unexposed to drugs
    - Rotate dewormer classes to prevent resistance

    **3. Monitor, Don't Assume**
    - Fecal egg counts to determine when treatment needed
    - FAMACHA scoring for anemia assessment
    - Body condition scoring
    - Don't treat on a calendar - treat based on monitoring

    **4. Immediate Treatment When Infected**
    - $50 treatment is very affordable
    - Saves months of wool production loss
    - Reduces death risk from 11% to 3%
    - Stops transmission to flock

    **5. Short Immunity Management**
    - Only 3 months immunity (shortest of any disease)
    - Sheep can be reinfected 4 times per year
    - Can't rely on herd immunity like other diseases
    - Pasture management is MORE important than treatment

    **6. Seasonal Awareness**
    - Spring/Summer: 1.5x risk (warm, wet)
    - Autumn: Baseline risk
    - Winter: 0.5x risk (cold kills larvae)
    - Time treatments for late winter to protect through high-risk seasons

    **7. Pasture Management**
    - Never graze the same paddock continuously
    - Avoid wet, low-lying areas
    - Mixed species grazing breaks parasite cycle
    - Maintain good grass height (sheep don't graze near manure if tall grass available)

    **8. Genetic Selection**
    - Breed for high health genetics
    - Some sheep naturally resistant to parasites
    - Cull sheep requiring frequent deworming
    - Build resistance into the flock genetically

    **9. Prevent Resistance**
    - Don't deworm entire flock every time
    - Leave some parasites unexposed to drugs (refugia)
    - Rotate dewormer classes annually
    - Use fecal egg counts to confirm efficacy

    **10. Long-Term Strategy**
    - Invest in rotational grazing infrastructure
    - Build genetically resistant flock
    - Reduce reliance on dewormers
    - Sustainable parasite control through management, not just drugs

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Sheep Management](sheep.md) - Sheep-specific husbandry
