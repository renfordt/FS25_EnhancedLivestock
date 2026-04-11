# CVM (Complex Vertebral Malformation)

CVM is a lethal genetic disease in cattle that causes severe developmental defects. Affected calves typically die within the first month of life. Interestingly, carrier animals (heterozygous for the CVM gene) produce significantly more milk, which historically led to the gene's prevalence in dairy herds.

## Overview

| Property | Value |
|----------|-------|
| Affected Animals | Cattle only |
| Type | Genetic (Recessive) |
| Transmission | Genetic inheritance only (not contagious) |
| Immunity Period | Not applicable (genetic) |
| Sale Value Impact | 25% reduction (0.75 multiplier) for affected animals |

## Genetic Inheritance

### Mendelian Genetics

CVM follows a recessive inheritance pattern with two alleles per animal:

| Genotype | Genes | Status | Symptoms | Production |
|----------|-------|--------|----------|------------|
| Normal (NN) | 0 affected | Healthy | None | Normal |
| Carrier (Nc) | 1 affected | Carrier | None | +50% milk |
| Affected (cc) | 2 affected | Affected | Lethal | Dies young |

### Breeding Outcomes

| Parent 1 | Parent 2 | Offspring Results |
|----------|----------|-------------------|
| Normal × Normal | 100% Normal | No CVM in herd |
| Normal × Carrier | 50% Normal, 50% Carrier | No affected calves |
| Carrier × Carrier | 25% Normal, 50% Carrier, 25% Affected | **Risk of affected calves** |
| Carrier × Affected | 50% Carrier, 50% Affected | High risk |
| Affected × Affected | 100% Affected | All offspring die |

!!! danger "Critical Breeding Rule"
    **NEVER breed two carriers together.** This results in a 25% chance of producing an affected calf that will die within a month.

### Gene Transmission Mechanics

Each parent passes one gene to offspring:

**Example: Carrier × Carrier**
1. Each parent has 1 affected gene (50% chance to pass)
2. Offspring possibilities:
   - 25% receive 0 affected genes (Normal)
   - 50% receive 1 affected gene (Carrier)
   - 25% receive 2 affected genes (Affected - lethal)

## Disease Manifestation

### In Affected Animals (2 genes)

**Probability of Manifestation**
- Does not "contract" the disease - it's present from birth
- 100% of animals with 2 affected genes are symptomatic
- No age-based probability - genetic

**Fatality Curve**

| Time After Birth | Fatality Rate | Cumulative Deaths |
|------------------|---------------|-------------------|
| Birth (0 months) | 95% | 95% dead |
| 1 month | 100% (of survivors) | 100% dead |

!!! danger "Near-Certain Death"
    Affected calves have a 95% chance of dying immediately at birth, and the remaining 5% die within the first month. There is no survival beyond 1 month.

### In Carrier Animals (1 gene)

**Status: Asymptomatic Carrier**
- No health penalties
- No production penalties (actually **boosted** milk production)
- Cannot die from CVM
- Can pass the gene to offspring
- 50% chance to pass affected gene to each offspring

## Carrier Benefits

### Enhanced Milk Production

Carriers of CVM show dramatically increased milk production:

| Animal Type | Output | Modifier |
|-------------|--------|----------|
| Carrier Cow | Milk | **+50%** (1.5x normal) |

!!! note "Historical Context"
    This milk production boost is why CVM became widespread in dairy cattle before genetic testing was available. Farmers unknowingly selected for the carrier genotype because these cows produced more milk.

### The CVM Dilemma

| Keep Carriers? | Advantages | Disadvantages |
|----------------|------------|---------------|
| **Yes** | • +50% milk from carriers<br>• Higher overall herd production<br>• Profitable if managed correctly | • Risk of affected calves<br>• Requires careful breeding management<br>• Lower sale value for carriers |
| **No** | • Zero risk of affected calves<br>• Cleaner genetics<br>• Full sale value | • -50% milk potential<br>• Lower herd productivity |

## Detection and Identification

### How to Identify Carriers

Carriers show no symptoms, so you must rely on:

1. **Disease Status Display**
   - View animal details in the animal management screen
   - Carriers show "CVM (Carrier)" status
   - Affected animals show "CVM (Active)" status

2. **Pedigree Analysis**
   - If a calf is affected (or dies from CVM), both parents are carriers
   - Track which animals produce affected offspring

3. **Purchase History**
   - 0.5% of animals purchased from dealers are carriers (saleChance="0.005")
   - Check all purchased cattle immediately

4. **Breeding Records**
   - Two carriers produce 25% affected calves on average
   - Pattern of affected calves reveals carrier parents

### Genetic Testing at Purchase

!!! tip "Always Check New Cattle"
    - Open animal details for every purchased cow
    - Look for "CVM (Carrier)" in disease section
    - Decide whether to keep or sell based on breeding strategy

