# Clostridial Disease (Enterotoxemia / Pulpy Kidney)

Clostridial diseases are caused by soil bacteria (*Clostridium perfringens*) releasing deadly toxins in the gut, often causing **sudden death** in the healthiest, fastest-growing lambs. With a catastrophic 70% immediate fatality rate, this is one of the most deadly diseases in the game. They are entirely preventable with vaccination.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Sheep only |
| Transmission Rate | None (not contagious) |
| Immunity Period | 12 months |
| Recovery Time | With treatment only (no natural recovery) |
| Sale Value Impact | 70% reduction (0.3 multiplier) |

!!! danger "Sudden Death - 70% Immediate Fatality"
    Clostridial diseases have the highest immediate fatality rate of any sheep disease (70%). The first sign is often finding a dead lamb. Treatment must be immediate or death is nearly certain.

## Infection Risk

### Base Probability

Young lambs are at highest risk:

| Age (months) | Base Probability |
|--------------|------------------|
| 0-5 | 0.1% per month |
| 6+ | 0.05% per month |

**Health Genetics Modifier**
- Health 1.75: 0.025% (75% reduction)
- Health 1.0: 0.1%
- Health 0.25: 0.175% (75% increase)

**Overcrowding Modifier**: >100%: 2.0x | 80-100%: 1.3x | <50%: 0.8x

### No Transmission

Not contagious - bacteria live in soil and activate under specific gut conditions (rich feed, rapid growth).

## Symptoms and Effects

| Output Type | Modifier |
|-------------|----------|
| Solid Manure | 50% |

### Fatality

| Time | Fatality Rate |
|------|---------------|
| Month 0 | **70%** |

!!! danger "Sudden Death Syndrome"
    70% die in the first month. Most deaths occur within hours of onset - faster than any other disease. Animals found dead were often the healthiest in the flock.

## Disease Progression

1. **Active (Untreated)**: Toxemia, 70% immediate death, 70% sale value reduction, no natural recovery
2. **Being Treated**: $200 for 1 month, after treatment: 12 months immunity
3. **Immune**: Normal production, 12-month protection

**No Natural Recovery** - Treatment mandatory or death nearly certain.

## Treatment

| Property | Value |
|----------|-------|
| Cost | $200 |
| Duration | 1 month |
| Immunity | 12 months |

!!! tip "Treatment Likely Futile"
    With 70% dying immediately, most lambs are found dead. If caught alive, treat immediately - but survival is unlikely (30% chance).

## Prevention

**Vaccination (Critical)**
- Most effective prevention
- Vaccinate ewes pre-breeding (immunity passes to lambs)
- Booster vaccination for lambs at marking

**Feed Management**
- **Avoid sudden rich pasture** - Lush spring grass is major trigger
- **Gradual diet changes** - Transition over 7-10 days minimum
- **Monitor fast-growers** - Best lambs are highest risk

**Genetic Selection**
- Breed for health genetics
- Track which ewes produce susceptible lambs

### Risk Factors

| Factor | Impact |
|--------|--------|
| Sudden rich pasture access | Very high |
| Fastest-growing lambs | High - paradoxically targets best animals |
| Grain overload | High |
| No vaccination | Critical |

## Economic Impact

**Single lamb with clostridial disease:**
- Treatment: $200
- Death risk: **70%**
- Expected cost: (0.3 × $200) + (0.7 × $100 lamb) = $130

**Flock of 50 lambs, 2 infected:**
- Treatment: 2 × $200 = $400
- Deaths: 2 × 70% = 1.4 lambs = $140
- **Total: $540**

**Prevention (vaccination):**
- Cost: 50 lambs × $5 vaccine = $250
- Prevents nearly all cases
- **$250 prevention vs $540+ treatment/deaths**

## Management Strategy

!!! tip "Clostridial Prevention Protocol"
    **1. Vaccinate** - Single most important measure
       - Vaccinate ewes before breeding
       - Lambs at marking/weaning
       - Annual boosters

    **2. Gradual Feed Changes**
       - Never sudden access to lush pasture
       - Transition over 7-10 days
       - Most critical in spring

    **3. Monitor Best Lambs**
       - Fast growers are highest risk
       - Check twice daily during risk periods
       - Early treatment critical but often too late

    **4. Accept Reality**
       - 70% fatality means most die before treatment possible
       - Prevention through vaccination is ONLY reliable strategy
       - Even with treatment, expect 70% mortality

    **5. Immediate Action if Seen Alive**
       - Treat at first signs (staggering, convulsions, bloating)
       - $200 treatment gives 30% survival chance
       - Better than 0% survival if untreated

## See Also

- [Disease System Overview](disease.md)
- [Genetics Guide](genetics.md)
- [Sheep Management](sheep.md)
