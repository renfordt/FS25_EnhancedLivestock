# Productions

Enhanced Livestock modifies animal production to be more realistic and dependent on animal conditions.

## Production Types

### Milk Production (Cattle)

Milk production is tied to the lactation cycle:

| Condition | Effect |
|-----------|--------|
| Not Lactating | No milk production |
| Early Lactation | Rising production |
| Peak Lactation | Maximum output |
| Late Lactation | Declining production |

!!! info "Lactation Requirement"
    Cows only produce milk when lactating. Lactation begins after giving birth and continues until the cow is dried off or becomes pregnant again.

#### Milk Output by Age

| Age Range | Production Level |
|-----------|-----------------|
| 0-12 months | None |
| 12-36 months | Increasing |
| 36-72 months | Peak production |
| 72-120 months | Declining |

### Wool Production (Sheep)

Wool production is seasonal:

| Season | Production |
|--------|------------|
| Spring/Summer | Active growth |
| Fall/Winter | Reduced/None |

Shearing is only productive during warm months when wool has grown sufficiently.

### Egg Production (Chickens)

Chicken egg production is affected by:

- Age (peak at 6-18 months)
- Health status
- Genetics (productivity trait)
- Nutrition

### Manure and Liquid Manure

All animals produce manure and liquid manure based on:

- Animal size
- Food consumption
- Age

| Animal Type | Relative Output |
|-------------|----------------|
| Cattle | High |
| Pigs | Medium-High |
| Sheep/Goats | Medium |
| Horses | Medium |
| Chickens | Low |

## Factors Affecting Production

### Genetics

The **Productivity** genetic trait directly affects output:

| Productivity Level | Output Modifier |
|-------------------|-----------------|
| 50% | Half production |
| 100% | Normal production |
| 150% | 1.5x production |

### Health

Sick animals have reduced or zero production:

| Condition | Effect |
|-----------|--------|
| Healthy | Normal production |
| Minor illness | Reduced output |
| Major illness | Severely reduced or zero |

### Nutrition

Proper feeding is essential:

| Feeding Level | Effect |
|--------------|--------|
| Well-fed | Optimal production |
| Underfed | Reduced production |
| Starving | No production |

### Weight

Animals at healthy weight produce optimally:

| Weight Status | Effect |
|--------------|--------|
| Ideal weight | Full production |
| Underweight | Reduced production |
| Overweight | Slightly reduced production |

## Production by Animal Type

### Cattle

| Output | Description |
|--------|-------------|
| Milk | From lactating cows only |
| Manure | All cattle |
| Liquid Manure | All cattle |

### Pigs

| Output | Description |
|--------|-------------|
| Manure | All pigs |
| Liquid Manure | All pigs |

### Sheep

| Output | Description |
|--------|-------------|
| Wool | Seasonal (warm months) |
| Milk | From lactating ewes |
| Manure | All sheep |
| Liquid Manure | All sheep |

### Goats

| Output | Description |
|--------|-------------|
| Milk | From lactating does |
| Manure | All goats |
| Liquid Manure | All goats |

### Horses

| Output | Description |
|--------|-------------|
| Manure | All horses |

!!! note "Horse Production"
    Horses are primarily for riding and training rather than production.

### Chickens

| Output | Description |
|--------|-------------|
| Eggs | From hens |
| Manure | All chickens |

## Pallet Production

Some husbandries can produce pallets of goods:

- **Egg pallets** from chicken coops
- **Wool pallets** from sheep pastures

Production is affected by the same factors as direct output.
