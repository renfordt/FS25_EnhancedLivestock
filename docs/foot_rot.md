# Foot Rot

Foot Rot is a contagious bacterial infection of the feet affecting cattle and sheep, causing lameness and reduced productivity. The disease thrives in wet, muddy conditions and is highly seasonal, with peak occurrence during wet spring and autumn months.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle, Sheep |
| Transmission Rate | 4% per month |
| Immunity Period | 6 months |
| Recovery Time | None (does not naturally recover) |
| Sale Value Impact | 35% reduction (0.65 multiplier) |
| Weight Gain Impact | 15% reduction (0.85 multiplier) |
| Seasonal Pattern | Spring 1.5x, Summer 0.8x, Autumn 1.5x, Winter 0.8x |

## Infection Risk

### Base Probability

Foot Rot only affects animals over 6 months of age:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-5 | 0% (too young) |
| 6+ | 0.1% per month |

!!! info "Age Restriction"
    Young animals under 6 months have developing hooves and different foot structure that makes them resistant to Foot Rot.

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.025% actual chance (75% reduction)
- Health 1.0 (average): 0.1% actual chance
- Health 0.25 (worst): 0.175% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Seasonal Modifier**
- **Spring** (Mar-May): 1.5x probability (wet conditions)
- **Summer** (Jun-Aug): 0.8x probability (dry conditions)
- **Autumn** (Sep-Nov): 1.5x probability (wet conditions)
- **Winter** (Dec-Feb): 0.8x probability (frozen ground)

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** An animal with average health (1.0) in spring at >100% capacity:
- Base: 0.1%
- × Health: 1.0
- × Season: 1.5
- × Overcrowding: 2.0
- **= 0.3% monthly chance** (3x higher than summer baseline)

### Transmission

Foot Rot spreads between animals through contaminated ground and direct contact:

