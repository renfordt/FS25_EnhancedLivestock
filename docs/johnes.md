# Johne's Disease

Johne's Disease is a chronic, incurable bacterial infection of the intestines causing progressive weight loss and diarrhea in cattle. The disease has a long incubation period - animals may be infected for years before showing clinical signs, making it particularly difficult to control.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle only |
| Transmission Rate | 3% per month |
| Immunity Period | None (no immunity after infection) |
| Recovery Time | None (incurable) |
| Sale Value Impact | 70% reduction (0.3 multiplier) |
| Weight Gain Impact | 60% reduction (0.4 multiplier) |

!!! danger "No Cure Available"
    Johne's Disease has NO treatment. Infected animals will progressively deteriorate and eventually die. The only management strategy is testing, culling, and prevention.

## Infection Risk

### Base Probability

Johne's Disease primarily affects mature cattle:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-23 | 0% (not yet symptomatic) |
| 24+ | 0.03% per month |

!!! info "Long Incubation Period"
    Cattle are typically infected as calves through contaminated manure, but symptoms don't appear until 2+ years of age. By the time they show signs, they've been spreading the disease for months or years.

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.0075% actual chance (75% reduction)
- Health 1.0 (average): 0.03% actual chance
- Health 0.25 (worst): 0.0525% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

### Transmission

Johne's Disease spreads through contaminated manure, with calves being most susceptible:

- **Base transmission rate**: 3% per month
- **Transmission chance**: `0.03 × (infected_count / total_animals) × health_modifier × overcrowding_modifier`
- **No herd immunity**: Johne's grants no immunity after infection - animals remain infected for life

!!! warning "Fecal-Oral Transmission"
    The bacteria lives in manure and spreads to other cattle through contaminated feed, water, and environment. Young calves are most vulnerable.

## Symptoms and Effects

### Production Impact

Johne's Disease causes severe chronic diarrhea and malabsorption:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Milk | 40% | 60% reduction in dairy production |
| Liquid Manure | 300% | 3x increase (severe chronic diarrhea) |
| Solid Manure | 30% | 70% reduction |

!!! danger "Progressive Wasting"
    The hallmark of Johne's is chronic, untreatable diarrhea leading to progressive weight loss despite normal appetite. Animals literally waste away.

### Weight and Growth

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 40% | 60% slower growth, progressive weight loss |

### Fatality

Johne's Disease is slowly progressive but increasingly fatal over time:

| Time After Symptoms | Fatality Rate | Cumulative Deaths |
|---------------------|---------------|-------------------|
| Month 0 | 0% | 0% |
| Month 6 | 2% | 2% |
| Month 12 | 5% | ~7% total |
| Month 24 | 15% | ~21% total |

!!! warning "Progressive Deterioration"
    While initial fatality is low, the disease becomes increasingly fatal as intestinal damage accumulates. Most infected animals eventually die or must be culled.

## Disease Progression

### Active Disease States

1. **Infected (Subclinical)** - Not modeled in-game
   - Infected for 1-2+ years before showing symptoms
   - Shedding bacteria in manure
   - Spreading to other cattle, especially calves
   - No visible signs

2. **Active (Clinical - Untreated)**
   - Chronic severe diarrhea (3x liquid manure)
   - 60% milk production loss
   - 60% weight gain reduction (progressive weight loss)
   - Can spread to other cattle (3% transmission)
   - Increasing fatality risk (0% → 15% over 24 months)
   - 70% reduction in sale value
   - **Progressive deterioration until death**

!!! danger "No Treatment State"
    There is NO "Being Treated" or "Immune" state for Johne's Disease. Once symptomatic, the animal will never recover.

## Treatment

**NO treatment available for Johne's Disease:**

| Treatment Type | Available |
|----------------|-----------|
| Medicine | No |
| Cure | No |
| Recovery | Never |

**Management Options:**
1. **Immediate culling** - Recommended to stop disease spread
2. **Testing program** - Identify infected animals before symptoms appear
3. **Calf protection** - Prevent exposure of young stock
4. **Herd eradication** - Long-term testing and culling program

!!! tip "Only Solution: Cull Immediately"
    The moment an animal shows Johne's symptoms, cull it immediately. Every day it remains in the herd:
    - Spreads disease to other cattle
    - Loses more weight (reducing cull value)
    - Costs money in feed with no production benefit
    - Increases risk to calves who will become infected for life

## Prevention

### Best Practices

**Calf Management (Critical)**
- **Separate calves immediately** - Remove from dam at birth
- **Clean colostrum** - Ensure colostrum is not from infected cows
- **Clean feeding areas** - No manure contamination
- **Separate young stock** - Keep calves away from adult cattle areas

**Testing and Culling**
- **Regular herd testing** - Annual or bi-annual testing
- **Cull positive animals** - Remove before they show symptoms
- **Test before purchase** - NEVER buy untested cattle
- **Track family lines** - Infected dam = higher risk calves

