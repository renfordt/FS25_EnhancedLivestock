# Colic

Colic is a general term for abdominal pain in horses, ranging from mild gas discomfort to life-threatening intestinal twisting or blockage. It is the leading cause of premature death in horses and requires immediate veterinary attention in severe cases.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Horses only |
| Transmission Rate | None (not contagious) |
| Immunity Period | 6 months |
| Recovery Time | 2 months (natural) |
| Sale Value Impact | 50% reduction (0.5 multiplier) |

## Infection Risk

### Base Probability

Colic can affect horses at any age, with increasing risk as they mature:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-11 | 0.1% per month |
| 12+ | 0.3% per month |

!!! info "Age-Related Risk"
    Mature horses (12+ months) have 3x higher risk of colic than foals, likely due to changes in diet, workload, and digestive patterns.

### Modifying Factors

The actual chance of colic is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.075% actual chance for adults (75% reduction)
- Health 1.0 (average): 0.3% actual chance for adults
- Health 0.25 (worst): 0.525% actual chance for adults (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A mature horse (12+ months) with poor health genetics (0.25) at >100% capacity:
- Base: 0.3%
- × Health: 1.75
- × Overcrowding: 2.0
- **= 1.05% monthly chance** (very high risk)

### No Transmission

Colic is not contagious - it's an individual digestive disorder:
- Does not spread between horses
- Each horse's risk is independent
- Multiple cases may indicate environmental problems (feed quality, water, management)

## Symptoms and Effects

### Production Impact

Colic affects digestive output due to intestinal disruption:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid Manure | 50% | 50% reduction |
| Liquid Manure | 200% | 2x increase (diarrhea) |

!!! info "Digestive Disruption"
    The increased liquid manure and decreased solid manure reflect the intestinal upset causing colic symptoms.

### Fatality

Colic carries significant risk of death, particularly in the early stages:

| Time After Onset | Fatality Rate | Cumulative Deaths |
|------------------|---------------|-------------------|
| Month 0 | 15% | 15% |
| Month 1 | 5% | ~19% total |
| Month 3+ | 1% | ~20% total |

!!! danger "Veterinary Emergency"
    The 15% immediate fatality rate represents severe colic cases (torsion, impaction, rupture) that can be fatal within hours without emergency intervention.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Abdominal pain and distress
   - 50% manure reduction, 2x liquid manure
   - Cannot spread to other horses
   - Fatality risk (15% initially, decreasing)
   - 50% reduction in sale value

2. **Being Treated**
   - $500 cost for 1 month
   - Production penalties continue during treatment
   - After 1 month, becomes immune
   - No transmission risk

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot develop colic for 6 months
   - No production penalties
   - No sale value penalty

### Natural Recovery

Horses can recover naturally without treatment:
- After 2 months with colic, 75% chance of natural recovery each month
- Natural recovery grants the same 6-month immunity
- Saves $500 treatment cost
- Higher death risk during untreated period (~20% vs ~10% if treated)

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $500 |
| Duration | 1 month |
| Total Cost | $500 |
| Immunity Granted | 6 months |

### Treatment Process

1. Select the affected horse in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $500 treatment cost (MEDICINE finance category)
4. Wait 1 month for treatment to complete
5. Horse recovers and gains 6 months of immunity
6. Production returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Fatality Risk | Total Loss |
|----------|------|------------------|---------------|------------|
| Immediate treatment | $500 | 1 month | ~10% | $500 + production loss + death risk |
| Wait for natural recovery | $0 | 2-4 months | ~20% | 0 + extended production loss + higher death risk |

!!! tip "Treatment Recommendation"
    Always treat colic immediately. The $500 cost is justified by:
    - Reduced death risk (20% → 10%)
    - Faster recovery (1 month vs 2-4 months average)
    - Less suffering for the animal
    - Lower total economic loss

## Prevention

### Best Practices

**Feeding Management**
- **Regular feeding schedule** - Feed at consistent times daily
- **Quality feed** - Avoid moldy, dusty, or spoiled hay
- **Gradual diet changes** - Transition feeds over 7-10 days minimum
- **Small, frequent meals** - Better than large infrequent meals
- **Adequate forage** - Ensure plenty of hay/grass

**Water Management**
- **Fresh water always** - Clean water available 24/7
- **Monitor intake** - Horses need 20-50 liters per day
- **Water temperature** - Avoid very cold water in winter
- **Clean water sources** - Prevent contamination

**Exercise and Environment**
- **Regular exercise** - Movement aids digestion
- **Turnout time** - Allow natural movement and grazing
- **Reduce stress** - Minimize changes and disturbances
- **Avoid overcrowding** - Keep below 80% capacity

**Health Management**
- **Dental care** - Regular dental examinations and floating
- **Parasite control** - Regular deworming program
- **Breed for health** - High health genetics reduce colic risk by up to 75%

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Sudden diet change | High | Gradual feed transitions |
| Dehydration | High | Ensure fresh water always available |
| Poor quality feed | High | Quality hay, no mold |
| Stress | Medium | Stable routine, minimize changes |
| Inadequate exercise | Medium | Regular turnout and work |
| Dental problems | Medium | Annual dental care |
| Parasite load | Medium | Regular deworming |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Notes |
|----------------|--------|-------|
| Treatment | $500 | One-time if treated |
| Lost manure production | 50% for duration | Minor economic impact |
| Sale value reduction | 50% | While sick |
| Death loss | 10-20% chance of total loss | $2,000-5,000+ value |

### Calculation Examples

**Single horse with colic (treated immediately):**
- Treatment: $500
- Production loss: Minimal (1 month, manure not significant income)
- Death risk: ~10%
- If dies: ~$3,000 total loss (avg horse value)
- If survives: ~$500 total cost
- **Expected cost: (0.9 × $500) + (0.1 × $3,000) = $750**

**Single horse with colic (natural recovery):**
- Treatment: $0
- Production loss: Minimal (2-4 months)
- Death risk: ~20%
- If dies: ~$3,000 total loss
- If survives: ~$0 treatment cost
- **Expected cost: (0.8 × $0) + (0.2 × $3,000) = $600**

!!! note "Treatment is Worth It"
    Despite the calculation, the $500 treatment is worth it because:
    - Reduces suffering (ethical consideration)
    - Faster recovery means quicker return to work/training
    - Some colic cases are severe and natural recovery isn't realistic
    - Peace of mind during a scary medical emergency

**Herd scenario (10 horses, 2 with colic):**
- Not contagious, so won't spread
- Treat both: 2 × $500 = $1,000
- Death risk: 2 × 10% = ~0.2 horses lost = ~$600 expected loss
- **Total expected cost: $1,000 + $600 = $1,600**

### Indirect Costs

- **Training interruption** - Lost training progress during illness
- **Performance impact** - Reduced performance for weeks after recovery
- **Management time** - Monitoring and care during illness
- **Stress and worry** - Colic is a frightening emergency
- **Recurring episodes** - Some horses prone to repeat colic

## Management Strategy

!!! tip "Colic Prevention and Management Protocol"
    **1. Prevention First**
    - Consistent feeding schedule (same times daily)
    - Quality hay and feed (no mold or dust)
    - Fresh water available 24/7
    - Regular exercise and turnout
    - Gradual feed changes only (7-10 days minimum)

    **2. High-Risk Awareness**
    - Mature horses have 3x risk of foals
    - Poor health genetics increase risk 75%
    - Overcrowding doubles risk
    - Monitor high-risk individuals closely

    **3. Early Detection**
    - Watch for signs: pawing, rolling, looking at flanks, reduced appetite
    - Check manure output daily
    - Notice behavior changes
    - Early detection improves outcomes

    **4. Immediate Treatment**
    - Treat at first signs
    - $500 is small compared to horse value
    - Reduces death risk from 20% to 10%
    - Faster recovery = less suffering

    **5. Post-Recovery Management**
    - Horse is immune for 6 months after recovery
    - Continue good management practices
    - Some horses are colic-prone - identify and manage carefully
    - Address underlying causes (dental, parasites, feed quality)

    **6. Environmental Factors**
    - Ensure adequate space (<80% capacity)
    - Good quality feed and clean water
    - Regular dental care
    - Parasite control program
    - Minimize stress and changes

    **7. Genetic Selection**
    - Breed for high health genetics
    - Reduces colic risk by up to 75%
    - Track which horses get colic repeatedly
    - Consider culling chronically colic-prone animals

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Horse Management](horses.md) - Horse-specific husbandry
