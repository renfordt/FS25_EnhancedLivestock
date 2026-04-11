# Bovine Respiratory Disease (BRD)

Bovine Respiratory Disease, often called "shipping fever," is the most costly disease in beef cattle. It's caused by a combination of stress, viruses, and bacteria leading to pneumonia. BRD is particularly common in young cattle and during cold weather months.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle only |
| Transmission Rate | 8% per month |
| Immunity Period | 12 months |
| Recovery Time | 3 months (natural) |
| Sale Value Impact | 40% reduction (0.60 multiplier) |
| Weight Gain Impact | 20% reduction (0.80 multiplier) |
| Seasonal Pattern | Winter 1.5x, Summer 0.5x |

## Infection Risk

### Base Probability

BRD is most common in young cattle and decreases with age:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-11 | 0.3% per month |
| 12-23 | 0.1% per month |
| 24+ | 0.05% per month |

!!! info "Young Animal Risk"
    Calves have **6x higher risk** than mature cattle (0.3% vs 0.05%), making them particularly vulnerable.

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.075% actual chance for calves (75% reduction)
- Health 1.0 (average): 0.3% actual chance for calves
- Health 0.25 (worst): 0.525% actual chance for calves (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Seasonal Modifier**
- **Winter** (Dec-Feb): 1.5x probability (cold stress increases risk)
- **Spring** (Mar-May): 1.0x probability
- **Summer** (Jun-Aug): 0.5x probability (lowest risk)
- **Autumn** (Sep-Nov): 1.0x probability

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A calf (0-11 months) with poor health genetics (0.25) in winter at >100% capacity:
- Base: 0.3%
- × Health: 1.75
- × Season: 1.5
- × Overcrowding: 2.0
- **= 1.575% monthly chance** (very high!)

### Transmission

BRD spreads readily between cattle in close quarters:

- **Base transmission rate**: 8% per month
- **Transmission chance**: `0.08 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of cattle are immune, transmission is reduced by 90%

!!! warning "Respiratory Transmission"
    BRD spreads through airborne droplets, making proper ventilation critical for prevention.

## Symptoms and Effects

### Production Impact

BRD significantly reduces productivity:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Milk | 70% | 30% reduction in dairy cows |
| Solid Manure | 80% | 20% reduction |

### Weight and Growth

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 80% | 20% slower growth, chronic impact on growth cattle |

!!! danger "Long-term Growth Impact"
    Even after recovery, BRD can cause permanent lung damage that reduces lifetime growth potential and feed efficiency.

### Fatality

BRD carries moderate but significant mortality risk:

| Time After Infection | Fatality Rate | Cumulative Deaths |
|----------------------|---------------|-------------------|
| Month 0 | 10% | 10% |
| Month 2 | 5% | ~15% total |
| Month 6+ | 1% | ~16% total |

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Reduced milk production (70%)
   - Slower weight gain (80%)
   - Can spread to other cattle
   - Fatality risk (10% initially, decreasing)
   - 40% reduction in sale value

2. **Being Treated**
   - $300 cost per month for 2 months
   - Production penalties continue during treatment
   - After 2 months, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 12 months
   - No production penalties
   - No sale value penalty

### Natural Recovery

Animals can recover naturally without treatment:
- After 3 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 12-month immunity
- Saves $600 total treatment cost
- Higher death risk during untreated period (16% vs ~8% if treated)

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $300 per month |
| Duration | 2 months |
| Total Cost | $600 |
| Immunity Granted | 12 months |

### Treatment Process

1. Select the infected animal in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $300 monthly treatment cost (MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Animal recovers and gains 12 months of immunity
6. Production gradually returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Fatality Risk | Total Cost |
|----------|------|------------------|---------------|------------|
| Immediate treatment | $600 | 2 months | ~8% | $600 + production loss |
| Wait for natural recovery | $0 | 3-6 months | ~16% | 0-6 months production loss + death risk |

!!! tip "Treatment Recommendation"
    Always treat BRD immediately. The $600 cost is justified by:
    - Reduced death risk (16% → 8%)
    - Faster recovery (2 months vs 3-6 months average)
    - Less permanent lung damage
    - Reduced transmission to other animals

## Prevention

### Best Practices

**Husbandry Management**
- **Avoid overcrowding** - Keep well below 80% capacity, especially in winter
- **Excellent ventilation** - Fresh air reduces pathogen load without drafts
- **Minimize stress** - Stress weakens immune systems:
  - Gradual weaning
  - Minimize handling and transport
  - Consistent feeding schedules
- **Build herd immunity** - Recovered animals protect the herd

**Seasonal Management**
- **Winter preparation** - Ensure ventilation before cold season (1.5x risk)
- **Summer advantage** - Utilize lower summer risk (0.5x) for new animal integration
- **Monitor weather** - Watch for cold snaps that increase stress

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce BRD risk by up to 75%
- **Track disease history** - Identify and cull animals prone to respiratory issues
- **Select resistant lines** - Some bloodlines show better respiratory health

**Young Stock Management**
- **Extra vigilance for calves** - They have 6x higher base risk
- **Quality colostrum** - Good passive immunity protects young calves
- **Gradual transitions** - Slow diet changes reduce stress
- **Separate young/old** - Consider age-based grouping

### Risk Factors

| Factor | Risk Multiplier | Mitigation |
|--------|-----------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Winter season | +50% | Improve ventilation, reduce stress |
| Young age (0-11 months) | +500% (6x base) | Extra monitoring and care |
| Combined factors | Multiplicative | Address all factors simultaneously |

**Worst Case Scenario:**
Young calf + poor health + winter + overcrowding = **1.575% monthly risk**
= ~17% annual infection probability per animal

## Economic Impact

### Direct Costs

| Cost Component | Amount | Notes |
|----------------|--------|-------|
| Treatment (2 months) | $600 | If treated |
| Lost milk production | 30% for duration | Dairy cattle |
| Reduced weight gain | 20% for duration | Growth cattle |
| Sale value reduction | 40% | While sick |
| Death loss | 8-16% of cattle value | Depends on treatment |

### Calculation Examples

**Dairy cow with BRD (treated immediately):**
- Treatment: $600
- Milk loss: 2 months × 30% × $100/month = $60
- **Total cost: ~$660**

**Growing steer with BRD (treated immediately):**
- Treatment: $600
- Weight gain loss: 2 months × 20% × potential gain = variable
- **If dies (8% chance): ~$1,000+ total loss**

**Calf herd outbreak (20 calves, 5 infected):**
- If untreated: High transmission (8% × 5/20 = 2% base, modified)
- Potential spread to 5-10 more calves
- Treatment cost: 5 calves × $600 = $3,000
- If spreads to 10 calves = $6,000+
- **Early treatment prevents cascade**

### Indirect Costs

- **Chronic lung damage** - Permanent reduction in growth efficiency
- **Management time** - Monitoring and treating sick animals
- **Reduced breeding value** - Damaged cattle less desirable
- **Cascade effects** - Untreated animals spread disease

## Management Strategy

!!! tip "BRD Prevention and Control Protocol"
    **1. Prevention (Most Important)**
    - Maintain <80% capacity year-round
    - <70% capacity in winter months
    - Excellent ventilation without drafts
    - Breed for high health genetics
    - Minimize stress on young stock

    **2. Seasonal Awareness**
    - Prepare ventilation before winter
    - Integrate new animals in summer (0.5x risk)
    - Monitor weather forecasts
    - Increase monitoring during cold snaps

    **3. Early Detection**
    - Check calves daily (highest risk group)
    - Watch for: coughing, nasal discharge, rapid breathing, fever
    - Isolate suspected cases immediately

    **4. Immediate Treatment**
    - Treat at first signs
    - $600 treatment >>> $1,000+ death loss
    - Faster recovery = less lung damage

    **5. Herd Immunity**
    - Recovered animals are immune for 12 months
    - When >70% immune, outbreaks stop (90% transmission reduction)
    - Strategic treatment can protect entire herd

    **6. Young Stock Protocol**
    - Separate calves from adults if possible
    - Extra bedding for warmth
    - Monitor 2x daily in winter
    - Ensure good nutrition for immune support

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Cattle Management](cattle.md) - Cattle-specific husbandry
