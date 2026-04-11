# Mastitis

Mastitis is an infection of the udder that affects lactating dairy animals, causing significant production losses.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle, Sheep |
| Transmission Rate | 5% per month |
| Immunity Period | 12 months |
| Recovery Time | 3 months (natural) |
| Sale Value Impact | 15% reduction (0.85 multiplier) |
| Weight Gain Impact | 15% reduction (0.85 multiplier) |
| Fertility Impact | 30% reduction (0.7 multiplier) |

## Prerequisites

Mastitis only affects animals that are currently lactating. Non-lactating animals cannot contract this disease.

| Condition | Required Value |
|-----------|----------------|
| Lactating | True |

## Infection Risk

### Base Probability

The probability of contracting mastitis increases with age:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-11 | 0% (not lactating) |
| 12+ | 0.5% per month |

### Modifying Factors

The actual infection chance is modified by:

**Health Genetics Modifier**
- Health 1.75 (best): 0.125% actual chance (75% reduction)
- Health 1.0 (average): 0.5% actual chance
- Health 0.25 (worst): 0.875% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

### Transmission

Mastitis can spread between lactating animals in the same husbandry:

- **Base transmission rate**: 5% per month
- **Transmission chance**: `0.05 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of animals are immune, transmission is reduced by 90%

## Symptoms and Effects

### Production Impact

Mastitis eliminates milk production completely:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Milk | 0% | Complete cessation |
| Pallet production | 0% | No dairy product output |

!!! warning "Complete Production Loss"
    Animals with mastitis produce NO milk until treated and recovered. This represents significant economic loss for dairy operations.

### Weight and Reproduction

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 85% | Slower growth, lower sale weight |
| Fertility | 70% | Reduced breeding success rate |

### Fatality

Mastitis is not fatal:

| Time | Fatality Rate |
|------|---------------|
| All stages | 0% |

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Zero milk production
   - Reduced weight gain and fertility
   - Can spread to other lactating animals
   - 15% reduction in sale value

2. **Being Treated**
   - $200 cost per month
   - Zero milk production continues
   - After 1 month, becomes immune
   - Cannot spread during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 12 months
   - No production penalties
   - No sale value penalty

### Natural Recovery

Animals can recover naturally without treatment:
- After 3 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 12-month immunity
- Saves $200 treatment cost
- Longer production loss while waiting for natural recovery

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $200 |
| Duration | 1 month |
| Immunity Granted | 12 months |

### Treatment Process

1. Select the infected animal in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $200 treatment cost (charged to MEDICINE finance category)
4. Wait 1 month for treatment to complete
5. Animal recovers and gains 12 months of immunity
6. Production resumes normally

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Total Loss |
|----------|------|------------------|------------|
| Immediate treatment | $200 | 1 month | $200 + 1 month milk loss |
| Wait for natural recovery | $0 | 3-6 months average | 3-6 months milk loss |

!!! tip "Treatment Recommendation"
    Always treat mastitis immediately. The cost of lost milk production far exceeds the $200 treatment cost.

## Prevention

### Best Practices

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity to reduce disease risk by 30%
- **Monitor lactating animals** - Check regularly for signs of infection
- **Build herd immunity** - Recovered animals protect the herd (>70% immune = 90% transmission reduction)

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) dramatically reduce mastitis risk
- **Track disease history** - Identify animals prone to mastitis
- **Cull chronic cases** - Some individuals are more susceptible

**Hygiene Practices**
- Maintain clean milking conditions
- Proper milking equipment maintenance
- Clean housing and bedding
- Good nutrition supports immune function

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Low health genetics | +75% at 0.25 health | Selective breeding |
| Overcrowding (>100%) | +100% (doubles risk) | Expand capacity or reduce herd |
| Poor hygiene | Increases transmission | Better sanitation |
| No herd immunity | Full transmission rate | Maintain immunity through strategic treatment |

## Economic Impact

### Direct Costs

| Cost Type | Amount | Duration |
|-----------|--------|----------|
| Treatment | $200 | One-time (per treatment) |
| Lost milk production | Variable | 1+ months |
| Sale value reduction | 15% | While sick |

### Calculation Example

**Single cow with mastitis (treated immediately):**
- Treatment cost: $200
- Milk loss: 1 month at ~$100/month = $100
- **Total cost: ~$300**

**Single cow with mastitis (natural recovery, 4 months average):**
- Treatment cost: $0
- Milk loss: 4 months at ~$100/month = $400
- **Total cost: ~$400**

### Outbreak Scenario

**10 lactating cows, 3 infected:**
- If untreated: High transmission to remaining 7 cows (5% × 3/10 = 1.5% base, modified by health/overcrowding)
- If treated: Minimal spread during treatment
- **Cost difference**: Treating 3 cows ($600) vs. potential outbreak affecting 7+ cows ($2,000+)

### Indirect Costs

- Management time monitoring affected animals
- Reduced fertility delays next generation
- Potential for repeated infections if underlying causes not addressed
- Stress on farm cash flow during outbreaks

## Management Strategy

!!! tip "Mastitis Management Protocol"
    1. **Prevention First**
       - Maintain <80% capacity
       - Breed for high health genetics
       - Keep excellent hygiene standards

    2. **Early Detection**
       - Monitor all lactating animals monthly
       - Watch for production drops
       - Check disease status regularly

    3. **Immediate Treatment**
       - Treat infected animals immediately
       - Don't wait for natural recovery
       - $200 treatment saves $200+ in lost milk

    4. **Herd Immunity**
       - Build up immune animals (recovered = immune for 12 months)
       - When >70% immune, transmission drops 90%
       - Strategic treatment protects entire herd

    5. **Long-term Prevention**
       - Select breeding stock with high health genetics
       - Maintain proper capacity ratios
       - Continuous hygiene improvements

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Cattle Management](cattle.md) - Cattle-specific husbandry
