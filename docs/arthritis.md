# Arthritis

Arthritis is a degenerative joint disease common in aging horses, causing chronic pain, stiffness, and reduced mobility.
Unlike other diseases, arthritis has no immunity period - horses can develop it repeatedly, making it a lifelong
management challenge for older horses.

## Overview

| Property          | Value                               |
|-------------------|-------------------------------------|
| Affected Animals  | Horses only                         |
| Transmission Rate | None (not contagious)               |
| Immunity Period   | None (0 months - chronic condition) |
| Recovery Time     | None (does not naturally recover)   |
| Sale Value Impact | 30% reduction (0.7 multiplier)      |

!!! info "Chronic Condition with No Immunity"
Arthritis is unique - it has NO immunity period. After treatment, horses can immediately develop arthritis again. It
represents chronic, age-related joint degeneration that requires ongoing management.

## Infection Risk

### Base Probability

Arthritis is exclusively an old-age disease affecting senior horses:

| Age (months) | Base Probability             |
|--------------|------------------------------|
| 0-47         | 0% (too young for arthritis) |
| 48-71        | 0.2% per month               |
| 72+          | 0.5% per month               |

!!! info "Senior Horse Disease"
Arthritis only affects horses 48+ months old (4+ years). Horses 72+ months (6+ years) have 2.5x higher risk than younger
adults, reflecting cumulative wear and tear on joints.

### Modifying Factors

The actual chance of arthritis is modified by multiple factors:

**Health Genetics Modifier**

- Health 1.75 (best): 0.125% actual chance for oldest horses (75% reduction)
- Health 1.0 (average): 0.5% actual chance for oldest horses
- Health 0.25 (worst): 0.875% actual chance for oldest horses (75% increase)
- Formula: `base_probability × (2.0 - health_genetics)`

**Overcrowding Modifier**

- > 100% capacity: 2.0x probability
- 80-100% capacity: 1.3x probability
- <50% capacity: 0.8x probability

**Example:** A very old horse (72+ months) with poor health genetics (0.25) at >100% capacity:

- Base: 0.5%
- × Health: 1.75
- × Overcrowding: 2.0
- **= 1.75% monthly chance** (very high for chronic condition)

### No Transmission

Arthritis is not contagious - it's an age-related degenerative condition:

- Does not spread between horses
- Each horse's risk is independent
- All older horses are susceptible as they age

## Symptoms and Effects

### Production Impact

Arthritis causes mild reduction in activity:

| Output Type  | Modifier | Effect        |
|--------------|----------|---------------|
| Solid Manure | 90%      | 10% reduction |

!!! info "Mild Production Impact"
The 10% reduction reflects slightly decreased movement and activity due to joint stiffness, but horses can still
function relatively normally with arthritis.

### Fatality

Arthritis itself is not fatal:

| Time       | Fatality Rate |
|------------|---------------|
| All stages | 0%            |

!!! note "Non-Fatal Condition"
Arthritis does not kill horses. However, it reduces quality of life and may necessitate retirement or reduced workload.

## Disease Progression

### Active Disease States

**Active (Untreated)**

- Joint pain and stiffness
- 10% manure reduction
- Cannot spread to other horses
- No fatality risk
- 30% reduction in sale value
- **No natural recovery - treatment required**

**Being Treated**

- $300 cost per month for 3 months
- Production penalties continue during treatment
- After 3 months, recovers (but NO immunity)
- No transmission risk

**Recovered (No Immunity)**

- Normal production resumes
- Can immediately develop arthritis again
- No production penalties
- No sale value penalty
- **This is the key difference - no immunity period**

### No Natural Recovery

Like other chronic conditions, arthritis does NOT naturally recover:

- Horses remain stiff and painful indefinitely without treatment
- Joint degeneration continues
- **Treatment is the only way to manage symptoms**

### No Immunity Period

The most important characteristic of arthritis:

- After successful treatment, there is NO immunity period
- Horse can develop arthritis again immediately
- Represents the chronic, recurring nature of degenerative joint disease
- Older horses may require repeated treatments throughout their lives

!!! warning "Recurring Condition"
Unlike other diseases, recovering from arthritis does NOT grant immunity. Senior horses may develop arthritis multiple
times, requiring repeated treatments.

## Treatment

| Property            | Value           |
|---------------------|-----------------|
| Treatment Available | Yes             |
| Cost                | $300 per month  |
| Duration            | 3 months        |
| Total Cost          | $900            |
| Immunity Granted    | None (0 months) |

### Treatment Process

1. Select the affected horse in the animal dialog
2. Click the "Treat" button in the disease section
3. Pay the $300 monthly treatment cost (MEDICINE finance category)
4. Wait 3 months for treatment to complete
5. Horse recovers but gains NO immunity
6. Can develop arthritis again at any time

### Cost-Benefit Analysis

| Approach            | Cost | Time to Recovery | Recurrence Risk                                |
|---------------------|------|------------------|------------------------------------------------|
| Immediate treatment | $900 | 3 months         | Can recur immediately                          |
| Delay treatment     | $900 | Delayed          | Can recur immediately after eventual treatment |
| No treatment        | $0   | Never            | Permanent stiffness                            |

!!! tip "Treatment Recommendation for Senior Horses"
Always treat arthritis for quality of life, but understand:

- Treatment manages symptoms, doesn't cure the underlying condition
- Senior horses (72+ months) may need repeated treatments
- Consider retirement or reduced workload for chronically arthritic horses
- Budget for ongoing treatment costs in aging horses

## Prevention

### Best Practices

**Exercise Management**

- **Regular, moderate exercise** - Keeps joints mobile without overwork
- **Avoid excessive work** - Heavy workload increases wear and tear
- **Consistent routine** - Prevents sudden stress on joints
- **Appropriate for age** - Reduce workload as horses age

