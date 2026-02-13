# Swine Influenza

Swine Influenza is a highly contagious respiratory disease affecting pigs of all ages, causing fever, lethargy, coughing, and reduced activity. While mortality is low, the disease spreads extremely rapidly through barns (12% transmission rate) and impacts growth rates and productivity.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Pigs only |
| Transmission Rate | 12% per month (very high) |
| Immunity Period | 12 months |
| Recovery Time | 2 months (natural) |
| Sale Value Impact | 25% reduction (0.75 multiplier) |

!!! warning "Rapid Spread"
    With a 12% transmission rate, Swine Influenza spreads faster than most pig diseases. A single infected pig can quickly trigger a barn-wide outbreak.

## Infection Risk

### Base Probability

Swine Influenza can affect pigs at any age with consistent probability:

| Age (months) | Base Probability |
|--------------|------------------|
| 0+ | 0.2% per month |

### Modifying Factors

The actual infection chance is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.05% actual chance (75% reduction)
- Health 1.0 (average): 0.2% actual chance
- Health 0.25 (worst): 0.35% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A pig with average health (1.0) at >100% capacity:
- Base: 0.2%
- × Health: 1.0
- × Overcrowding: 2.0
- **= 0.4% monthly chance** (doubled risk in overcrowded conditions)

### Transmission

Swine Influenza spreads very rapidly through airborne droplets and direct contact:

- **Base transmission rate**: 12% per month (one of the highest transmission rates)
- **Transmission chance**: `0.12 × (infected_count / total_animals) × health_modifier × overcrowding_modifier × herd_immunity_factor`
- **Herd immunity**: When >70% of pigs are immune, transmission is reduced by 90%

!!! danger "Explosive Spread"
    The 12% transmission rate means an outbreak can affect most of a barn within weeks. If 5 out of 50 pigs are infected, the transmission chance is 12% × 10% = 1.2% per pig per month, but this is before modifiers. In overcrowded conditions, this can easily affect 20-30% of pigs before being controlled.

## Symptoms and Effects

### Production Impact

Swine Influenza causes mild but noticeable reduction in activity:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid Manure | 80% | 20% reduction |

!!! info "Reduced Activity"
    The 20% manure reduction reflects decreased movement, feed intake, and overall activity due to respiratory distress and fever.

### Weight and Growth

| Effect | Modifier | Impact |
|--------|----------|--------|
| Weight Gain | 100% | No direct weight gain penalty |

!!! note "Growth Impact"
    While there's no direct weight gain penalty in the game mechanics, the reduced feed intake reflected by lower manure output would normally slow growth rates in real-world scenarios.

### Fatality

Swine Influenza has low but consistent mortality:

| Time | Fatality Rate |
|------|---------------|
| All stages | 2% |

!!! note "Low Mortality"
    The 2% fatality rate is constant throughout the infection, meaning most pigs survive but suffer production losses.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Respiratory signs: coughing, sneezing, labored breathing
   - Fever and lethargy
   - 20% manure reduction
   - Can spread to other pigs (12% transmission - very high)
   - 2% fatality risk
   - 25% reduction in sale value

2. **Being Treated**
   - $150 cost for 1 month
   - Production penalties continue during treatment
   - After 1 month, becomes immune
   - Reduced transmission during treatment

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot be reinfected for 12 months
   - No production penalties
   - No sale value penalty

### Natural Recovery

Pigs can recover naturally without treatment:
- After 2 months with the disease, 75% chance of natural recovery each month
- Natural recovery grants the same 12-month immunity
- Saves $150 treatment cost
- Longer production loss and higher risk of barn-wide spread during untreated period

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $150 |
| Duration | 1 month |
| Total Cost | $150 |
| Immunity Granted | 12 months |

### Treatment Process

1. Select the infected pig in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $150 treatment cost (MEDICINE finance category)
4. Wait 1 month for treatment to complete
5. Pig recovers and gains 12 months of immunity
6. Production returns to normal

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Risk of Spread | Total Loss |
|----------|------|------------------|----------------|------------|
| Immediate treatment | $150 | 1 month | Low - treated quickly | $150 + 1 month production loss |
| Wait for natural recovery | $0 | 2-4 months average | High - spreads during delay | 0 + 2-4 months loss + barn-wide outbreak |

!!! tip "Treatment Recommendation"
    ALWAYS treat Swine Influenza immediately despite the low treatment cost and mortality. The reason is transmission:
    - 12% transmission rate means barn-wide outbreaks are inevitable if untreated
    - Treating 1 pig ($150) prevents infecting 10-20 more pigs ($1,500-3,000)
    - Natural recovery takes 2-4 months, allowing extensive spread
    - $150 treatment is cheap insurance against an outbreak

## Prevention

### Best Practices

**Ventilation and Air Quality**
- **Excellent ventilation** - Critical for respiratory diseases
- **Avoid cold drafts** - Cold stress increases susceptibility
- **Control humidity** - Dry air reduces virus survival
- **Fresh air exchange** - Dilutes airborne virus concentration

**Biosecurity**
- **All-in/all-out management** - Prevents continuous infection cycles
- **Quarantine new pigs** - Isolate for 30 days before introduction
- **Minimize visitors** - Control farm access
- **Clean vehicles** - Disinfect transport vehicles
- **Foot baths** - At barn entrances

