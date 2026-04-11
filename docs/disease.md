# Disease System

Enhanced Livestock includes a comprehensive disease system that simulates realistic animal health challenges and adds strategic depth to animal management.

## How Diseases Work

### Disease Acquisition

Animals can contract diseases through three mechanisms:

#### 1. Random Occurrence
- **Age-based probability** - Each disease has an age-dependent probability curve
- **Health genetics modifier** - Animals with better health genetics (1.75) have 75% lower disease risk, while animals with poor health (0.25) have 75% higher risk
- **Seasonal modifiers** - Some diseases are more common in specific seasons (e.g., equine asthma is 1.5x more likely in winter)
- **Overcrowding effects**:
  - >100% capacity: 2.0x disease probability
  - 80-100% capacity: 1.3x disease probability
  - <50% capacity: 0.8x disease probability
- **Prerequisites** - Certain diseases only occur under specific conditions (e.g., mastitis requires lactation, twin lamb disease requires pregnancy)

#### 2. Transmission Between Animals
- Contagious diseases spread between animals in the same husbandry
- Transmission chance = base transmission rate × (infected count / total animals) × modifiers
- **Transmission modifiers**:
  - Health genetics (same as occurrence)
  - Overcrowding (same as occurrence)
  - **Herd immunity**: When >70% of susceptible animals are immune, transmission is reduced by 90%

#### 3. Genetic Inheritance
- Some diseases (e.g., CVM) are genetic and inherited from parents
- Animals can be carriers (1 affected gene) or fully affected (2 affected genes)
- Genetic diseases may also appear in purchased animals based on `saleChance`
- Inheritance follows Mendelian genetics with recessive or dominant patterns

### Disease States

An animal with a disease can be in one of four states:

1. **Active** - Sick, not being treated
   - Full production penalties apply
   - Subject to fatality checks each month
   - Can naturally recover if disease has a recovery period

2. **Being Treated** - Receiving veterinary treatment
   - Treatment cost paid monthly
   - After treatment duration completes, becomes immune
   - Production penalties still apply during treatment

3. **Immune** - Recovered or treated successfully
   - No production penalties
   - Cannot contract the same disease again
   - Immunity period counts down each month
   - After immunity expires, disease record is removed

4. **Carrier** - Genetic disease carrier (1 affected gene, recessive disease)
   - No symptoms or production penalties by default
   - May have different output modifiers (e.g., CVM carriers produce 1.5x milk)
   - Can pass disease to offspring

## Disease Effects

### Production Impact

Diseases modify animal outputs through several mechanisms:

#### Output Modifiers
Each disease can affect specific fill types:
- **Milk production** - Often reduced or eliminated (0-0.7x normal)
- **Egg production (pallets)** - Reduced for chicken diseases
- **Wool production (pallets)** - Reduced for sheep diseases
- **Manure production** - Usually reduced (0.3-0.9x normal)
- **Liquid manure** - Often increased (1.5-4x normal) for digestive diseases

#### Weight Gain Reduction
Many diseases include a `weightGain` modifier (0.3-0.85x normal) that slows growth and reduces final sale weight.

#### Fertility Impact
Some diseases (e.g., BVD, PRRS, foot and mouth) reduce fertility:
- 0.3-0.5x normal fertility rate
- Twin lamb disease completely prevents reproduction (0.0x)

### Sale Value Reduction

Each disease has a `value` modifier that reduces the animal's sale price:
- Minor diseases: 0.75-0.85 (15-25% reduction)
- Moderate diseases: 0.5-0.7 (30-50% reduction)
- Severe diseases: 0.1-0.4 (60-90% reduction)

This value is multiplied by the animal's base sale price.

### Fatality Risk

Most diseases include a time-based fatality curve:
- Fatality chance is checked each month
- Risk typically highest at onset (0-80% in month 0)
- Usually decreases over time
- Some diseases (e.g., genetic conditions) may be fatal immediately or have increasing risk
- Animals with genetic carrier status are not subject to fatality

## Treatment

### Available Treatments

Not all diseases can be treated:

#### Treatable Diseases
Most infectious diseases have treatment options:
- **Treatment cost**: $30-500 per month (varies by disease)
- **Treatment duration**: 1-3 months
- After treatment completes, animal becomes immune for the immunity period

