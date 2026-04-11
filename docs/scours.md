# Scours (Piglet Diarrhea)

Scours is a severe bacterial or viral diarrhea in piglets leading to rapid dehydration and death. It is the **leading cause of piglet mortality** and represents one of the most dangerous diseases in the game with a devastating 50% initial fatality rate in untreated piglets. Immediate rehydration and treatment are critical for survival.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Pigs only |
| Transmission Rate | 6% per month |
| Immunity Period | 6 months (short) |
| Recovery Time | 2 months (natural) |
| Sale Value Impact | 40% reduction (0.6 multiplier) |
| Weight Gain Impact | 50% reduction (0.5 multiplier) |

!!! danger "Piglet Killer - 50% Initial Fatality"
    Scours is the deadliest disease for piglets in the game. With a 50% fatality rate in the first month, half of all untreated piglets will die. This is a VETERINARY EMERGENCY requiring immediate treatment.

## Infection Risk

### Base Probability

Scours overwhelmingly affects young piglets, with risk decreasing dramatically as they mature:

| Age (months) | Base Probability | Risk Level |
|--------------|------------------|------------|
| 0-5 | 1.0% per month | Extremely high (10x adult risk) |
| 6-11 | 0.3% per month | Medium (3x adult risk) |
| 12+ | 0.1% per month | Low (baseline) |