**Environmental Management**
- **Manure management** - Prevent contamination of feed/water
- **Clean facilities** - Thorough cleaning between groups
- **Avoid overcrowding** - Keep below 80% capacity
- **Separate age groups** - Keep young calves isolated from adults

**Biosecurity**
- **Closed herd** - Minimize new animal introductions
- **Quarantine and test** - Test all purchases before introduction
- **Source verification** - Buy only from tested, negative herds

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Infected animals in herd | Critical - spreads to calves | Test and cull immediately |
| Calf exposure to manure | Critical - lifetime infection | Separate calves, clean colostrum |
| No testing program | Critical - silent spread | Annual herd testing |
| Purchasing untested cattle | High | Test before purchase |
| Poor calf hygiene | High | Clean maternity areas |
| Overcrowding | Increases spread | Maintain <80% capacity |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Notes |
|----------------|--------|-------|
| Lost milk production | 60% reduction | Dairy cattle |
| Lost weight gain | 60% reduction | Progressive weight loss |
| Sale value reduction | 70% | While sick |
| Testing program | Variable | Preventive cost |
| Eventual death loss | 100% of animal value | Most infected animals die |

### Calculation Examples

**Single dairy cow with Johne's:**
- Treatment cost: $0 (no treatment exists)
- Milk loss: Permanent 60% reduction until death
- Example: 12 months × 60% × $100/month = $720 lost
- Cull value: 70% reduction from normal
- **Optimal decision: Cull immediately to minimize losses**

**Delaying culling for 12 months:**
- Milk loss: $720
- Feed cost: ~$600 for minimal return
- Reduced cull value: $1,000 → $300 = $700 loss
- Disease spread to other animals: Potentially $10,000+
- **Total cost: $2,020+ plus spread**

**vs. Immediate culling:**
- Milk loss: Minimal
- Cull value: Still reduced but higher than after deterioration
- Disease spread: Minimized
- **Total cost: ~$500-700 cull value loss**

**Herd outbreak (20 cows, 3 infected):**
- If not culled: Ongoing spread to calves (3% transmission)
- Calves infected now won't show symptoms for 2+ years
- By then, they've infected the next generation
- **Entire herd can become infected over 5-10 years**
- Herd replacement cost: $30,000+
- **Early detection and culling saves the herd**

### Indirect Costs

- **Long-term herd contamination** - Bacteria persist in environment
- **Lost genetic progress** - Must cull infected animals and offspring
- **Testing program costs** - Required for control
- **Management time** - Monitoring and testing
- **Market reputation** - Infected herd damages sale opportunities
- **Replacement costs** - Must purchase or raise replacements

### True Cost of Johne's Disease

| Timeline | Impact |
|----------|--------|
| Year 1 | 1-3 animals show symptoms |
| Year 2-3 | Animals infected 2 years ago show symptoms |
| Year 5-10 | Without control, 30-50% of herd infected |
| Long-term | Herd must be depopulated and facilities decontaminated |

!!! danger "Herd-Ending Disease"
    Without aggressive testing and culling, Johne's Disease can destroy a herd over 5-10 years. Prevention and early detection are critical.

## Management Strategy

!!! tip "Johne's Disease Control Protocol"
    **1. Testing Program (Essential)**
    - Annual testing of all cattle over 24 months
    - Test all purchases before introduction
    - Retest positive animals to confirm
    - Track family lines of positive animals

    **2. Immediate Culling**
    - Cull symptomatic animals immediately
    - Cull test-positive animals promptly
    - Consider culling offspring of infected dams
    - Do NOT delay - every day costs money and spreads disease

    **3. Calf Protection (Critical)**
    - Remove calves from dams immediately at birth
    - Use colostrum only from test-negative cows
    - Keep calves in clean, manure-free areas
    - Separate young stock from adult cattle completely
    - Clean and disinfect calf areas thoroughly

    **4. Environmental Control**
    - Prevent manure contamination of feed and water
    - Clean maternity areas thoroughly between calvings
    - Avoid spreading manure from infected areas to calf areas
    - Consider replacing contaminated bedding

    **5. Biosecurity**
    - Closed herd if possible (no new purchases)
    - If buying, purchase only from tested, negative herds
    - Quarantine and test all new arrivals
    - Never use breeding stock from infected herds

    **6. Long-term Eradication**
    - Commit to multi-year testing and culling program
    - Consider genetic testing for susceptibility
    - Breed for high health genetics to reduce risk
    - Track progress - herd prevalence should decrease yearly

    **7. If Herd is Heavily Infected**
    - Consider complete depopulation
    - Thorough facility cleaning and disinfection
    - Environmental rest period (6-12 months)
    - Restart with tested, negative animals

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Cattle Management](cattle.md) - Cattle-specific husbandry
