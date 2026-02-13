# Greasy Pig Disease (Exudative Dermatitis)

Greasy Pig Disease is a bacterial skin infection primarily affecting young piglets, where the skin becomes covered in greasy, dark exudate. The disease is caused by *Staphylococcus hyicus* bacteria entering through skin abrasions, cuts, or wounds from fighting, rough surfaces, or needle teeth.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Pigs only |
| Transmission Rate | 5% per month |
| Immunity Period | 12 months |
| Recovery Time | 3 months (natural) |
| Sale Value Impact | 40% reduction (0.6 multiplier) |

!!! warning "Piglet Vulnerability"
    Greasy Pig Disease primarily affects piglets under 6 months of age, with risk decreasing dramatically as pigs mature.

## Infection Risk

### Base Probability

Greasy Pig Disease has strongly age-dependent risk:

| Age (months) | Base Probability | Risk Level |
|--------------|------------------|------------|
| 0-5 | 0.5% per month | Very high (10x adult risk) |
| 6-11 | 0.2% per month | Medium (4x adult risk) |
| 12+ | 0.05% per month | Low (baseline) |

!!! info "Age-Dependent Risk"
    Young piglets (0-6 months) are 10x more likely to develop Greasy Pig Disease than mature pigs, reflecting their thinner, more fragile skin and increased vulnerability to skin trauma.

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.125% actual chance for young piglets (75% reduction)
- Health 1.0 (average): 0.5% actual chance for young piglets
- Health 0.25 (worst): 0.875% actual chance for young piglets (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A young piglet (0-6 months) with average health (1.0) at >100% capacity:
- Base: 0.5%
- × Health: 1.0
- × Overcrowding: 2.0
- **= 1.0% monthly chance** (very high risk)

### Transmission

Greasy Pig Disease can spread between piglets through direct contact and environmental contamination:

- **Base transmission rate**: 5% per month
- **Transmission chance**: `0.05 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of pigs are immune, transmission is reduced by 90%

!!! warning "Littermate Spread"
    The disease spreads readily between littermates through direct skin contact and fighting. Once one piglet is infected, others in the same pen are at high risk.

## Symptoms and Effects

### Production Impact

Greasy Pig Disease causes mild reduction in activity and growth:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid Manure | 90% | 10% reduction |

!!! info "Growth Impact"
    The 10% manure reduction reflects decreased feed intake and activity due to skin discomfort and pain.

### Fatality

Greasy Pig Disease carries significant mortality risk, especially in young piglets:

| Time After Infection | Fatality Rate | Cumulative Deaths |
|----------------------|---------------|-------------------|
| Month 0 | 10% | 10% |
| Month 2+ | 3% | ~13% total |

!!! danger "Early Mortality"
    The 10% immediate fatality rate reflects acute cases where toxins from the bacteria cause septicemia (blood poisoning). Most deaths occur in the first month if untreated.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Greasy, dark brown exudate covering skin
   - Patchy areas of damaged, peeling skin
   - Pain and discomfort
   - 10% manure reduction
   - Can spread to other piglets (5% transmission)
   - 10% initial fatality, decreasing to 3%
   - 40% reduction in sale value

2. **Being Treated**
   - $100 cost for 1 month
   - Production penalties continue during treatment
   - After 1 month, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Skin heals (may have scarring in severe cases)
   - Cannot be reinfected for 12 months
   - No production penalties
   - No sale value penalty

### Natural Recovery

Piglets can recover naturally without treatment:
- After 3 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 12-month immunity
- Saves $100 treatment cost
- Higher death risk during untreated period (13% vs ~5% if treated)
- Risk of scarring and permanent skin damage

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $100 |
| Duration | 1 month |
| Total Cost | $100 |
| Immunity Granted | 12 months |

### Treatment Process

1. Select the infected piglet in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $100 treatment cost (MEDICINE finance category)
4. Wait 1 month for antibiotic treatment to complete
5. Piglet recovers and gains 12 months of immunity
6. Skin heals and production returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Fatality Risk | Total Loss |
|----------|------|------------------|---------------|------------|
| Immediate treatment | $100 | 1 month | ~5% | $100 + 1 month loss + death risk |
| Wait for natural recovery | $0 | 3-5 months average | ~13% | 0 + 3-5 months loss + higher death risk |

!!! tip "Treatment Recommendation"
    Always treat Greasy Pig Disease immediately, especially in young piglets:
    - $100 treatment is very affordable
    - Reduces death risk from 13% to ~5%
    - Faster recovery (1 month vs 3-5 months)
    - Less suffering for the piglet
    - Reduced spread to littermates
    - Prevents permanent skin scarring

## Prevention

### Best Practices

**Skin Protection (Critical)**
- **Smooth flooring** - Remove rough, abrasive surfaces that damage skin
- **No sharp edges** - Eliminate protruding nails, broken slats, sharp feeders
- **Teeth clipping** - Clip needle teeth at birth to prevent bite wounds
- **Tail docking care** - Use proper technique to avoid infection points
- **Gentle handling** - Minimize skin trauma during processing

**Fighting Prevention**
- **Minimize mixing** - Avoid mixing unfamiliar piglets (causes fighting)
- **Stable groups** - Keep littermates together
- **Adequate space** - Prevent crowding-related aggression
- **Enrichment** - Provide toys/rooting materials to reduce boredom fighting
- **Avoid competition** - Sufficient feeder and waterer space

**Environmental Management**
- **Clean, dry bedding** - Prevents bacterial growth and skin softening
- **Good drainage** - Wet conditions soften skin and promote bacteria
- **Regular cleaning** - Remove manure and contamination
- **Disinfection** - Clean pens between groups
- **Avoid overcrowding** - Keep below 80% capacity

**Hygiene Practices**
- **Clean processing** - Sterile equipment for teeth clipping, castration, etc.
- **Umbilical care** - Treat navels with iodine at birth
- **Wound treatment** - Promptly treat any cuts or abrasions
- **Foot baths** - For personnel entering piglet areas

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce infection risk by up to 75%
- **Skin quality** - Some bloodlines have tougher, more resilient skin
- **Track disease history** - Identify sows whose piglets are prone to skin issues

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce numbers |
| Young age (0-6 months) | 10x baseline | Extra care for piglets |
| Rough flooring | Very high | Smooth surfaces, good maintenance |
| Fighting | Very high | Stable groups, teeth clipping |
| Poor hygiene | High | Regular cleaning and disinfection |
| Wet bedding | High | Good drainage, dry bedding |
| Mixing piglets | High | Minimize group changes |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Duration |
|----------------|--------|----------|
| Treatment | $100 | One-time if treated |
| Lost growth | 10% for duration | Minor impact |
| Sale value reduction | 40% | While sick |
| Death loss | 5-13% depending on treatment | Piglet value loss |

### Calculation Examples

**Single piglet with Greasy Pig Disease (treated immediately):**
- Treatment: $100
- Production loss: 1 month at 10% = minimal impact
- Death risk: ~5%
- If dies: ~$50 young piglet value
- If survives: ~$100 total cost
- **Expected cost: (0.95 × $100) + (0.05 × $50) = ~$97.50**

**Single piglet with Greasy Pig Disease (natural recovery, 4 months):**
- Treatment: $0
- Production loss: 4 months at 10% = modest growth delay
- Death risk: ~13%
- If dies: ~$50 young piglet value
- If survives: $0 treatment but 4 months slower growth
- **Expected cost: (0.87 × $0) + (0.13 × $50) = ~$6.50 in deaths, plus growth delay**

**Litter outbreak (10 piglets, 3 infected):**
- If untreated: 5% transmission × 3/10 = 1.5% per piglet per month
- Potential spread to 2-3 more piglets over several months
- Treatment cost if all 3 treated immediately: 3 × $100 = $300
- If spreads to 6 piglets: 6 × $100 = $600
- Deaths (13% untreated): 6 × 0.13 × $50 = ~$39 expected loss
- **Early treatment saves $300+ and reduces deaths**

**Farrowing barn scenario (5 litters, 50 piglets, poor flooring):**
- High risk environment with rough surfaces
- Potential for 5-10 cases over 3 months
- Treatment costs: 10 × $100 = $1,000
- Death losses: 10 × 0.05 × $50 = $25 (if treated)
- **vs. fixing flooring: $500 one-time, prevents future outbreaks**

### Indirect Costs

- **Permanent skin scarring** - Reduces carcass value even after recovery
- **Growth delays** - Slower-growing pigs delay marketing
- **Management time** - Treating and monitoring affected piglets
- **Whole-litter impact** - Often affects multiple piglets simultaneously
- **Facility repairs** - May need to fix rough flooring or sharp edges

## Management Strategy

!!! tip "Greasy Pig Disease Prevention and Control Protocol"
    **1. Prevention First (Critical for Piglet Health)**
    - Smooth, well-maintained flooring (absolutely critical)
    - Clip needle teeth at birth
    - Minimize piglet mixing and fighting
    - Clean, dry bedding at all times
    - Good hygiene during processing (teeth, tails, castration)
    - Avoid overcrowding (<80% capacity)

    **2. Age-Specific Risk Management**
    - Piglets 0-6 months: Very high risk (10x baseline)
    - Piglets 6-12 months: Medium risk (4x baseline)
    - Pigs 12+ months: Low risk (baseline)
    - Focus prevention efforts on youngest pigs

    **3. Environmental Inspection**
    - Walk through piglet areas weekly
    - Look for sharp edges, broken slats, rough concrete
    - Check for protruding nails or wire
    - Identify and fix abrasive surfaces immediately
    - Smooth any rough flooring

    **4. Minimize Skin Trauma**
    - Proper teeth clipping technique (don't crack teeth)
    - Clean, sharp equipment for processing
    - Gentle handling during moves
    - Adequate space to prevent fighting
    - Stable social groups (no mixing)

    **5. Early Detection**
    - Check piglets daily for skin abnormalities
    - Look for greasy, dark brown exudate
    - Notice patchy, peeling skin
    - Watch for reduced activity
    - Early detection = better outcomes

    **6. Immediate Treatment**
    - Treat at first signs
    - $100 is very affordable for piglet health
    - 1 month treatment is fast
    - Reduces death risk from 13% to 5%
    - Prevents spread to littermates (5% transmission)

    **7. Isolation**
    - Separate severely affected piglets if possible
    - Reduces spread to healthy littermates
    - Allows individual monitoring and care
    - Return to group after treatment

    **8. Hygiene Protocol**
    - Clean and disinfect pens between groups
    - Use foot baths for personnel
    - Treat umbilical cords with iodine at birth
    - Promptly treat any wounds or cuts
    - Sterile equipment for all processing

    **9. Post-Outbreak Analysis**
    - Identify skin trauma source (flooring? fighting?)
    - Fix rough surfaces or sharp edges
    - Review teeth clipping technique
    - Assess piglet handling procedures
    - Evaluate stocking density
    - Prevent recurrence through facility improvements

    **10. Long-Term Prevention**
    - Breed for high health genetics
    - Select sows with tough-skinned piglets
    - Maintain excellent flooring condition
    - Stable social groups throughout growth
    - Continuous facility maintenance
    - Regular hygiene protocols

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Pig Management](pigs.md) - Pig-specific husbandry