## Treatment

**No treatment exists for CVM:**

| Treatment Type | Available |
|----------------|-----------|
| Medicine | No |
| Surgery | No |
| Gene therapy | No |

**Management Options:**
1. **Cull affected calves** - They will die anyway
2. **Track carrier status** - Know your herd genetics
3. **Controlled breeding** - Prevent carrier × carrier matings
4. **Gradual elimination** - Breed carriers only with normal animals to phase out the gene

## Breeding Strategies

### Strategy 1: Eliminate CVM from Herd

**Goal:** Remove the gene completely

**Method:**
1. Identify all carriers
2. Either:
   - **Option A:** Cull all carriers (immediate but costly)
   - **Option B:** Breed carriers only with known normal animals, cull carrier offspring

**Timeline:** 1-2 generations to eliminate

**Result:**
- No risk of affected calves
- Lower milk production
- Cleaner genetics for sales

### Strategy 2: Maintain Carriers for Production

**Goal:** Keep milk production bonus while minimizing affected calves

**Method:**
1. Identify all carriers and normal animals
2. **NEVER** breed carrier × carrier
3. Breed carriers with normal animals:
   - 50% carrier offspring (keep for high milk production)
   - 50% normal offspring (safe breeding stock)
4. Breed normal × normal for safe breeding pairs

**Requirements:**
- Meticulous record-keeping
- Separate breeding groups
- Accept 25% calf loss if mistakes happen

**Result:**
- High milk production from carriers
- Controlled risk
- Complex management

### Strategy 3: One-Generation Profit

**Goal:** Maximize short-term milk profit, then eliminate

**Method:**
1. Purchase carriers deliberately (check for +50% milk)
2. Use carriers for milk production only
3. Do not breed carriers at all
4. Replace with normal animals as carriers age

**Result:**
- Maximum milk output
- No genetic risk (no breeding)
- Requires continuous cattle purchases

## Economic Analysis

### Cost of an Affected Calf

| Cost Component | Amount |
|----------------|--------|
| Breeding costs | (AI or bull maintenance) |
| Pregnancy duration | ~9 months of cow care |
| Lost calf value | $500-1,500 (complete loss) |
| Mother's production loss | Pregnancy and failed lactation cycle |
| **Total Loss** | **~$1,000-2,000 per affected calf** |

### Value of a Carrier

**Milk Production Benefit:**
- Carrier produces 1.5x milk
- Average cow: ~$100/month milk
- Carrier cow: ~$150/month milk
- **Bonus: +$50/month**

**Over 5-year productive life:**
- Additional milk revenue: +$50/month × 60 months = **+$3,000**

**Risk:**
- If bred with another carrier: 25% chance of affected calf (-$1,500)
- If bred with normal: 0% chance of affected calf
- **Expected value depends on breeding management**

### Break-Even Analysis

**Carrier × Carrier breeding:**
- 1 in 4 calves affected = -$1,500 loss
- Extra milk from carrier parent: +$3,000 over lifetime
- **Net:** Profitable if you accept the losses, but risky

**Carrier × Normal breeding:**
- 0% affected calves = $0 loss
- Extra milk from carrier parent: +$3,000
- 50% carrier offspring = another +$3,000 potential
- **Net:** Highly profitable with no risk

!!! tip "Optimal Strategy"
    Keep carriers, breed them ONLY with known normal animals. This captures the milk production bonus while eliminating the risk of affected calves.

## Management Protocol

### For New Players

!!! tip "Simple CVM Management"
    1. **Check all purchased cattle** for carrier status
    2. **Sell any carriers** immediately
    3. **Only breed non-carriers**
    4. **Avoid the complexity** until you understand the system

### For Advanced Players

!!! tip "Profit-Maximizing CVM Management"
    1. **Identify and track** all carriers in your herd
    2. **Create breeding groups:**
       - Group A: Normal × Normal (safe breeding)
       - Group B: Carrier × Normal (production breeding)
       - **NEVER:** Carrier × Carrier
    3. **Mark carriers** with a naming convention (e.g., "Bessie-C")
    4. **Monitor births** - affected calf means both parents are carriers
    5. **Make deliberate decisions** about keeping/culling carrier offspring
    6. **Document pedigrees** to track gene flow

## Configuration

CVM is enabled/disabled by the global disease system setting:

- **Disease System Enabled**: CVM functions normally
- **Disease System Disabled**: No genetic diseases, all animals healthy

## See Also

- [Disease System Overview](disease.md) - Complete disease mechanics
- [Genetics Guide](genetics.md) - Understanding inheritance
- [Breeding Guide](breeding.md) - Breeding strategies
- [Cattle Management](cattle.md) - Cattle-specific husbandry
