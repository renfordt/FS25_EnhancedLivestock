# Compatibility

Enhanced Livestock is designed to work seamlessly with Farming Simulator 25 while integrating with select companion mods.

## Game Requirements

| Requirement | Details |
|-------------|---------|
| Game | Farming Simulator 25 |
| Multiplayer | Fully supported |
| Save Compatibility | Works with existing saves |

## Optional Dependencies

### FS25_FontLibrary

Enhances ear tag text rendering with better font quality.

| Status | Effect |
|--------|--------|
| Installed | Enhanced font rendering |
| Not installed | Shader-based fallback (functional but simpler) |

**Installation:** Available through standard mod channels.

### FS25_AnimalPackage_vanillaEdition

Automatically integrates additional animal models and variants from this popular mod.

| Status | Effect |
|--------|--------|
| Installed | Additional breeds and variants available |
| Not installed | Standard vanilla animals only |

**Features when installed:**

- Additional fill types loaded automatically
- Extended animal definitions for all species
- New visual variants integrated seamlessly

## DLC Compatibility

### Highlands & Fishing Pack

| Feature | Status |
|---------|--------|
| Highland Cattle | Requires DLC |
| Other content | Compatible |

Highland Cattle breeds are only available when the Highlands & Fishing Pack DLC is installed.

## Map Compatibility

Enhanced Livestock works with all maps. The mod automatically detects the map location for animal identification:

| Map Type | Country Code |
|----------|-------------|
| Default maps | Based on map setting |
| Custom maps | UK default or map-specified |

### Country Codes

Animal identifiers use two-letter country codes based on the map's area code setting.

## Mod Conflicts

### Known Incompatibilities

| Mod Type | Issue |
|----------|-------|
| Other animal overhauls | May conflict with animal system changes |
| Cluster-based animal mods | Incompatible with individual animal system |

### Recommended Load Order

1. Base game
2. DLCs
3. FS25_FontLibrary (if used)
4. FS25_AnimalPackage_vanillaEdition (if used)
5. Enhanced Livestock
6. Other mods

## Multiplayer

Enhanced Livestock fully supports multiplayer:

| Feature | Support |
|---------|---------|
| Dedicated servers | Yes |
| Peer-to-peer | Yes |
| Cross-platform | Yes |
| Settings sync | Automatic |

### Multiplayer Requirements

- All players must have the mod installed
- Settings synchronize from server/host
- Events are server-authoritative

## Integration: EPP Butcher

Enhanced Livestock integrates with EPP Market for direct animal processing:

| Feature | Description |
|---------|-------------|
| Process from screen | Process animals directly from animal management |
| Value calculation | Based on weight, quality, and genetics |

## Performance Considerations

### Visual Animal Limits

| Setting | Effect |
|---------|--------|
| Low (25-50) | Best performance |
| Medium (50-100) | Balanced |
| High (100-200) | Visual quality priority |

Adjust based on your system's capabilities.

### Recommended Specifications

| Component | Recommendation |
|-----------|---------------|
| CPU | Modern multi-core |
| RAM | 16GB+ |
| GPU | Mid-range or better |

## Save Game Notes

### Upgrading to Enhanced Livestock

When adding the mod to an existing save:

1. Existing animals convert to individual system
2. Genetics are randomly generated
3. All other properties initialized

### Removing the Mod

!!! warning "Mod Removal"
    Removing Enhanced Livestock from an active save may cause issues with existing animals. Back up your save first.

## Reporting Issues

If you encounter compatibility issues:

1. Check mod versions are current
2. Verify load order
3. Test with minimal mod set
4. Report issues on [GitHub](https://github.com/renfordt/FS25_EnhancedLivestock)

Include in bug reports:

- Mod list
- Game version
- Steps to reproduce
- Log files if available