#### Untreatable Diseases
Some diseases have no medical treatment available:
- Genetic diseases (CVM, Marek's)
- African Swine Fever (ASF)
- Johne's Disease
- Arthritis (chronic condition requiring ongoing management)

### Natural Recovery

Many diseases can recover naturally without treatment:
- Each month after the recovery period, 75% chance of natural recovery
- Recovery grants the same immunity period as treatment
- Saves treatment costs but animal remains sick longer
- Subject to fatality risk during recovery period

### Treatment Process

To treat a sick animal:
1. Select the animal in the animal management interface
2. Click the "Treat" button in the disease dialog
3. Treatment cost is charged immediately via the `MEDICINE` finance type
4. Treatment cost is paid each month for the treatment duration
5. After duration completes, animal becomes immune
6. Production penalties remain until treatment completes

## Prevention Strategies

### Husbandry Management

**Avoid Overcrowding**
- Keep animal count below 80% of maximum capacity
- Overcrowding at >100% doubles disease risk
- Under-capacity (<50%) reduces disease risk by 20%

**Monitor Herd Immunity**
- When >70% of animals are immune to a disease, transmission drops by 90%
- Treated animals provide herd immunity for the immunity period
- Strategic treatment can protect the entire herd

**Seasonal Awareness**
Diseases with seasonal patterns:
- **Winter-prone** (1.5x): Equine asthma, infectious bronchitis (chickens)
- **Spring/autumn-prone** (1.5x): Foot rot, internal parasites, coccidiosis
- **Summer-prone** (2.0x): Flystrike
- **Summer-resistant** (0.5x): BRD, equine asthma

### Genetic Selection

**Health Genetics**
- Animals with high health genetics (1.5-1.75) have significantly lower disease risk
- Health modifier formula: `2.0 - health_value`
  - Health 1.75 → 0.25x disease probability (75% reduction)
  - Health 1.0 → 1.0x disease probability (average)
  - Health 0.25 → 1.75x disease probability (75% increase)

**Genetic Disease Screening**
- Check purchased animals for genetic diseases
- Carriers of recessive diseases (1 gene) show no symptoms
- Two carriers can produce affected offspring (25% chance)
- Cull or avoid breeding carriers to eliminate genetic diseases

### Quarantine Practices

**New Animal Isolation**
- Monitor purchased animals for several months
- Many diseases have onset probabilities in first months
- Genetic diseases may manifest early
- Separate housing prevents transmission to existing herd

## Disease Categories

### Infectious Diseases
**Characteristics:**
- Spread between animals (transmission rate 0.03-0.2)
- Affected by overcrowding
- Can be prevented with good husbandry
- Usually treatable

**Examples:** Mastitis, Foot and Mouth, BRD, PRRS, Avian Influenza

### Genetic Diseases
**Characteristics:**
- Inherited from parents
- Carrier animals may show no symptoms
- Cannot be cured, only managed
- Affects breeding strategy

**Examples:** CVM (cattle), Marek's Disease (chickens)

### Age-Related Conditions
**Characteristics:**
- Probability increases with age
- Often chronic conditions
- May not be transmissible
- Higher incidence in older animals

**Examples:** Arthritis (horses 48+ months), Laminitis (horses 36+ months), Johne's (cattle 24+ months)

### Seasonal Diseases
**Characteristics:**
- Higher occurrence in specific seasons
- Environmental factors influence spread
- Predictable patterns allow prevention

**Examples:** Flystrike (summer), Equine Asthma (winter), Foot Rot (spring/autumn)

## Economic Impact

### Direct Costs

| Cost Category | Impact |
|---------------|--------|
| **Treatment** | $30-500 per month per animal |
| **Lost Production** | 0-100% reduction in milk, eggs, wool |
| **Sale Value Loss** | 10-90% reduction in market price |
| **Deaths** | Complete loss of animal investment |
| **Cascade Effects** | Multiple animals infected = multiplied costs |

### Indirect Costs

| Factor | Impact |
|--------|--------|
| **Breeding Delays** | Reduced fertility extends generation time |
| **Genetic Culling** | Removing carriers reduces herd quality |
| **Management Time** | Monitoring and treating sick animals |
| **Feed Waste** | Sick animals eat but produce less |

### Disease Outbreak Scenarios

**Minor Outbreak** (1-2 animals, treatable disease)
- Treatment cost: $200-500 total
- Production loss: Minimal if treated quickly
- Recovery: 1-3 months

**Major Outbreak** (>20% herd, contagious disease)
- Treatment cost: $2,000-10,000+ depending on herd size
- Production loss: Significant reduction for several months
- Herd immunity benefits after recovery

**Fatal Outbreak** (ASF, untreated severe disease)
- Death rate: 80-95% for severe diseases
- Total loss: Most of herd value
- Prevention: Only option for untreatable diseases

## Complete Disease List

### Multi-Species Diseases

| Disease | Animals | Transmission | Treatment Cost | Sale Value |
|---------|---------|--------------|----------------|------------|
| **Foot and Mouth** | Cattle, Sheep, Pigs | 0.10 | $250 | 0.50 |
| **Mastitis** | Cattle, Sheep | 0.05 | $200 | 0.85 |
| **Foot Rot** | Cattle, Sheep | 0.04 | $200 | 0.65 |

### Cattle Diseases

| Disease | Transmission | Treatment Cost | Sale Value | Notes |
|---------|--------------|----------------|------------|-------|
| **CVM** | Genetic | None | 0.75 | Fatal to affected, carriers boost milk 1.5x |
| **BRD** | 0.08 | $300 | 0.60 | Seasonal (winter) |
| **BVD** | 0.06 | $350 | 0.55 | Severe fertility impact (0.3x) |
| **Johne's** | 0.03 | None | 0.30 | Chronic, progressive |

### Horse Diseases

| Disease | Transmission | Treatment Cost | Sale Value | Notes |
|---------|--------------|----------------|------------|-------|
| **Colic** | None | $500 | 0.50 | Emergency condition |
| **Laminitis** | None | $400 | 0.60 | Age-related (36+ months) |
| **Arthritis** | None | $300 | 0.70 | Old age (48+ months) |
| **EGUS** | None | $250 | 0.75 | Stress-related |
| **Equine Asthma** | None | $200 | 0.70 | Seasonal (winter) |

### Pig Diseases

| Disease | Transmission | Treatment Cost | Sale Value | Notes |
|---------|--------------|----------------|------------|-------|
| **PED** | 0.075 | $150 | 0.65 | High mortality in piglets (85%) |
| **PRRS** | 0.10 | $250 | 0.50 | Reproductive and respiratory |
| **ASF** | 0.15 | None | 0.10 | Extremely fatal (95% in 1 month) |
| **Swine Influenza** | 0.12 | $150 | 0.75 | Mild, rapid recovery |
| **Greasy Pig** | 0.05 | $100 | 0.60 | Young pigs (0-6 months) |
| **Scours** | 0.06 | $100 | 0.60 | High mortality in young (50%) |

### Sheep Diseases

| Disease | Transmission | Treatment Cost | Sale Value | Notes |
|---------|--------------|----------------|------------|-------|
| **Internal Parasites** | 0.04 | $50 | 0.65 | Seasonal (spring/summer) |
| **Flystrike** | None | $150 | 0.40 | Summer only (2.0x) |
| **Clostridial** | None | $200 | 0.30 | Highly fatal (70% immediate) |
| **Twin Lamb Disease** | None | $200 | 0.50 | Pregnancy required, prevents reproduction |

### Chicken Diseases

| Disease | Transmission | Treatment Cost | Sale Value | Notes |
|---------|--------------|----------------|------------|-------|
| **Avian Influenza** | 0.20 | None | 0.25 | Highly fatal (65% initially) |
| **Coccidiosis** | 0.10 | $30 | 0.55 | Young birds, seasonal (spring) |
| **Marek's** | 0.08 | None | 0.20 | Genetic, progressive fatality |
| **Newcastle** | 0.15 | $40 | 0.30 | High initial mortality (40%) |
| **Infectious Bronchitis** | 0.15 | $30 | 0.60 | Seasonal (winter) |

## Configuration

Disease system can be configured through mod settings:

- **Disease Enabled** - Toggle entire disease system on/off
- **Disease Chance Multiplier** - Global modifier for all disease probabilities

These settings are synchronized in multiplayer and affect all farms.