- **Base transmission rate**: 4% per month
- **Transmission chance**: `0.04 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × seasonal_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of animals are immune, transmission is reduced by 90%

!!! warning "Environmental Contamination"
    Bacteria persist in soil for months. Wet, muddy conditions allow bacteria to invade hoof tissue, making drainage and dry footing critical for prevention.

## Symptoms and Effects

### Production Impact

Foot Rot reduces productivity across multiple outputs:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Milk (Cattle) | 70% | 30% reduction in dairy cows |
| Wool (Sheep) | 60% | 40% reduction in sheep |
| Solid Manure | 80% | 20% reduction |

!!! info "Lameness Impact"
    Lameness reduces grazing ability and feed intake, leading to lower production across all outputs.

### Weight and Growth

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 85% | 15% slower growth |

### Fatality

Foot Rot is not fatal:

| Time | Fatality Rate |
|------|---------------|
| All stages | 0% |

!!! note "Non-Fatal But Debilitating"
    While Foot Rot doesn't kill, it causes chronic lameness that significantly impacts productivity and animal welfare.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Lameness and reduced movement
   - 30% milk reduction (cattle) or 40% wool reduction (sheep)
   - 15% weight gain reduction
   - Can spread to other animals (4% transmission)
   - No fatality risk
   - 35% reduction in sale value

2. **Being Treated**
   - $200 cost per month for 2 months
   - Production penalties continue during treatment
   - After 2 months, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 6 months
   - No production penalties
   - No sale value penalty

### No Natural Recovery

Unlike many diseases, Foot Rot does NOT naturally recover:
- Animals remain infected indefinitely without treatment
- Chronic production losses continue
- Ongoing transmission to other animals
- **Treatment is the only cure**

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $200 per month |
| Duration | 2 months |
| Total Cost | $400 |
| Immunity Granted | 6 months |

### Treatment Process

1. Select the infected animal in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $200 monthly treatment cost (MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Animal recovers and gains 6 months of immunity
6. Production returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Total Loss |
|----------|------|------------------|------------|
| Immediate treatment | $400 | 2 months | $400 + 2 months production loss |
| Delay treatment | $400 | Delayed | $400 + extended production loss |
| No treatment | $0 | Never | Permanent production loss + ongoing spread |

!!! danger "Treatment is Mandatory"
    Foot Rot NEVER naturally recovers. Untreated animals suffer permanent production losses and continuously infect others. Treatment is not optional - it's required.

## Prevention

### Best Practices

**Environmental Management**
- **Drainage** - Ensure good drainage to prevent muddy areas
- **Dry footing** - Provide dry standing areas, especially in wet seasons
- **Regular hoof trimming** - Maintain proper hoof health
- **Footbaths** - Consider footbaths in high-risk periods
- **Avoid overcrowding** - Keep below 80% capacity to reduce transmission

**Seasonal Management**
- **Spring preparation** (1.5x risk) - Improve drainage before wet season
- **Summer advantage** (0.8x risk) - Treat chronic cases during dry months
- **Autumn vigilance** (1.5x risk) - Monitor closely during wet weather
- **Winter monitoring** (0.8x risk) - Lower risk but still present

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce Foot Rot risk by up to 75%
- **Hoof quality** - Some bloodlines have better hoof structure
- **Track disease history** - Identify animals prone to foot problems

**Herd Immunity**
- Recovered animals are immune for 6 months
- Build immunity through strategic treatment
- When >70% immune, transmission drops 90%
- Short immunity period requires ongoing vigilance

### Risk Factors

| Factor | Risk Multiplier | Mitigation |
|--------|-----------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Wet seasons (spring/autumn) | +50% | Improve drainage, provide dry areas |
| Poor drainage | Significant increase | Install drainage systems |
| Combined factors | Multiplicative | Address all factors simultaneously |

**Worst Case Scenario:**
Average animal + spring + overcrowding + poor drainage = **0.3%+ monthly risk**

## Economic Impact

### Direct Costs

| Cost Component | Amount | Duration |
|----------------|--------|----------|
| Treatment (2 months) | $400 | Per animal |
| Lost milk (cattle) | 30% for duration | Dairy cattle |
| Lost wool (sheep) | 40% for duration | Wool sheep |
| Reduced weight gain | 15% for duration | All animals |
| Sale value reduction | 35% | While sick |

### Calculation Examples

**Dairy cow with Foot Rot (treated immediately):**
- Treatment: $400
- Milk loss: 2 months × 30% × $100/month = $60
- **Total cost: ~$460**

**Dairy cow with Foot Rot (untreated for 12 months):**
- Treatment: $0
- Milk loss: 12 months × 30% × $100/month = $360
- Sale value loss: 35% × $1,500 = $525 (if sold)
- Ongoing transmission to other animals
- **Total cost: $360+ in lost revenue + spread costs**

**Wool sheep with Foot Rot (treated immediately):**
- Treatment: $400
- Wool loss: 2 months × 40% × production value
- **Total cost: $400 + wool production loss**

**Herd outbreak (30 sheep, 8 infected, spring):**
- If untreated: Ongoing transmission (4% × 8/30 × 1.5 seasonal = high spread)
- Potential spread to entire flock over time
- Treatment cost: 8 sheep × $400 = $3,200
- If spreads to 20 sheep = $8,000+
- **Early treatment prevents cascade**

### Indirect Costs

- **Chronic lameness** - Welfare concerns and reduced grazing efficiency
- **Environmental contamination** - Bacteria persist in soil for months
- **Management time** - Treating and monitoring lame animals
- **Reduced breeding value** - Lame animals less desirable
- **Seasonal vulnerability** - Wet seasons require extra vigilance

## Management Strategy

!!! tip "Foot Rot Prevention and Control Protocol"
    **1. Environmental Prevention (Critical)**
    - Install proper drainage systems
    - Provide dry standing areas
    - Avoid muddy conditions, especially in wet seasons
    - Regular manure removal from housing
    - Maintain clean, dry bedding

    **2. Seasonal Awareness**
    - Prepare drainage before spring (1.5x risk)
    - Treat chronic cases in summer (0.8x risk)
    - Extra vigilance in autumn (1.5x risk)
    - Monitor during wet weather events

    **3. Regular Monitoring**
    - Check for lameness weekly
    - Inspect hooves regularly
    - Look for swelling, heat, foul odor
    - Early detection = faster treatment

    **4. Immediate Treatment (Mandatory)**
    - Foot Rot NEVER naturally recovers
    - Treat at first signs of lameness
    - $400 treatment prevents permanent loss
    - Untreated = lifelong production penalty

    **5. Herd Immunity (Short-Term)**
    - Recovered animals immune for 6 months
    - Build immunity through strategic treatment
    - When >70% immune, outbreaks stop (90% reduction)
    - Re-vaccination needed twice yearly due to short immunity

    **6. Genetic Improvement**
    - Breed for high health genetics
    - Select animals with good hoof quality
    - Cull chronic cases
    - Some bloodlines more resistant

    **7. Preventive Foot Care**
    - Regular hoof trimming
    - Footbaths in high-risk periods
    - Copper sulfate or zinc sulfate solutions
    - Proper nutrition for hoof health

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Cattle Management](cattle.md) - Cattle-specific husbandry
- [Sheep Management](sheep.md) - Sheep-specific husbandry