**Footing and Environment**

- **Good footing** - Avoid hard, rocky, or uneven surfaces
- **Soft bedding** - Comfortable surfaces reduce joint stress
- **Level ground** - Minimize work on slopes
- **Avoid mud** - Deep mud strains joints

**Weight Management**

- **Maintain healthy weight** - Excess weight stresses joints
- **Body condition score** - Monitor older horses carefully
- **Appropriate nutrition** - Support joint health

**Health Management**

- **Breed for health** - High health genetics reduce arthritis risk by up to 75%
- **Joint supplements** - May support joint health (not reflected in game)
- **Regular monitoring** - Watch older horses for stiffness
- **Avoid overcrowding** - Keep below 80% capacity

**Age Considerations**

- **Accept aging process** - All horses develop arthritis eventually if they live long enough
- **Plan for senior care** - Budget for treatments in horses 48+ months
- **Reduce expectations** - Older horses need lighter workloads
- **Retirement planning** - Some horses need full retirement

### Risk Factors

| Factor                      | Risk Impact              | Mitigation                       |
|-----------------------------|--------------------------|----------------------------------|
| Poor health genetics (0.25) | +75%                     | Selective breeding program       |
| Overcrowding (>100%)        | +100% (doubles)          | Expand facilities or reduce herd |
| Advanced age (72+ months)   | +150% (2.5x base)        | Accept as natural aging          |
| Heavy historical workload   | Cumulative damage        | Age-appropriate work             |
| Poor footing                | Joint stress             | Improve surfaces                 |
| Previous injuries           | Accelerates degeneration | Prevent injuries                 |
| Obesity                     | Joint overload           | Weight management                |

**Highest Risk Scenario:**
Very old horse (72+ months) with poor health genetics and heavy historical workload = **nearly inevitable**

## Economic Impact

### Direct Costs

| Cost Component       | Amount   | Notes                   |
|----------------------|----------|-------------------------|
| Treatment (3 months) | $900     | Per episode             |
| Repeated treatments  | Variable | No immunity - can recur |
| Lost activity/work   | Minor    | 10% reduction           |
| Sale value reduction | 30%      | While sick              |

### Calculation Examples

**Senior horse with arthritis (first episode, treated):**

- Treatment: $900
- Activity loss: 3 months at 10% = minimal impact
- Recovers but NO immunity
- **Total cost: ~$900**

**Senior horse with recurring arthritis (3 episodes over 2 years):**

- Treatment 1: $900
- Treatment 2: $900 (can recur immediately)
- Treatment 3: $900 (no immunity between episodes)
- **Total cost: ~$2,700 over 2 years**

**Very old horse (72+ months) - expected lifetime arthritis management:**

- Base risk: 0.5% per month
- With average health: 0.5% × 12 months = 6% annual probability
- If horse lives 4 more years: ~24% chance of at least one episode
- If occurs 2-3 times: $1,800-2,700
- **Budget for recurring arthritis in senior horses**

**Untreated arthritic horse (permanent stiffness):**

- Treatment: $0
- Permanent 10% activity reduction
- 30% sale value reduction (if sold while sick)
- Reduced quality of life
- **May necessitate retirement or culling**

### Indirect Costs

- **Reduced work capacity** - Cannot perform as well
- **Training interruption** - Lost training time during treatment
- **Management time** - Monitoring and treating senior horses
- **Retirement costs** - Some horses need to be retired
- **Repeated treatments** - No immunity means ongoing costs
- **Quality of life** - Ethical considerations for chronic pain

## Management Strategy

!!! tip "Arthritis Management Protocol for Senior Horses"
**1. Accept the Chronic Nature**

- Arthritis has NO immunity period
- Senior horses (48+ months) are all at risk
- Plan for potential repeated treatments
- Budget $900 per episode, potentially multiple episodes
- Some horses need ongoing management

**2. Prevention (Limited Effectiveness)**

- Breed for high health genetics (reduces risk 75%)
- Maintain good footing and comfortable housing
- Appropriate exercise for age
- Avoid overcrowding (<80% capacity)
- Weight management
- However, all horses develop arthritis eventually if they live long enough

**3. Age-Specific Monitoring**

- Watch horses 48+ months for signs of stiffness
- Horses 72+ months have 2.5x higher risk
- Check for: reluctance to move, shortened stride, stiffness after rest
- Early treatment improves outcomes

**4. Treatment Decisions**

- Always treat for quality of life
- Understand treatment manages symptoms, doesn't cure
- Be prepared for recurrence (no immunity)
- Consider retirement if arthritis becomes chronic

**5. Post-Treatment Awareness**

- Horse recovers fully after 3 months treatment
- NO immunity period - can develop arthritis again immediately
- Continue monitoring closely
- Maintain good management practices
- Some horses need treatment multiple times

**6. Retirement Planning**

- Senior horses with recurring arthritis may need retirement
- Consider reduced workload for horses with multiple episodes
- Balance treatment costs vs. retirement
- Quality of life is primary consideration

**7. Long-Term Horse Management**

- Breed for high health genetics
- Plan for senior care costs ($900+ per year potential)
- Appropriate exercise throughout life reduces risk
- Good footing and housing throughout life
- Accept that very old horses (72+ months) will likely develop arthritis

**8. Economic Considerations**

- Recurring condition with no immunity
- Multiple treatments possible: 2-3 episodes = $1,800-2,700
- Factor into breeding decisions (cull vs. retire old horses)
- Some horses worth repeated treatment, others not
- Consider culling chronically arthritic horses with poor genetics

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding health genetics
- [Horse Management](horses.md) - Horse-specific husbandry