!!! danger "Newborn Vulnerability"
    Piglets 0-6 months old face a 1% monthly chance of scours - 10 times higher than mature pigs. Newborns are especially vulnerable in the first days of life due to immature immune systems and reliance on colostrum for immunity.

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.25% actual chance for young piglets (75% reduction)
- Health 1.0 (average): 1.0% actual chance for young piglets
- Health 0.25 (worst): 1.75% actual chance for young piglets (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A newborn piglet (0-6 months) with poor health genetics (0.25) at >100% capacity:
- Base: 1.0%
- × Health: 1.75
- × Overcrowding: 2.0
- **= 3.5% monthly chance** (extremely high risk - expect multiple cases)

### Transmission

Scours spreads rapidly through fecal-oral contamination:

- **Base transmission rate**: 6% per month
- **Transmission chance**: `0.06 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of pigs are immune, transmission is reduced by 90%

!!! warning "Explosive Spread in Farrowing Barns"
    The combination of 6% transmission and extreme piglet vulnerability means one case can quickly become a litter-wide outbreak. Bacteria spread through contaminated surfaces, equipment, sow udders, and personnel.

## Symptoms and Effects

### Production Impact

Scours causes severe, watery diarrhea with dramatic waste changes:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Liquid Manure | 300% | 3x increase (severe diarrhea) |
| Solid Manure | 30% | 70% reduction |

!!! danger "Severe Dehydration"
    The 3x increase in liquid manure represents profuse, watery diarrhea that rapidly dehydrates piglets. This fluid loss is what kills - piglets can die within 12-24 hours without rehydration.

### Weight and Growth

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 50% | Severely stunted growth |

!!! warning "Lifetime Impact"
    Even survivors often suffer permanent growth setbacks. Piglets that recover from scours typically remain "tail-enders" - the smallest, slowest-growing pigs in the group.

### Fatality

Scours has the highest fatality rate of any disease in the game:

| Time After Infection | Fatality Rate | Cumulative Deaths |
|----------------------|---------------|-------------------|
| Month 0 | 50% | 50% (!!) |
| Month 1 | 10% | ~55% total |
| Month 2 | 2% | ~56% total |

!!! danger "Act Within Hours, Not Days"
    The 50% immediate fatality rate reflects the reality of piglet scours - dehydration kills fast. In real-world scenarios, untreated piglets die within 12-24 hours. Treatment must be immediate.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Severe, watery diarrhea (3x liquid manure)
   - Rapid dehydration
   - Sunken eyes, hollow flanks
   - Weakness and inability to stand
   - 70% solid manure reduction
   - 50% weight gain reduction
   - Can spread to littermates (6% transmission)
   - **50% die in first month** if untreated
   - 40% reduction in sale value

2. **Being Treated**
   - $100 cost for 1 month
   - Rehydration therapy and antibiotics/antivirals
   - Production penalties continue during treatment
   - After 1 month, becomes immune
   - Greatly reduced transmission during treatment
   - Drastically reduced fatality (50% → ~10%)

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 6 months (short immunity!)
   - No production penalties
   - No sale value penalty
   - May have permanent growth stunting from episode

### Natural Recovery

Piglets CAN recover naturally, but at catastrophic cost:
- After 2 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 6-month immunity
- Saves $100 treatment cost
- **50% die in first month waiting for natural recovery**
- Survivors suffer 2-4 months of severe growth stunting
- Often remain runts for life

!!! danger "Never Rely on Natural Recovery"
    With 50% immediate fatality, "natural recovery" means watching half your piglets die. This is NEVER an acceptable strategy for scours. Treatment is mandatory.

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $100 |
| Duration | 1 month |
| Total Cost | $100 |
| Immunity Granted | 6 months (short) |

### Treatment Process

1. Select the affected piglet in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $100 treatment cost (MEDICINE finance category)
4. Treatment includes rehydration (IV or oral fluids) and anti-diarrheal medication
5. Wait 1 month for treatment to complete
6. Piglet recovers and gains 6 months of immunity
7. Production returns to normal (though may have lasting growth impact)

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Fatality Risk | Total Loss |
|----------|------|------------------|---------------|------------|
| Immediate treatment | $100 | 1 month | ~10% | $100 + 1 month loss + 10% death |
| Wait for natural recovery | $0 | 2-4 months average | **50%+** | 0 + 2-4 months loss + **50% death** |

!!! tip "Treatment is NOT Optional"
    There is NO decision to make here. Scours has a 50% fatality rate. Treatment is MANDATORY:
    - $100 cost is trivial compared to losing half your piglets
    - Reduces death from 50% to ~10% (saves 40% of piglets!)
    - Faster recovery (1 month vs 2-4 months)
    - In a litter of 10 piglets, treatment saves ~4 lives at $100 each = $25 per life saved
    - Untreated scours = economic and welfare catastrophe

## Prevention

### Best Practices

**Colostrum Management (CRITICAL)**
- **Ensure adequate colostrum intake** - First milk contains antibodies against scours
- **Within 6 hours of birth** - Absorption window closes rapidly
- **Weak piglets** - Tube-feed colostrum to ensure intake
- **Check nursing** - Verify all piglets nurse successfully
- **Colostrum quality** - Well-fed sows produce better colostrum

**Farrowing Hygiene**
- **Thoroughly clean farrowing crates** - Between litters, deep cleaning and disinfection
- **All-in/all-out management** - Break disease cycles
- **Disinfection** - Use appropriate disinfectants effective against scours pathogens
- **Clean sow udders** - Before farrowing, wash sow udders with clean water
- **Clean floors** - Prevent fecal contamination of piglet areas

**Environmental Management**
- **Warm housing** - Cold stress increases susceptibility dramatically
- **Draft-free** - Piglets are extremely sensitive to cold drafts
- **Dry bedding** - Wet, cold environments are lethal for piglets with scours
- **Clean water** - Prevent water source contamination
- **Avoid overcrowding** - Keep below 80% capacity

**Biosecurity**
- **Foot baths** - At farrowing room entrances
- **Personnel hygiene** - Wash hands between litters
- **Clean equipment** - Disinfect processing tools
- **Quarantine** - Isolate sick piglets from healthy littermates if possible

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce scours risk by up to 75%
- **Track disease history** - Identify sow lines with higher scours resistance
- **Immune transfer** - Some sows have superior colostral antibodies

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce farrowing rate |
| Young age (0-6 months) | 10x baseline | Extra vigilance for newborns |
| Inadequate colostrum | CRITICAL | Ensure all piglets nurse within 6 hours |
| Cold housing | CRITICAL | Supplemental heat, draft-free environment |
| Poor hygiene | Very high | All-in/all-out, thorough cleaning |
| Contaminated water | High | Clean, fresh water sources |
| Weak piglets | High | Tube-feed colostrum, extra care |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Duration/Rate |
|----------------|--------|---------------|
| Treatment | $100 | One-time if treated |
| Death loss (untreated) | 50% of piglets | Catastrophic |
| Death loss (treated) | ~10% of piglets | Significant but manageable |
| Lost growth | 50% for duration | Severe stunting |
| Sale value reduction | 40% | While sick |

### Calculation Examples

**Single piglet with scours (treated immediately):**
- Treatment: $100
- Production loss: 1 month at 50% weight gain reduction
- Death risk: ~10%
- If dies: ~$50 young piglet value
- If survives: ~$100 total cost + growth delay
- **Expected cost: (0.9 × $100) + (0.1 × $50) = ~$95**

**Single piglet with scours (untreated - natural recovery attempt):**
- Treatment: $0
- Production loss: 2-4 months at 50% weight gain reduction
- Death risk: **50%**
- If dies: ~$50 young piglet value lost
- If survives: Severe growth stunting for life
- **Expected cost: (0.5 × $0) + (0.5 × $50) = $25 in deaths, plus permanent runt status**

**Litter outbreak (10 piglets, 3 infected, all treated immediately):**
- Treatment: 3 × $100 = $300
- Death risk: 3 × 10% = 0.3 piglets expected to die = ~$15
- Transmission prevented through treatment
- **Total expected cost: $300 + $15 = ~$315**

**Litter outbreak (10 piglets, 3 infected, untreated):**
- Treatment: $0
- Deaths: 3 × 50% = 1.5 piglets die = ~$75
- Transmission: 6% × 3/10 = 1.8% per piglet per month → 2-3 more infected over time
- Total infected: 5-6 piglets
- Total deaths: 5 × 50% = 2.5 piglets = ~$125
- Survivors permanently stunted
- **Total expected cost: $125+ in deaths plus production losses**

**Barn scenario (5 sows farrowing, 50 piglets, poor hygiene):**
- High risk environment: cold, wet, contaminated
- Expected cases: 5-10 piglets with scours
- If all treated: 10 × $100 = $1,000, deaths: 10 × 10% × $50 = ~$50
- If untreated: 10 × 50% × $50 = $250 in deaths, plus spread to more piglets
- **Treatment cost: $1,050 vs. untreated cost: $500+ deaths + runts**

### Indirect Costs

- **Permanent runting** - Survivors often remain the smallest pigs in the group for life
- **Market delays** - Runts delay marketing of entire group
- **Sow reputation** - Sow lines prone to scours lose value
- **Management stress** - Scours outbreaks require intensive care and monitoring
- **Facility costs** - May need heating upgrades, improved drainage
- **Replacement costs** - Dead piglets must be replaced with new breeding stock

### True Cost of Scours

| Scenario | Deaths | Growth Impact | Total Loss |
|----------|--------|---------------|------------|
| Single piglet, untreated | 50% ($25) | Severe lifelong stunting if survives | $25-50 |
| Single piglet, treated | 10% ($5) | 1 month delay | $105 |
| Litter of 10, untreated | 50% ($250) | Entire litter stunted | $250-500 |
| Litter of 10, treated | 10% ($50) | Minimal | $1,050 |

!!! danger "Scours Can Destroy Your Piglet Crop"
    In a severe outbreak with poor hygiene, scours can affect 20-30% of piglets with 50% mortality. In a barn with 100 piglets:
    - 30 infected × 50% death = 15 dead piglets = $750 lost
    - Survivors: 15 permanently runted
    - **Total loss: $750+ plus reduced productivity**

## Management Strategy

!!! tip "Scours Prevention and Emergency Protocol"
    **1. Prevention is Life or Death**
    - Ensure EVERY piglet receives colostrum within 6 hours of birth
    - Warm, draft-free farrowing environment (absolutely critical)
    - All-in/all-out with deep cleaning between groups
    - Clean sow udders before farrowing
    - Dry, clean bedding at all times
    - Avoid overcrowding (<80% capacity)

    **2. Colostrum Protocol (Non-Negotiable)**
    - Check every piglet nurses within 6 hours
    - Weak piglets: tube-feed 50ml colostrum
    - Verify suckle reflex in all piglets
    - Large litters: may need colostrum supplements
    - Cold piglets can't nurse - warm first, then feed

    **3. Environmental Control**
    - Supplemental heat in farrowing areas
    - Heat lamps or floor heating for piglets
    - Target: 90-95°F (32-35°C) for newborns
    - Draft-free (use solid sides or covers)
    - Dry bedding changed frequently

    **4. Hygiene Protocol**
    - All-in/all-out by room or building
    - Deep clean between groups: pressure wash, disinfect, dry
    - Foot baths with fresh disinfectant daily
    - Wash sow udders before farrowing
    - Clean equipment between litters

    **5. Early Detection (Check Multiple Times Daily)**
    - Watch for watery diarrhea
    - Sunken eyes and hollow flanks (dehydration)
    - Weakness, inability to stand
    - Reduced nursing
    - Scours progresses in HOURS not days - check often!

    **6. IMMEDIATE Treatment (Emergency Response)**
    - Treat at FIRST signs - don't wait
    - $100 treatment reduces death from 50% to 10%
    - Every hour of delay increases mortality
    - In litter outbreaks, treat all affected piglets simultaneously
    - Isolate from healthy littermates if possible

    **7. Rehydration Support**
    - While game treatment is simplified, real-world requires fluids
    - Warm environment helps conserve energy
    - Continue nursing if possible
    - Monitor closely during treatment month

    **8. Herd Immunity Management**
    - Only 6 months immunity (short!)
    - Sows: build immunity through controlled exposure
    - Recovered piglets: immune for 6 months, then vulnerable again
    - Can't rely on long-term herd immunity like other diseases

    **9. Genetic Selection**
    - Breed for high health genetics
    - Track sow lines with scours resistance
    - Cull sows whose piglets repeatedly get scours
    - Select for colostrum quality (indirect measure)

    **10. Post-Outbreak Analysis**
    - What was the source? (contaminated surface, cold stress, poor colostrum?)
    - Review hygiene protocols
    - Check farrowing environment temperature
    - Assess colostrum intake procedures
    - Implement improvements before next group

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Pig Management](pigs.md) - Pig-specific husbandry