**Husbandry Management**
- **Avoid overcrowding** - Keep below 80% capacity to reduce transmission
- **Minimize stress** - Stress weakens immune systems
- **Consistent temperature** - Avoid temperature swings
- **Clean water** - Fresh water supports immune function
- **Good nutrition** - Strong immunity through proper feed

**Genetic Selection**
- **Breed for health** - High health genetics (1.5-1.75) reduce infection risk by up to 75%
- **Track disease history** - Identify pigs prone to respiratory issues
- **Cull chronic cases** - Some individuals are more susceptible

**Herd Immunity**
- Recovered pigs are immune for 12 months
- Build immunity through strategic treatment
- When >70% immune, outbreaks stop (90% transmission reduction)
- Time immunity carefully - 12 months means annual vulnerability cycles

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Poor ventilation | Greatly increases transmission | Install proper ventilation systems |
| Cold stress | Increases susceptibility | Maintain consistent temperatures |
| Mixing pigs | Introduction of virus | Quarantine and all-in/all-out |
| No biosecurity | Easy virus entry | Implement strict protocols |

## Economic Impact

### Direct Costs

| Cost Component | Amount | Duration |
|----------------|--------|----------|
| Treatment | $150 | One-time if treated |
| Lost manure production | 20% for duration | Minor economic impact |
| Sale value reduction | 25% | While sick |
| Death loss | 2% chance | Small but present |

### Calculation Examples

**Single pig with Swine Influenza (treated immediately):**
- Treatment: $150
- Production loss: 1 month at 20% = minimal impact
- Death risk: ~2%
- If dies: ~$150 average pig value
- If survives: ~$150 total cost
- **Expected cost: (0.98 × $150) + (0.02 × $150) = ~$150**

**Single pig with Swine Influenza (natural recovery, 3 months):**
- Treatment: $0
- Production loss: 3 months at 20% = minimal impact
- Spread risk: HIGH (12% transmission × 3 months)
- Potential spread to 5-10 more pigs
- **Expected cost: $0 treatment + $750-1,500 treating spread cases = $750-1,500**

**Barn outbreak (100 pigs, 5 infected initially, no treatment):**
- Month 1: 5 infected, transmission = 12% × 5/100 = 0.6% per pig → ~0.6 more infected
- Month 2: 6 infected, transmission = 12% × 6/100 = 0.72% per pig → ~0.7 more infected
- Month 3: 7 infected, continuing cascade
- By month 6: Potentially 15-20 pigs infected
- Treatment cost if addressed late: 20 × $150 = $3,000
- **vs. treating 5 initially: 5 × $150 = $750**

**Barn outbreak (100 pigs, 5 infected, immediate treatment):**
- Treat 5 pigs immediately: $750
- Transmission reduced dramatically during treatment
- Minimal additional cases: maybe 1-2 more
- Total cost: ~$900-1,050
- **Savings: $2,000-2,100 vs. delayed response**

### Indirect Costs

- **Management time** - Monitoring and treating sick pigs
- **Stress on herd** - Respiratory disease affects entire barn environment
- **Repeated outbreaks** - Without biosecurity, reintroduction is common
- **Ventilation upgrades** - May need to improve air quality systems
- **Biosecurity measures** - Implementing protocols has costs

## Management Strategy

!!! tip "Swine Influenza Control Protocol"
    **1. Prevention First**
    - Excellent ventilation (absolutely critical)
    - Avoid overcrowding (<80% capacity)
    - All-in/all-out management
    - Quarantine new pigs for 30 days
    - Strong biosecurity protocols
    - Maintain consistent temperatures

    **2. Early Detection**
    - Watch for respiratory signs: coughing, sneezing, labored breathing
    - Monitor for fever and lethargy
    - Notice reduced activity and feed intake
    - Check for increased respiratory sounds in barn
    - Early detection = less spread

    **3. Immediate Treatment (Critical)**
    - Treat at first signs
    - $150 is cheap compared to outbreak cost
    - 1 month treatment is fast
    - Prevents barn-wide spread (12% transmission is very high)
    - Every day of delay = more infected pigs

    **4. Isolation**
    - Separate infected pigs if possible
    - Reduces transmission to healthy pigs
    - Treat entire affected group/room together
    - Don't mix sick and healthy pigs

    **5. Herd Immunity**
    - Recovered pigs are immune for 12 months
    - After outbreak, barn has high immunity temporarily
    - When >70% immune, future outbreaks are prevented (90% reduction)
    - Plan for immunity to wear off after 12 months
    - May see seasonal outbreaks annually

    **6. Ventilation Management**
    - Install adequate ventilation systems
    - Minimum air exchange rates for pig numbers
    - Balance ventilation vs. temperature control
    - Avoid cold drafts (use ceiling inlets)
    - Good air quality = less disease transmission

    **7. Biosecurity Enforcement**
    - All-in/all-out by room/barn
    - Clean and disinfect between groups
    - Quarantine all new arrivals
    - Foot baths and hand washing
    - Limit visitor access
    - Clean transport vehicles

    **8. Temperature Management**
    - Maintain consistent temperatures
    - Avoid cold stress (immune suppression)
    - Avoid heat stress (increases respiratory rate)
    - Optimal temperature ranges by pig age
    - Use supplemental heat in winter

    **9. Post-Outbreak Analysis**
    - Identify introduction source
    - Review biosecurity protocols
    - Assess ventilation adequacy
    - Consider stocking density
    - Plan improvements to prevent recurrence

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Pig Management](pigs.md) - Pig-specific husbandry
