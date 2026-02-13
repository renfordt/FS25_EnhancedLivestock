# Equine Asthma

Equine Asthma is a chronic allergic respiratory condition triggered by dust and mold in hay or bedding. It causes coughing, difficulty breathing, and exercise intolerance. The condition is more common in winter months when horses spend more time indoors.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Horses only |
| Transmission Rate | None (not contagious) |
| Immunity Period | 6 months |
| Recovery Time | None (chronic condition) |
| Sale Value Impact | 30% reduction (0.7 multiplier) |
| Seasonal Modifiers | Spring 1.0x, Summer 0.5x, Autumn 1.0x, Winter 1.5x |

## Infection Risk

### Base Probability

Equine Asthma tends to develop in mature horses:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-23 | 0% |
| 24+ | 0.1% per month |

### Modifying Factors

The actual infection chance is modified by:

**Health Genetics Modifier**
- Health 1.75 (best): 0.025% actual chance (75% reduction)
- Health 1.0 (average): 0.1% actual chance
- Health 0.25 (worst): 0.175% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Seasonal Modifiers**
- **Spring**: 1.0x (normal risk)
- **Summer**: 0.5x (50% reduction - horses outside more)
- **Autumn**: 1.0x (normal risk)
- **Winter**: 1.5x (50% increase - indoor housing, poor ventilation)

!!! note "Winter Peak"
    Equine asthma is 50% more common in winter when horses spend more time in poorly ventilated stables with dusty bedding and hay.

### Combined Risk Example

**Adult horse (24+ months) in winter with average health:**
- Base probability: 0.1%
- Health modifier (1.0): ×1.0
- Seasonal modifier (winter): ×1.5
- **Final chance: 0.15% per month**

**Adult horse in summer with good ventilation:**
- Base probability: 0.1%
- Health modifier (1.5): ×0.5
- Seasonal modifier (summer): ×0.5
- Overcrowding (<50%): ×0.8
- **Final chance: 0.02% per month**

## Transmission

Equine Asthma is not contagious. It develops individually based on environmental factors and genetic predisposition.

## Symptoms and Effects

### Production Impact

Reduced respiratory function slightly decreases activity:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid manure | 85% | 15% reduction |

### Weight and Fertility

Equine Asthma does not affect weight gain or fertility in the game mechanics.

### Fatality

Equine Asthma is not fatal:

| Time | Fatality Rate |
|------|---------------|
| All stages | 0% |

!!! note "Chronic Condition"
    While not fatal, equine asthma is a chronic condition that requires ongoing management. Horses remain susceptible to recurrence after immunity expires.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Reduced manure production (15% decrease)
   - 30% reduction in sale value
   - Chronic coughing and respiratory distress
   - Exercise intolerance
   - Cannot recover naturally

2. **Being Treated**
   - $200 cost per month
   - Reduced production continues during treatment
   - After 2 months, becomes immune
   - Symptoms gradually improve

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 6 months
   - No production penalties
   - No sale value penalty

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $200 |
| Duration | 2 months |
| Immunity Granted | 6 months |

### Treatment Process

1. Select the affected horse in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $200 treatment cost (charged to MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Horse recovers and gains 6 months of immunity
6. Production resumes normally

### Treatment Approach

Equine asthma treatment typically includes:
- Bronchodilator medications
- Corticosteroids
- Environmental management
- Ongoing monitoring

!!! warning "No Natural Recovery"
    Unlike some diseases, equine asthma does not recover naturally without treatment. Affected horses must be treated to recover.

## Prevention

### Best Practices

**Environmental Management**
- **Excellent ventilation** - Ensure proper airflow in stables
- **Low-dust bedding** - Use dust-free alternatives like shavings or paper
- **Soaked hay** - Reduces airborne dust and mold spores
- **Outdoor turnout** - Maximize time in fresh air, especially summer
- **Regular cleaning** - Minimize dust accumulation in stables

**Seasonal Adjustments**
- **Winter housing** - Pay extra attention to ventilation
- **Summer turnout** - Take advantage of lower risk period
- **Monitor weather** - Keep horses out when possible
- **Hay quality** - Use clean, dust-free hay especially in winter

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce risk by up to 75%
- **Track susceptibility** - Some horses more prone to respiratory issues
- **Cull chronic cases** - Consider removing horses that repeatedly develop asthma

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity
- **Good hygiene** - Clean stables regularly
- **Proper feed storage** - Prevent mold in hay and bedding
- **Air quality** - Minimize dust in stable environment

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Low health genetics | +75% at 0.25 health | Selective breeding |
| Winter season | +50% | Improve ventilation, turnout when possible |
| Overcrowding (>100%) | +100% (doubles risk) | Expand capacity or reduce herd |
| Dusty bedding | Increases base risk | Use low-dust alternatives |
| Poor ventilation | Increases base risk | Improve stable airflow |
| Older age (24+ months) | 0.1% base vs 0% young | Regular monitoring |

## Economic Impact

### Direct Costs

| Cost Type | Amount | Duration |
|-----------|--------|----------|
| Treatment | $200 | One-time (per treatment) |
| Sale value reduction | 30% | While sick |
| Lost production | ~15% manure | 2+ months |

### Calculation Example

**Single horse with equine asthma:**
- Treatment cost: $200
- Duration: 2 months treatment
- Sale value loss (if sold): 30% of horse value (~$300-600)
- **Total cost if treated: ~$200-250**

**Horse untreated (chronic condition):**
- No treatment cost: $0
- Permanent 30% sale value reduction
- Ongoing 15% production loss
- Cannot recover
- **Total cost: $300-600+ in lost value**

!!! tip "Treatment Recommendation"
    Always treat equine asthma. The $200 treatment cost is far less than the permanent 30% value reduction and chronic symptoms.

### Indirect Costs

- Reduced exercise tolerance
- Ongoing environmental management requirements
- Potential for recurrence after immunity expires (6 months)
- Management time monitoring respiratory health
- Environmental improvements (ventilation, bedding upgrades)

## Management Strategy

!!! tip "Equine Asthma Management Protocol"
    1. **Prevention First**
       - Excellent stable ventilation year-round
       - Low-dust bedding and soaked hay
       - Maximize outdoor turnout, especially summer
       - Maintain <80% capacity

    2. **Seasonal Awareness**
       - Extra vigilance in winter (1.5x risk)
       - Take advantage of summer's lower risk (0.5x)
       - Monitor horses spending more time indoors
       - Improve ventilation before winter

    3. **Early Treatment**
       - Treat affected horses immediately
       - $200 treatment prevents chronic condition
       - 2-month treatment duration
       - 6-month immunity after recovery

    4. **Environmental Control**
       - Improve ventilation continuously
       - Use dust-free bedding
       - Soak hay to reduce airborne particles
       - Regular stable cleaning

    5. **Long-term Prevention**
       - Select breeding stock with high health genetics
       - Track respiratory issues in family lines
       - Consider culling chronic cases
       - Maintain optimal capacity ratios

## Real-World Context

!!! note "Common Condition"
    Equine asthma (formerly called "heaves" or COPD) is one of the most common respiratory diseases in horses. It's a chronic allergic condition similar to human asthma, triggered by dust, mold, and poor air quality. Environmental management is the key to prevention and control.

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Horse Management](horses.md) - Horse-specific husbandry
