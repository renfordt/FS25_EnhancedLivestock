# PRRS (Porcine Reproductive and Respiratory Syndrome)

PRRS is one of the most economically damaging swine diseases globally, causing reproductive failure in sows and severe pneumonia in piglets. It's highly contagious and can devastate unprepared operations.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Pigs only |
| Transmission Rate | 10% per month |
| Immunity Period | 12 months |
| Recovery Time | 4 months (natural) |
| Sale Value Impact | 50% reduction (0.50 multiplier) |
| Weight Gain Impact | 20% reduction (0.80 multiplier) |
| Fertility Impact | 60% reduction (0.40 multiplier) |

## Infection Risk

### Base Probability

PRRS can affect pigs at any age:

| Age (months) | Base Probability |
|--------------|------------------|
| All ages | 0.1% per month |

### Modifying Factors

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

PRRS spreads readily through pig populations:

- **Base transmission rate**: 10% per month
- **Transmission chance**: `0.10 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of pigs are immune, transmission is reduced by 90%

!!! danger "Airborne Spread"
    PRRS can spread through the air between farms up to several kilometers. Biosecurity is critical.

## Symptoms and Effects

### Production Impact

PRRS severely affects reproductive and respiratory systems:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid Manure | 70% | 30% reduction |
| Liquid Manure | 150% | 50% increase due to diarrhea |

### Weight and Reproduction

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 80% | 20% slower growth |
| Fertility | 40% | 60% reduction - severe reproductive impact |

!!! danger "Reproductive Catastrophe"
    PRRS causes abortions, stillbirths, and weak piglets. Fertility reduced to 40% means breeding programs collapse.

### Fatality

PRRS carries significant mortality risk, especially early:

| Time After Infection | Fatality Rate | Cumulative Deaths |
|----------------------|---------------|-------------------|
| Month 0 | 15% | 15% |
| Month 3 | 5% | ~20% total |

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Severe fertility reduction (40%)
   - Reduced weight gain (80%)
   - Increased liquid manure (diarrhea)
   - Can spread rapidly to other pigs
   - 15% initial fatality risk
   - 50% reduction in sale value

2. **Being Treated**
   - $250 cost per month for 2 months
   - Production penalties continue during treatment
   - After 2 months, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 12 months
   - No production penalties
   - Contributes to herd immunity

### Natural Recovery

Animals can recover naturally without treatment:
- After 4 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 12-month immunity
- Saves $500 total treatment cost
- Higher death risk (20% vs ~12% if treated)
- Longer reproductive losses

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $250 per month |
| Duration | 2 months |
| Total Cost | $500 |
| Immunity Granted | 12 months |

### Treatment Process

1. Select the infected pig in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $250 monthly treatment cost (MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Pig recovers and gains 12 months of immunity
6. Production gradually returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Fatality Risk | Fertility Loss |
|----------|------|------------------|---------------|----------------|
| Immediate treatment | $500 | 2 months | ~12% | 2 months |
| Wait for natural recovery | $0 | 4-7 months | ~20% | 4-7 months |

!!! tip "Treatment Recommendation"
    Always treat PRRS immediately:
    - Reduced death risk (20% → 12%)
    - Faster recovery saves breeding cycles
    - Shorter period of reduced weight gain
    - Less time spreading disease to others

## Prevention

### Best Practices

**Biosecurity (Critical)**
- **Closed herd** - Limit/eliminate new pig introductions
- **Quarantine** - Isolate new arrivals for 30+ days with testing
- **Visitor control** - Shower-in/shower-out facilities
- **Vehicle protocols** - Disinfection before entering farm
- **Distance from other farms** - PRRS spreads airborne

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity
- **All-in/all-out** - Prevent mixing of age groups
- **Good ventilation** - Filtered air systems in endemic areas
- **Build herd immunity** - Strategic treatment creates protective barrier

**Genetic Selection**
- **Breed for health** - High health genetics dramatically reduce PRRS risk
- **Track disease history** - Identify and cull susceptible animals
- **Maintain genetic diversity** - Resistance varies by line

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Open herd with new pigs | Extreme | Closed herd policy or strict quarantine |
| Poor biosecurity | Extreme | Shower facilities, vehicle protocols |
| Low health genetics | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand capacity or reduce herd |
| Mixed age groups | High | All-in/all-out management |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Notes |
|----------------|--------|-------|
| Treatment (2 months) | $500 | If treated |
| Fertility loss | Severe | 60% reduction - breeding collapse |
| Weight gain loss | 20% for duration | Growth pigs |
| Sale value reduction | 50% | While sick |
| Death loss | 12-20% of pig value | Depends on treatment |

### Calculation Examples

**Breeding sow with PRRS (treated immediately):**
- Treatment: $500
- Lost breeding cycles: 2 months = ~1-2 litters lost
- **Total cost: $500 + $2,000-4,000 in lost piglets = $2,500-4,500**

**Growing pig with PRRS (treated immediately):**
- Treatment: $500
- Weight gain loss: 2 months × 20% × potential gain
- **If dies (12% chance): ~$800+ total loss**

**Herd outbreak (50 pigs, 10 infected):**
- If untreated: High transmission (10% × 10/50 = 2% base, modified by overcrowding/health)
- Potential spread to 20-30 more pigs
- Treatment cost: 10 pigs × $500 = $5,000
- If spreads to 30 pigs = $15,000+ treatment costs alone
- Breeding program collapse if sows affected
- **Early treatment prevents cascade**

### Indirect Costs

- **Breeding program collapse** - Takes months to recover
- **Weak piglets** - Even recovered sows may have poor litters
- **Secondary infections** - PRRS immunosuppression allows other diseases
- **Farm reputation** - PRRS-positive status affects sales and genetics programs
- **Long-term production losses** - Can take 6-12 months to fully recover herd

## Management Strategy

!!! tip "PRRS Prevention and Control Protocol"
    **1. Absolute Biosecurity (Non-Negotiable)**
    - Closed herd or ultra-strict quarantine (30+ days)
    - Shower-in/shower-out for all personnel
    - No shared equipment between farms
    - Vehicle disinfection mandatory
    - Test all incoming animals

    **2. Facility Design**
    - Air filtration in endemic areas
    - Distance from neighboring farms (>1km if possible)
    - All-in/all-out pig flow
    - Separate breeding and growing areas

    **3. Early Detection**
    - Monitor sows for reproductive failure
    - Watch for respiratory distress in piglets
    - Temperature screening
    - Immediate testing of suspect cases

    **4. Immediate Response**
    - Treat infected animals immediately ($500 << reproductive losses)
    - Isolate affected animals
    - Increase biosecurity measures
    - Consider depopulation in severe outbreaks

    **5. Herd Immunity Strategy**
    - Build immunity through strategic treatment
    - When >70% immune, outbreaks stop (90% transmission reduction)
    - Maintain immunity levels through controlled exposure or treatment

    **6. Breeding Program Adaptation**
    - Breed for PRRS resistance (high health genetics)
    - Maintain extra replacement stock during outbreaks
    - Expect 3-6 month recovery period for breeding program
    - Consider genetic testing for PRRS resistance

    **7. Economic Planning**
    - Budget for outbreaks (endemic disease in many regions)
    - Insurance considerations
    - Emergency treatment fund
    - Backup breeding stock plan

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics and resistance
- [Pig Management](pigs.md) - Pig-specific husbandry
- [Breeding Guide](breeding.md) - Managing breeding during disease outbreaks
