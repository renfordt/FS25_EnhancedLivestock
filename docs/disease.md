# Disease System

Enhanced Livestock includes a realistic disease system that adds challenge and depth to animal management.

## How Diseases Work

### Infection
Animals can contract diseases through:

- **Random occurrence** - Based on age and health genetics
- **Transmission** - From infected animals in the same husbandry
- **Prerequisites** - Some diseases require specific conditions (e.g., lactation for mastitis)

### Disease Properties

Each disease has the following characteristics:

| Property | Description |
|----------|-------------|
| Transmission Rate | How easily it spreads between animals |
| Immunity Period | Months of immunity after recovery |
| Recovery Time | How long until the animal recovers |
| Fatality Curve | Time-based chance of death |
| Production Impact | Effect on outputs (milk, eggs, etc.) |
| Sale Value Impact | Reduction in animal sale price |

## Disease Types

### Infectious Diseases
- Spread between animals
- Higher transmission in crowded conditions
- Can be prevented with good husbandry

### Genetic Diseases
- Inherited from parents
- Some animals are carriers without symptoms
- Recessive genes may skip generations

### Age-Related Conditions
- More common in older animals
- May have higher fatality rates
- Often not transmissible

## Treatment

### How to Treat
Sick animals can be treated through the animal management interface:

1. Select the sick animal
2. Choose "Treat" option
3. Pay the treatment cost
4. Wait for recovery duration

### Treatment Properties

| Factor | Effect |
|--------|--------|
| Cost | Varies by disease (150-250 per treatment) |
| Duration | 1-3 months depending on disease |
| Success Rate | Affected by animal health genetics |

!!! warning "No Treatment Available"
    Some diseases (like genetic conditions) cannot be treated with medicine.

## Prevention

### Good Practices
- **Maintain health** - Well-fed, healthy animals resist disease better
- **Don't overcrowd** - More space reduces transmission
- **Quarantine new animals** - Separate new purchases initially
- **Monitor regularly** - Catch diseases early

### Genetics
Animals with high health genetics have:

- Lower chance of contracting diseases
- Better recovery rates
- Higher resistance to complications

## Economic Impact

Diseases affect your farm financially through:

| Impact | Description |
|--------|-------------|
| Treatment Costs | Direct veterinary expenses |
| Production Loss | Reduced or zero output while sick |
| Sale Value | Sick animals worth less at market |
| Deaths | Complete loss of animal value |
| Spread | Multiple animals can become infected |

## Available Diseases

Enhanced Livestock includes several diseases:

| Disease | Affected Animals |
|---------|-----------------|
| [Mastitis](mastitis.md) | Cattle, Sheep |
| [CVM](cvm.md) | Cattle |
| [Foot and Mouth](foot_and_mouth.md) | Cattle, Sheep, Pigs |
| [Porcine Epidemic Diarrhea](porcine_epidemic_diarrhea.md) | Pigs |
| [Avian Influenza](avian_influenza.md) | Chickens |

See individual disease pages for detailed information.
