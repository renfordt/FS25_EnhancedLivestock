# Enhanced Livestock Bridge Template

This directory contains templates and documentation for creating bridges to integrate external animal mods with Enhanced Livestock.

## What is a Bridge?

A **bridge** is a modular integration package that allows Enhanced Livestock to support animals from external mods or maps without hardcoding support. Bridges enable:

- Automatic detection of installed mods
- Loading of custom animal definitions
- Integration with EL features (weight, genetics, nutrition, diseases, insemination)
- Smart defaults generation for missing data
- Community-created mod support

## Bridge Directory Structure

```
mod_support/
└── YourModName/
    ├── metadata.xml           # Required: Bridge configuration
    ├── animals.xml            # Required: Animal definitions
    ├── fillTypes.xml          # Optional: Custom fill types
    ├── nutrition.xml          # Optional: Custom nutrition profiles
    └── translations/          # Optional: Translations
        └── translation_en.xml
```

## Creating a New Bridge

### Step 1: Create Bridge Directory

Create a new directory in `mod_support/` matching your mod name pattern:

```
mod_support/FS25_YourModName/
```

### Step 2: Create metadata.xml

The metadata file configures bridge behavior:

```xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<bridgeMetadata version="1">
    <mod name="FS25_YourModName"
         priority="10"
         author="Your Name" />

    <loading mode="merge">
        <!-- Options: merge, replace, extend -->
        <!-- merge: Merge with EL base animals, override vanilla -->
        <!-- replace: Replace all EL base animals -->
        <!-- extend: Add new species only -->
    </loading>

    <region areaCode="0" />
    <!-- Optional: Override area code for animal IDs -->
    <!-- 0=USA, 1=Europe, 2=Asia, 3=Australia, 4=Africa, 5=South America, 6=Germany, 7=France -->

    <resources>
        <fillTypes path="fillTypes.xml" />
        <!-- Can use $moddir$ references: -->
        <!-- <fillTypes path="$moddir$FS25_ExternalMod/xmls/fillTypes.xml" /> -->

        <animals path="animals.xml" />
        <nutrition path="nutrition.xml" optional="true" />
        <translations path="translations/translation_{LANG}.xml" optional="true" />
    </resources>

    <features>
        <weight generateDefaults="true" />
        <genetics generateDefaults="true" />
        <nutrition useGlobalDefaults="true" />
    </features>

    <defaults>
        <weight formula="navmesh" densityFactor="300" />
    </defaults>
</bridgeMetadata>
```

### Step 3: Create animals.xml

The animals file supports four operations:

#### Import: Load Animals from Another File

```xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<bridgeAnimals>
    <!-- Import base EL animals -->
    <import source="$moddir$FS25_EnhancedLivestock/xml/animals.xml" />

    <!-- Import from external mod -->
    <import source="$moddir$FS25_ExternalMod/xmls/animals/cow.xml" />
</bridgeAnimals>
```

#### Extend: Add Subtypes to Existing Species

```xml
<bridgeAnimals>
    <extend type="COW">
        <subType subType="COW_NEWBREED"
                 fillTypeName="COW_NEWBREED"
                 gender="female"
                 breed="NEWBREED">
            <weights minWeight="50.0" targetWeight="700.0" maxWeight="1400.0" />
            <visuals>
                <!-- Visual definitions -->
            </visuals>
            <reproduction minAgeMonth="12" durationMonth="10" minHealthFactor="0.75"/>
            <buyPrice>
                <key ageMonth="0" value="200"/>
                <key ageMonth="24" value="2500"/>
            </buyPrice>
            <input>
                <!-- Feed requirements -->
            </input>
            <output>
                <!-- Production outputs -->
            </output>
        </subType>
    </extend>
</bridgeAnimals>
```

#### Animal: Add New Species

```xml
<bridgeAnimals>
    <animal type="ALPACA" groupTitle="$l10n_animal_group_alpacas"
            statsBreeding="breedAlpacasCount"
            clusterClass="AnimalCluster"
            averageBuyAge="12"
            maxBuyAge="120">

        <configFilename>$moddir$FS25_YourMod/animals/alpaca/alpaca.xml</configFilename>
        <navMeshAgent height="1.5" radius="0.6" maxClimbMeters="1" maxSlope="25"/>
        <pasture sqmPerAnimal="50"/>
        <pregnancy average="1" max="2"/>

        <fertility>
            <key ageMonth="0" value="0"/>
            <key ageMonth="24" value="850"/>
            <key ageMonth="180" value="500"/>
        </fertility>

        <subType subType="ALPACA" fillTypeName="ALPACA" gender="female">
            <weights minWeight="10.0" targetWeight="70.0" maxWeight="120.0" />
            <!-- Full subtype definition -->
        </subType>
    </animal>
</bridgeAnimals>
```

#### Config Overrides: Update Visual Model Configs

