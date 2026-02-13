# Equine Gastric Ulcer Syndrome (EGUS)

Equine Gastric Ulcer Syndrome affects horses in high-stress environments, causing poor appetite, weight loss, and behavioral changes. It is particularly common in performance horses and those fed high-grain diets with limited forage access.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Horses only |
| Transmission Rate | None (not contagious) |
| Immunity Period | 6 months |
| Recovery Time | 3 months (natural) |
| Sale Value Impact | 25% reduction (0.75 multiplier) |

## Infection Risk

### Base Probability

EGUS can develop in horses once they reach maturity:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-11 | 0% (too young) |
| 12+ | 0.2% per month |

!!! info "Adult Horse Condition"
    EGUS only affects horses 12+ months old, as it's associated with adult feeding patterns, stress, and stomach acid production related to concentrated feeds.

### Modifying Factors

The actual chance of EGUS is modified by multiple factors:

**Health Genetics Modifier**
- Health 1.75 (best): 0.05% actual chance (75% reduction)
- Health 1.0 (average): 0.2% actual chance
- Health 0.25 (worst): 0.35% actual chance (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**
- >100% capacity: 2.0x probability (stress increases ulcer risk)
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A mature horse with average health (1.0) at >100% capacity:
- Base: 0.2%
- × Health: 1.0
- × Overcrowding: 2.0
- **= 0.4% monthly chance**

### No Transmission

EGUS is not contagious - it's an individual stress-related digestive condition:
- Does not spread between horses
- Each horse's risk is independent
- Multiple cases indicate environmental stressors (feeding, stress, management)

## Symptoms and Effects

### Production Impact

EGUS reduces appetite and digestive efficiency:

| Output Type | Modifier | Effect |
|-------------|----------|--------|
| Solid Manure | 70% | 30% reduction |

!!! info "Reduced Feed Intake"
    The 30% reduction in manure reflects decreased appetite and feed intake due to stomach pain and discomfort from ulcers.

### Fatality

EGUS is rarely fatal but can become dangerous if untreated for extended periods:

| Time After Onset | Fatality Rate | Cumulative Deaths |
|------------------|---------------|-------------------|
| Month 0-11 | 0% | 0% |
| Month 12+ | 1% | 1% |

!!! warning "Late-Stage Complications"
    While EGUS itself is rarely fatal, chronic untreated ulcers can lead to complications like gastric rupture in severe cases after many months.

## Disease Progression

### Active Disease States

1. **Active (Untreated)**
   - Poor appetite and weight loss
   - 30% manure reduction
   - Cannot spread to other horses
   - Late fatality risk (1% after 12 months)
   - 25% reduction in sale value
   - Behavioral changes (girthiness, reluctance to work)

2. **Being Treated**
   - $250 cost per month for 2 months
   - Production penalties continue during treatment
   - After 2 months, becomes immune
   - No transmission risk

3. **Immune (Recovered)**
   - Normal production resumes
   - Cannot develop EGUS for 6 months
   - No production penalties
   - No sale value penalty

### Natural Recovery

Horses can recover naturally without treatment:
- After 3 months with EGUS, 75% chance of natural recovery each month
- Natural recovery grants the same 6-month immunity
- Saves $500 total treatment cost
- Extended discomfort and weight loss during untreated period

## Treatment

| Property | Value |
|----------|-------|
| Treatment Available | Yes |
| Cost | $250 per month |
| Duration | 2 months |
| Total Cost | $500 |
| Immunity Granted | 6 months |

### Treatment Process

1. Select the affected horse in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $250 monthly treatment cost (MEDICINE finance category)
4. Wait 2 months for treatment to complete
5. Horse recovers and gains 6 months of immunity
6. Normal appetite and production return

### Cost-Benefit Analysis

| Approach | Cost | Time to Recovery | Total Loss |
|----------|------|------------------|------------|
| Immediate treatment | $500 | 2 months | $500 + 2 months discomfort |
| Wait for natural recovery | $0 | 3-6 months average | 3-6 months weight loss/discomfort |

!!! tip "Treatment Recommendation"
    Treatment is recommended for valuable horses and those in work:
    - $500 cost is reasonable for working/performance horses
    - Faster recovery (2 months vs 3-6 months average)
    - Less weight loss and discomfort
    - Better for horses in training or competition
    - For horses not in work, natural recovery may be acceptable

## Prevention

### Best Practices

**Feeding Management (Critical)**
- **Frequent small meals** - Avoid long periods without feed (>6 hours)
- **Forage-based diet** - Plenty of hay or grass available 24/7
- **Limit grain/concentrates** - High-grain diets increase ulcer risk
- **Feed before exercise** - Small hay meal before work buffers stomach acid
- **Avoid sudden feed changes** - Gradual transitions reduce stress

**Stress Reduction**
- **Minimize transport** - Transport is a major stressor
- **Reduce competition stress** - Performance horses at high risk
- **Stable routine** - Consistent daily schedule
- **Turnout time** - Allow natural grazing behavior
- **Social stability** - Avoid frequent herd changes

**Management Practices**
- **Avoid overcrowding** - Keep below 80% capacity (stress increases ulcers)
- **Appropriate workload** - Don't overtrain
- **Regular rest days** - Recovery time reduces stress
- **Good ventilation** - Comfortable environment

**Health Management**
- **Breed for health** - High health genetics reduce EGUS risk by up to 75%
- **Monitor body condition** - Weight loss is early sign
- **Watch appetite** - Reduced eating indicates problems
- **Observe behavior** - Girthiness, reluctance to work are signs

### Risk Factors

| Factor | Risk Impact | Mitigation |
|--------|-------------|------------|
| Poor health genetics (0.25) | +75% | Selective breeding program |
| Overcrowding (>100%) | +100% (doubles) | Expand facilities or reduce herd |
| Infrequent feeding | Very high | Free-choice hay/grass |
| High-grain diet | Very high | Forage-based feeding |
| Competition/performance stress | High | Appropriate rest periods |
| Frequent transport | High | Minimize travel |
| Limited turnout | High | Daily pasture access |
| Intense training | Medium | Balanced work schedules |

**Highest Risk Scenario:**
Performance horse with high-grain diet, frequent shows, limited turnout, poor health genetics = **very high risk**

## Economic Impact

### Direct Costs

| Cost Component | Amount | Notes |
|----------------|--------|-------|
| Treatment (2 months) | $500 | If treated |
| Lost manure production | 30% for duration | Minor economic impact |
| Weight loss | Variable | Reduced condition |
| Sale value reduction | 25% | While sick |
| Death loss | 1% after 12 months if untreated | Rare but possible |

### Calculation Examples

**Performance horse with EGUS (treated immediately):**
- Treatment: $500
- 2 months reduced performance
- Returns to normal after treatment
- **Total cost: ~$500 + training interruption**

**Performance horse with EGUS (natural recovery, 5 months):**
- Treatment: $0
- 5 months reduced performance and weight loss
- Training setbacks
- **Total cost: ~$0 treatment but significant performance loss**

**Pleasure horse with EGUS (natural recovery):**
- Treatment: $0
- 3-6 months discomfort
- Not in performance, so less critical
- **Total cost: ~$0 - natural recovery acceptable**

**Barn with multiple stressed horses (5 horses, 2 with EGUS):**
- Indicates management problems (feeding, stress)
- Treat both: 2 × $500 = $1,000
- Address underlying causes to prevent recurrence
- **Total cost: $1,000 + management changes**

### Indirect Costs

- **Performance impact** - Cannot train/compete at full capacity
- **Weight loss** - Requires time to regain condition
- **Behavioral issues** - Girthiness, resistance to work
- **Training setbacks** - Lost progress during illness
- **Management time** - Monitoring and care
- **Repeated episodes** - If underlying causes not addressed (6-month immunity only)

## Management Strategy

!!! tip "EGUS Prevention and Control Protocol"
    **1. Prevention First (Critical for Performance Horses)**
    - Free-choice hay or grass 24/7
    - Minimize grain/concentrates (use only as needed)
    - Feed small hay meal before exercise
    - Never leave horses without forage for >6 hours
    - Forage, forage, forage!

    **2. Stress Management**
    - Minimize transport (major risk factor)
    - Reduce competition stress
    - Consistent daily routine
    - Adequate turnout time (natural grazing)
    - Social stability (avoid frequent herd changes)
    - Avoid overcrowding (<80% capacity)

    **3. High-Risk Horse Identification**
    - Performance/competition horses at highest risk
    - Horses on high-grain diets
    - Frequently transported horses
    - Limited turnout horses
    - Poor health genetics (+75% risk)
    - Overcrowded facilities (doubles risk)

    **4. Early Detection**
    - Watch for: poor appetite, weight loss, dull coat
    - Behavioral signs: girthiness, resistance to work, grinding teeth
    - Body condition scoring regularly
    - Monitor feed intake
    - Early detection allows faster treatment

    **5. Treatment Decisions**
    - Performance horses: always treat ($500 worthwhile)
    - Working horses: treat for faster recovery
    - Pleasure horses: natural recovery may be acceptable
    - Consider horse value vs. treatment cost
    - Faster recovery = less training setback

    **6. Post-Recovery Management**
    - Horse is immune for 6 months after recovery
    - Continue stress management practices
    - Maintain forage-based diet
    - Address underlying causes
    - Short immunity period - can recur after 6 months

    **7. Long-Term Prevention**
    - Breed for high health genetics
    - Establish forage-first feeding program
    - Minimize stress throughout horse's life
    - Appropriate training intensity
    - Regular turnout
    - Avoid overcrowding

    **8. Management Changes for Repeated Cases**
    - Multiple cases indicate systemic problems
    - Review feeding program (more forage, less grain)
    - Assess stress levels (competition, transport, crowding)
    - Improve turnout opportunities
    - Evaluate training intensity
    - Consider facility capacity

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Horse Management](horses.md) - Horse-specific husbandry
