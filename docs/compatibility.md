# Compatibility & Requirements

Enhanced Livestock is designed to work seamlessly with Farming Simulator 25 while integrating with select companion mods to provide an enriched animal husbandry experience.

## Game Requirements

To use Enhanced Livestock, ensure your environment meets the following criteria:

*   **Game:** Farming Simulator 25 (PC/Mac).
*   **Multiplayer:** Fully supported on dedicated servers and peer-to-peer sessions.
*   **Save Compatibility:** Can be added to existing savegames.
*   **Platform:** PC, macOS, and Linux only.

!!! info "Platform Limitation"
    Enhanced Livestock requires Lua scripting, which is not supported for modding on consoles (PlayStation/Xbox). Therefore, this mod is exclusive to the PC/Mac versions of Farming Simulator 25.

## Optional Dependencies

While Enhanced Livestock works as a standalone mod, it can be enhanced by installing the following companion mods:

### FS25_FontLibrary
This mod improves the visual quality of text on animal ear tags.

*   **With FontLibrary:** High-quality text rendering for individual animal identification.
*   **Without FontLibrary:** A shader-based fallback is used. It is fully functional but visually simpler.

### FS25_AnimalPackage_vanillaEdition
Automatically integrates additional animal models and variants into the Enhanced Livestock system.

-   **Features:**
    *   Automatically loads additional animal fill types.
    *   Extends animal definitions for all species.
    *   Seamlessly integrates new visual variants into the game world.
-   **Availability:** Available through standard Farming Simulator 25 mod channels.

## DLC Compatibility

Enhanced Livestock is compatible with official DLCs. Specific content may require the corresponding pack:

*   **Highlands & Fishing Pack:** Required to access Highland Cattle breeds. All other features of the DLC remain compatible.

## Map Compatibility

Enhanced Livestock is designed to work on all maps. The mod includes an automatic detection system for animal identification based on the map's location.

!!! warning "Custom Animal Systems"
    Maps that implement their own custom animal systems (e.g., Hof Bergmann) are currently **not supported**. Enhanced Livestock is built to work with the standard Farming Simulator 25 animal system. Using it on such maps may lead to unexpected behavior or errors.

### Animal Identification & Country Codes
The mod uses two-letter country codes for animal identifiers, which are determined by the map's area code setting.

*   **Default Maps:** Country codes are assigned based on the specific map settings.
*   **Custom Maps:** If no specific area code is defined by the map creator, the mod defaults to the UK country code or uses the map-specified override.

## Mod Conflicts

To ensure stability, Enhanced Livestock will check for known incompatible mods upon startup.

### Incompatible Mods
The following mods cannot coexist with Enhanced Livestock because they modify the same core animal systems:

*   **FS25_RealisticLivestock:** The original mod this project was forked from.
*   **FS25_RealisticLivestockRM:** A derivative of Realistic Livestock with overlapping functionality.
*   **FS25_MoreVisualAnimals:** Conflicts with the custom visual animal rendering system used in Enhanced Livestock.

!!! danger "Conflict Detected"
    If any of these mods are detected, a conflict dialog will appear, and you will be required to disable one of the mods to proceed.

### General Advice
Avoid using other animal overhaul mods that replace the vanilla "cluster" system, as they are likely to cause logic conflicts or savegame corruption.

## Multiplayer Support

Enhanced Livestock is built with multiplayer in mind and fully supports synchronized gameplay:

*   **Synchronization:** All settings and animal data are automatically synchronized from the server/host to all clients.
*   **Authoritative Logic:** Events and animal state changes are server-authoritative to prevent desync.

## Integration: Butcher Mods

Enhanced Livestock features built-in integration with **Extended Production Point (EPP)** compatible butcher mods. This allows you to process animals directly from the animal management screen of the butcher.

-   **Valuation:** Animal value is dynamically calculated based on weight, quality, and genetics.
-   **Tested Mods:**
    *   `FS25_Butcher`
    *   `FS25_Meat_Production`
    *   `FS25_Meat_Processing_Plant`

Other mods utilizing the EPP system should work automatically without additional configuration.

## Performance Considerations

Managing individual animals is more resource-intensive than the vanilla cluster system. You can tune the performance in the mod settings.

### Visual Animal Limits
Adjust the maximum number of animals rendered in pastures based on your hardware:

*   **Low (25-50):** Recommended for older systems or large farms with many pastures.
*   **Medium (50-100):** A balanced setting for modern gaming PCs.
*   **High (100-200):** Prioritizes visual density and immersion on high-end hardware.

## Save Game Management

### Adding to an Existing Save
You can safely add Enhanced Livestock to a savegame already in progress.

1.  Existing animal clusters will be automatically converted to the new individual animal system.
2.  Genetics for existing animals will be randomly generated upon first load.
3.  All other properties (health, weight, etc.) will be initialized based on their current vanilla state.

### Removing the Mod
!!! warning "Data Loss Warning"
    Removing Enhanced Livestock from an active savegame will revert animals to the vanilla system, but may cause issues with animal data or lead to the loss of individual statistics. **Always back up your savegame before removing the mod.**

## Reporting Issues

If you encounter a compatibility issue or a bug:

1.  Ensure all your mods (especially Enhanced Livestock) are updated to the latest version.
2.  Try to reproduce the issue with only Enhanced Livestock and its dependencies enabled.
3.  Open an issue on our [GitHub Repository](https://github.com/renfordt/FS25_EnhancedLivestock).

**What to include in your report:**

*   A full list of active mods.
*   The game version you are running.
*   Clear steps to reproduce the problem.
*   Your `log.txt` file (found in the C:\Users\USERNAME\Documents\My Games\FarmingSimulator2025\log.txt).