**IMPORTANT**: Maps that add additional animal visual variants (e.g., duck models at indices 4-5 in Hof Bergmann's chicken config) must use configOverrides. Without this, the C++ engine only loads base game models and map-specific visual indices cause "invalid animal subtype" errors.

```xml
<bridgeAnimals>
    <!--
        Config overrides: update animalType.configFilename for types where the map's
        3D model config has additional models beyond the base game config.
    -->
    <configOverrides>
        <override type="CHICKEN" configFilename="character/animals/domesticated/chicken/husbandryAnimalsChicken.xml"/>
    </configOverrides>
</bridgeAnimals>
```

**When to use**:
- Your map adds new 3D animal models beyond base game (e.g., ducks in a chicken coop)
- You're getting "invalid animal subtype X" errors in the log
- Visual indices in your subtypes reference models not in the base game config

**Path resolution**:
- Paths are relative to your map mod directory
- Use `character/animals/...` NOT `$moddir$YourMod/character/animals/...`
- configOverrides are applied BEFORE loading subtypes

#### Override: Modify Existing Definitions

```xml
<bridgeAnimals>
    <!-- Override specific subtype properties -->
    <override type="COW" subType="COW_HOLSTEIN">
        <weights targetWeight="720.0" maxWeight="1300.0" />
    </override>

    <!-- Override type-level properties -->
    <override type="COW">
        <averageBuyAge>15</averageBuyAge>
    </override>
</bridgeAnimals>
```

### Step 4: Create fillTypes.xml (Optional)

Define custom fill types for your animals:

```xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<map xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:noNamespaceSchemaLocation="$data/shared/xml/schema/fillTypes.xsd">
    <fillTypes>
        <fillType name="ALPACA" title="$l10n_fillType_alpaca" showOnPriceTable="false">
            <physics massPerLiter="70.0" maxPhysicalSurfaceAngle="0"/>
            <economy pricePerLiter="500"/>
            <image hud="$moddir$FS25_YourMod/hud/fillTypes/hud_fill_alpaca.png"/>
        </fillType>

        <fillType name="ALPACA_MALE" title="$l10n_fillType_alpaca_male" showOnPriceTable="false">
            <physics massPerLiter="90.0" maxPhysicalSurfaceAngle="0"/>
            <economy pricePerLiter="600"/>
            <image hud="$moddir$FS25_YourMod/hud/fillTypes/hud_fill_alpaca.png"/>
        </fillType>
    </fillTypes>

    <fillTypeCategories>
        <fillTypeCategory name="ANIMAL">ALPACA ALPACA_MALE</fillTypeCategory>
    </fillTypeCategories>
</map>
```

### Step 5: Create nutrition.xml (Optional)

Define custom nutrition requirements for new species:

```xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<nutrition>
    <feeds>
        <!-- Bridge-specific feeds -->
        <feed fillType="ALPACA_FEED" category="TMR" energy="11.5" protein="160"
              dryMatterPercent="0.90" fiber="120" litersPerKgDM="1.1" />
    </feeds>

    <lifeStages>
        <species name="ALPACA">
            <stage name="CRIA" minAge="0" maxAge="6" gender="any"
                   condition="none" priority="10"
                   dmiPercent="5.0" energyPerKgBW075="0.85" proteinPerKgBW075="11.0" />

            <stage name="ADULT" minAge="7" maxAge="999" gender="any"
                   condition="none" priority="5"
                   dmiPercent="3.5" energyPerKgBW075="0.65" proteinPerKgBW075="7.5" />

            <stage name="PREGNANT" minAge="24" maxAge="999" gender="female"
                   condition="pregnant" priority="15"
                   dmiPercent="4.0" energyPerKgBW075="0.75" proteinPerKgBW075="9.0" />
        </species>
    </lifeStages>

    <pregnancy>
        <species name="ALPACA">
            <trimester number="1" energyMultiplier="1.1" proteinMultiplier="1.15" />
            <trimester number="2" energyMultiplier="1.2" proteinMultiplier="1.25" />
            <trimester number="3" energyMultiplier="1.4" proteinMultiplier="1.45" />
        </species>
    </pregnancy>
</nutrition>
```

## Smart Defaults Generation

If your bridge animals are missing EL-specific features, Enhanced Livestock will generate intelligent defaults:

### Weight Defaults

If weights are not specified, they are calculated from navMesh dimensions:

```
targetWeight = navMeshAgent.height × navMeshAgent.radius × densityFactor
minWeight = targetWeight × 0.15  (baby)
maxWeight = targetWeight × 1.5   (obese)
```

Default densityFactor: 300 kg/m³ (configurable in metadata.xml)

### Genetics Defaults

If not specified, balanced genetics are generated:

```
health = random(0.8, 1.2)
fertility = random(0.8, 1.2)
metabolism = random(0.8, 1.2)
quality = random(0.8, 1.2)
productivity = random(0.8, 1.2)
```

### Nutrition Defaults

If nutrition profiles are missing, similar species are used as fallbacks:

- DUCK → CHICKEN
- GOOSE → CHICKEN
- RABBIT → SHEEP
- ALPACA → SHEEP

## Loading Priority

When multiple sources define the same property, this precedence applies (highest to lowest):

1. Bridge configOverrides (`<configOverrides>` tag - applied first, before subtypes load)
2. Bridge override (`<override>` tag - applied after subtypes load)
3. Bridge extend (new subtypes via `<extend>`)
4. Bridge animal (new species via `<animal>`)
5. Base EL definition (from `xml/animals.xml`)
6. Generated defaults (from bridge_utils.lua)

## Testing Your Bridge

1. **Install your external mod** in FS25 mods folder
2. **Copy your bridge directory** to `FS25_EnhancedLivestock/mod_support/YourModName/`
3. **Update registry.lua** to detect your mod:
   ```lua
   local availableBridges = {
       {name = "FS25_YourModName", path = "YourModName"}
   }
   ```
4. **Load FS25** and check the log for bridge loading messages
5. **Place an animal husbandry** and verify your animals appear
6. **Test EL features**: weight tracking, genetics, breeding, nutrition

## Example Bridges

See existing bridges for reference:

- **FS25_AnimalPackage**: Imports 66 breed variants from external mod using `<import>` tags
- **FS25_HofBergmann**: Adds exotic species (duck, goose, rabbit, cat) using `<animal>` tags

## Support

For questions or issues with bridge development, please open an issue on the Enhanced Livestock GitHub repository.

## License

Bridge templates and documentation are provided as-is for community use. Bridges you create are your own work.
