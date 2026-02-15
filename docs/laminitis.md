# Laminitis

Laminitis is a painful inflammation of the laminae (tissues connecting the hoof wall to the coffin bone) in horses, often triggered by rich feed, obesity, stress, or metabolic issues. It can cause permanent lameness and structural damage to the hooves if not managed properly.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Horses only |
| Transmission Rate | None (not contagious) |
| Immunity Period | 6 months |
| Recovery Time | None (does not naturally recover) |
| Sale Value Impact | 40% reduction (0.6 multiplier) |

## Infection Risk

### Base Probability

Laminitis becomes more likely as horses age and mature:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-11 | 0% (too young) |
| 12-35 | 0.1% per month |
| 36+ | 0.2% per month |

!!! info "Age-Related Increase"
    Older horses (36+ months) have double the risk of laminitis compared to young adults, likely due to cumulative metabolic stress and weight management challenges.

### Modifying Factors

The actual chance of laminitis is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.05% actual chance for older horses (75% reduction)
- Health 1.0 (average): 0.2% actual chance for older horses
- Health 0.25 (worst): 0.35% actual chance for older horses (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** An older horse (36+ months) with average health (1.0) at >100% capacity:
- Base: 0.2%
- × Health: 1.0
- × Overcrowding: 2.0
- **= 0.4% monthly chance**

### No Transmission

Laminitis is not contagious - it's an individual metabolic/inflammatory condition:
- Does not spread between horses
- Each horse's risk is independent
- Multiple cases may indicate management problems (diet, obesity, stress)

## Symptoms and Effects

### Production Impact

Laminitis causes pain and reduced movement:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid Manure | 80% | 20% reduction |

!!! info "Reduced Activity"
    The reduction in manure output reflects decreased movement and activity due to painful hooves.

### Fatality

Laminitis is rarely fatal in the short term but becomes increasingly dangerous if chronic:

| Time After Onset | Fatality Rate | Cumulative Deaths |
|------------------|---------------|-------------------|
| Month 0 | 0% | 0% |
| Month 6 | 2% | 2% |
| Month 12 | 5% | ~7% total |

!!! warning "Chronic Structural Damage"
    While not immediately fatal, untreated laminitis causes progressive hoof damage. Severe cases can result in coffin bone rotation or sinking, which may necessitate euthanasia.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Severe hoof pain and lameness
   - 20% manure reduction
   - Cannot spread to other horses
   - Progressive fatality risk (0% → 5% over 12 months)
   - 40% reduction in sale value
   - **No natural recovery - treatment required**

2. **Being Treated**
   - $400 cost per month for 2 months
   - Production penalties continue during treatment
   - After 2 months, becomes immune
   - No transmission risk

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot develop laminitis for 6 months
   - No production penalties
   - No sale value penalty

### No Natural Recovery

Unlike many diseases, laminitis does NOT naturally recover:
- Horses remain lame indefinitely without treatment
- Progressive hoof damage continues
- Increasing fatality risk over time
- **Treatment is the only cure**

!!! danger "Treatment is Mandatory"
    Laminitis NEVER naturally recovers. Untreated horses suffer chronic pain, progressive hoof damage, and eventual death. Treatment is not optional.

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $400 per month |
| Duration | 2 months |
| Total Cost | $800 |
| Immunity Granted | 6 months |

### Treatment Process

1. Select the affected horse in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $400 monthly treatment cost (MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Horse recovers and gains 6 months of immunity
6. Normal movement returns

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Total Loss |
|----------|------|------------------|------------|
| Immediate treatment | $800 | 2 months | $800 + 2 months reduced activity |
| Delay treatment | $800 | Delayed | $800 + extended pain + hoof damage |
| No treatment | $0 | Never | Permanent lameness + death (7% over 12 months) |

!!! tip "Treatment Recommendation"
    Always treat laminitis immediately. The $800 cost is essential:
    - Only way to cure the condition
    - Prevents permanent hoof damage
    - Reduces suffering
    - Prevents progressive deterioration and death

## Prevention

### Best Practices

**Dietary Management (Critical)**
- **Controlled grazing** - Limit access to lush, rich pastures
- **Avoid spring grass** - Highest sugar content, highest risk
- **Balanced diet** - Low sugar, low starch feeds
- **No grain overload** - Sudden grain access is dangerous
- **Slow feed transitions** - Gradual changes over 7-10 days
- **Soaked hay** - Reduces sugar content for at-risk horses

**Weight Management**
- **Maintain healthy weight** - Obesity is a major risk factor
- **Regular exercise** - Helps maintain fitness and weight
- **Body condition scoring** - Monitor and adjust feed accordingly
- **Reduce portions** - For overweight horses

**Hoof Care**
- **Regular trimming** - Maintain proper hoof angles and balance
- **Proper shoeing** - Supportive shoeing for at-risk horses
- **Good footing** - Avoid hard, uneven surfaces
- **Farrier collaboration** - Work with farrier on prevention

**Stress Reduction**
- **Minimize transport** - Transport is stressful
- **Stable routine** - Consistent daily schedule
- **Avoid sudden changes** - Diet, environment, workload
- **Appropriate workload** - Don't overwork

**Health Management**
- **Breed for health** - High health genetics reduce risk by up to 75%
- **Monitor older horses** - 36+ months have 2x risk
- **Manage metabolic conditions** - Some horses are predisposed
- **Avoid overcrowding** - Keep below 80% capacity

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Rich spring pasture | Very high | Restrict grazing in spring |
| Obesity | Very high | Weight management program |
| Grain overload | Very high | Secure grain storage |
| Older age (36+ months) | +100% (doubles) | Extra monitoring of senior horses |
| Metabolic syndrome | High | Veterinary management |
| Stress events | Medium | Minimize changes and stress |

**Highest Risk Scenario:**
Older, overweight horse with poor health genetics on rich spring grass = **extremely high risk**

## Economic Impact

### Direct Costs

| Cost Component | Amount | Notes |
|----------------|--------|-------|
| Treatment (2 months) | $800 | Required - no natural recovery |
| Lost activity/work | Minor | Horses not primarily for production |
| Sale value reduction | 40% | While sick |
| Death loss | 7% over 12 months if untreated | Complete loss |

### Calculation Examples

**Single horse with laminitis (treated immediately):**
- Treatment: $800
- Activity loss: 2 months (minimal economic impact)
- Death risk: ~2% (reduced from 7%)
- If dies: ~$3,000 total loss (avg horse value)
- If survives: ~$800 total cost
- **Expected cost: (0.98 × $800) + (0.02 × $3,000) = $844**

**Single horse with laminitis (untreated for 12 months):**
- Treatment: $0
- Chronic lameness: 12 months of pain
- Permanent hoof damage: Likely
- Death risk: ~7%
- If dies: ~$3,000 total loss
- If survives: Chronic lameness, reduced value
- **Expected cost: (0.93 × $1,500 reduced value) + (0.07 × $3,000) = $1,605**

**Prevention example (older horse, spring):**
- Restrict grazing on lush pasture: $0 cost
- Reduces risk from 0.4% to <0.1%
- **Prevention is free and highly effective**

### Indirect Costs

- **Permanent hoof damage** - Chronic cases may never fully recover
- **Reduced performance** - Working/riding horses lose value
- **Ongoing management** - Some horses prone to recurrence
- **Emergency vet calls** - Severe cases need immediate attention
- **Loss of use** - Cannot ride/work during treatment
- **Chronic pain** - Welfare and ethical concerns

## Management Strategy

!!! tip "Laminitis Prevention and Control Protocol"
    **1. Prevention First (Critical)**
    - Restrict grazing on rich pasture (especially spring)
    - Maintain healthy body weight (body condition score 4-6/9)
    - Gradual diet changes only (7-10 days minimum)
    - Secure grain storage (no accidental overload)
    - Regular hoof care (trimming every 6-8 weeks)

    **2. High-Risk Identification**
    - Older horses (36+ months) have 2x risk
    - Overweight horses at very high risk
    - Poor health genetics increase risk 75%
    - Spring months are highest risk (rich grass)
    - History of laminitis = high recurrence risk

    **3. Weight Management**
    - Body condition score all horses regularly
    - Reduce feed for overweight horses
    - Increase exercise appropriately
    - Use grazing muzzles if needed on pasture
    - Weigh regularly to track progress

    **4. Spring Grass Management**
    - Highest risk period for laminitis
    - Restrict grazing to 1-2 hours daily
    - Graze in morning (lower sugar) not afternoon
    - Use dry lots or sacrifice paddocks
    - Provide hay instead of pasture

    **5. Early Detection**
    - Watch for signs: reluctance to move, shifting weight, lying down more
    - Check for heat in hooves
    - Notice shortened stride or stiffness
    - Positive hoof tester response
    - Early treatment prevents permanent damage

    **6. Immediate Treatment (Mandatory)**
    - Laminitis NEVER naturally recovers
    - Treat at first signs
    - $800 treatment prevents permanent damage
    - Untreated = chronic lameness + death risk
    - Every day untreated causes more hoof damage

    **7. Post-Recovery Management**
    - Horse is immune for 6 months after recovery
    - Continue strict dietary management
    - Regular hoof care essential
    - Monitor for recurrence (some horses prone)
    - Address underlying causes (weight, diet, metabolism)

    **8. Long-Term Prevention**
    - Breed for high health genetics
    - Maintain appropriate body weight for life
    - Avoid rich pastures year-round
    - Regular farrier care
    - Appropriate exercise program
    - Monitor and manage metabolic conditions

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Horse Management](horses.md) - Horse-specific husbandry
