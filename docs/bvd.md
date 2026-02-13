# Bovine Viral Diarrhea (BVD)

Bovine Viral Diarrhea is a highly contagious viral disease that causes severe diarrhea, respiratory problems, and reproductive failures in cattle. BVD is one of the most economically significant diseases in cattle operations due to its impact on fertility, weight gain, and milk production.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle only |
| Transmission Rate | 6% per month |
| Immunity Period | 24 months |
| Recovery Time | 4 months (natural) |
| Sale Value Impact | 45% reduction (0.55 multiplier) |
| Weight Gain Impact | 40% reduction (0.6 multiplier) |
| Fertility Impact | 70% reduction (0.3 multiplier) |

## Infection Risk

### Base Probability

BVD can affect cattle at any age with consistent probability:

| Age (months) | Base Probability |
|--------------|------------------|
| 0+ | 0.1% per month |

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.025% actual chance (75% reduction)
- Health 1.0 (average): 0.1% actual chance
- Health 0.25 (worst): 0.175% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

### Transmission

BVD spreads readily between cattle through bodily fluids and contaminated surfaces:

- **Base transmission rate**: 6% per month
- **Transmission chance**: `0.06 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of cattle are immune, transmission is reduced by 90%

!!! warning "Multi-Route Transmission"
    BVD spreads through saliva, nasal secretions, urine, feces, semen, and milk, making biosecurity critical.

## Symptoms and Effects

### Production Impact

BVD causes severe production losses across multiple outputs:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Milk | 50% | 50% reduction in dairy production |
| Liquid Manure | 300% | 3x increase (severe diarrhea) |
| Solid Manure | 30% | 70% reduction |

!!! danger "Severe Diarrhea"
    The 3x increase in liquid manure represents the severe, profuse diarrhea that is the hallmark symptom of BVD.

### Weight and Reproduction

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 60% | 40% slower growth |
| Fertility | 30% | 70% reduction in breeding success |

!!! danger "Reproductive Catastrophe"
    BVD's 70% fertility reduction makes breeding nearly impossible. Infected pregnant animals often abort or produce weak calves.

### Fatality

BVD carries moderate but sustained mortality risk:

| Time After Infection | Fatality Rate | Cumulative Deaths |
|----------------------|---------------|-------------------|
| Month 0 | 5% | 5% |
| Month 6+ | 3% | ~8% total |

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Severe diarrhea (3x liquid manure)
   - 50% milk production loss
   - 40% weight gain reduction
   - 70% fertility reduction
   - Can spread to other cattle (6% transmission)
   - Fatality risk (5-3%)
   - 45% reduction in sale value

2. **Being Treated**
   - $350 cost per month for 2 months
   - Production penalties continue during treatment
   - After 2 months, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 24 months (2 years)
   - No production penalties
   - No sale value penalty

### Natural Recovery

Animals can recover naturally without treatment:
- After 4 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 24-month immunity
- Saves $700 total treatment cost
- Extended production loss and death risk during untreated period

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $350 per month |
| Duration | 2 months |
| Total Cost | $700 |
| Immunity Granted | 24 months |

### Treatment Process

1. Select the infected animal in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $350 monthly treatment cost (MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Animal recovers and gains 24 months of immunity
6. Production gradually returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Total Loss |
|----------|------|------------------|------------|
| Immediate treatment | $700 | 2 months | $700 + 2 months production loss |
| Wait for natural recovery | $0 | 4-8 months average | 4-8 months severe production loss |

!!! tip "Treatment Recommendation"
    Always treat BVD immediately. The $700 cost is minimal compared to:
    - Lost milk production (50% for 4-8 months)
    - Failed breeding (70% fertility reduction)
    - Weight loss in growing cattle (40% reduction)
    - Risk of spread to entire herd

## Prevention

### Best Practices

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity to reduce disease risk
- **Biosecurity** - BVD spreads through all bodily fluids
  - Isolate new animals for 30 days
  - Separate sick animals immediately
  - Clean and disinfect equipment between animals
- **Build herd immunity** - Recovered animals provide herd protection (24 months)

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce BVD risk by up to 75%
- **Track disease history** - Identify animals prone to viral infections
- **Avoid breeding infected animals** - 70% fertility reduction makes it impractical

**Reproductive Management**
- **Screen breeding stock** - BVD can spread through semen
- **Delay breeding** - Don't breed animals with BVD (70% fertility reduction)
- **Monitor pregnant cattle** - BVD causes abortions and weak calves

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Poor biosecurity | Increases transmission | Isolation protocols |
| Breeding infected animals | Reproductive failure | Screen and delay breeding |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Duration |
|----------------|--------|----------|
| Treatment (2 months) | $700 | If treated |
| Lost milk production | 50% for duration | Dairy cattle |
| Reduced weight gain | 40% for duration | Growth cattle |
| Sale value reduction | 45% | While sick |
| Fertility loss | 70% reduction | Breeding stock |

### Calculation Examples

**Dairy cow with BVD (treated immediately):**
- Treatment: $700
- Milk loss: 2 months × 50% × $100/month = $100
- **Total cost: ~$800**

**Dairy cow with BVD (natural recovery, 6 months):**
- Treatment: $0
- Milk loss: 6 months × 50% × $100/month = $300
- **Total cost: ~$300 in lost revenue**

**Breeding cow with BVD:**
- Treatment: $700
- Failed breeding cycles: 2-4 months of 70% reduced fertility
- Delayed income from calves: 6-12 months
- **Total cost: $700 + lost calf value + delayed production**

**Herd outbreak (20 cows, 5 infected):**
- If untreated: High transmission (6% × 5/20 = 1.5% base, modified by factors)
- Potential spread to 10+ more cows
- Treatment cost: 5 cows × $700 = $3,500
- If spreads to 15 cows = $10,500+
- **Early treatment prevents cascade**

### Indirect Costs

- Management time for treating and monitoring sick animals
- Cleanup costs (3x liquid manure from severe diarrhea)
- Lost breeding opportunities (70% fertility reduction)
- Delayed income from failed reproduction
- Stress on farm cash flow during outbreaks
- Biosecurity measures to prevent spread

## Management Strategy

!!! tip "BVD Prevention and Control Protocol"
    **1. Prevention First**
    - Maintain <80% capacity
    - Breed for high health genetics
    - Strong biosecurity protocols
    - Isolate new animals for 30 days

    **2. Early Detection**
    - Monitor for severe diarrhea (hallmark symptom)
    - Watch for respiratory signs
    - Check breeding success rates
    - Regular health screenings

    **3. Immediate Isolation**
    - Separate infected animals immediately
    - BVD spreads through all bodily fluids
    - Clean and disinfect equipment
    - Minimize contact between groups

    **4. Immediate Treatment**
    - Treat at first signs
    - $700 treatment >>> lost production value
    - Faster recovery = less reproductive damage
    - Prevents spread to herd

    **5. Herd Immunity**
    - Recovered animals are immune for 24 months (2 years)
    - When >70% immune, outbreaks stop (90% transmission reduction)
    - Strategic treatment protects entire herd long-term

    **6. Breeding Management**
    - Do NOT breed infected animals (70% fertility reduction)
    - Wait for full recovery and immunity
    - Screen all breeding stock for BVD
    - Monitor pregnant animals closely

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Cattle Management](cattle.md) - Cattle-specific husbandry
