# Release Notes

## 1.2.0.0

- Feature: Total overhaul of disease system - Total of 27 diseases
- Feature: Overhaul of assisted breeding - Tier based sample selection and improved breeding mechanics
- Feature: You can now sell breeding material from male animals
- Feature: Added a nitrogen refill system for dewars
- Feature: New nutrition system - nutrition based animal health and growth
- Bug fix: Potential fix for milk production issues
- Bug fix: Potential fix for disease issues
- Bug fix: Multiplayer client unable to clean horses (by rittermod)
- Bug fix: Black screen when multiplayer client tries to ride a horse (by rittermod)
- Bug fix: Pregnancy event silently failing to match animals on client (by rittermod)
- Bug fix: Stream corruption in AI auto-insemination event (by rittermod)
- Bug fix: Server crash when client inseminates cow with straw (by rittermod)
- Bug fix: Client-side error when buying semen in multiplayer (by rittermod)
- Bug fix: AI dialog insemination blocked for cows that never gave birth (missing isParent guard) (by rittermod)
- Bug fix: AI dialog insemination not syncing in multiplayer (by rittermod)
- Bug fix: Error spam when dismounting horse outside pen in multiplayer (by rittermod)
- Bug fix: Messages are not broadcasted to all players in multiplayer
- Added Hungarian translation (by Toamsz93)
- Added Spanish translation

## v1.1.4.0

- Fix bug in settings save mechanism
- Added Chinese translation

## v1.1.3.0

- Fixed a bug not showing milk storage

## v1.1.2.0

- Fixed a bug where the animals of AnimalPackage Vanilla Edition do not appear in the trailer

## v1.1.1.0

- Adjusted translations to comply to PEGI 3
- Fixed a bug during saving the settings

## v1.1.0.0

- EPP Market integration - process animals directly from the animal screen
- Ear tag text reintroduced with toggle setting for visibility
- FontLibrary reintroduced as an optional dependency with shader-based fallback
- Dynamic Ear tags as fallback solution
- Randomize father selection during breeding - eligible males are now chosen randomly instead of always the first one (based on RitterMod)
- Improve genetic inheritance with natural variation - offspring can now exceed or fall below parent trait values (based on RitterMod)
- Fix wrong text shown for straw in monitor menu (based on RitterMod)
- Fix multiplayer sync issues when subTypeIndex differs between server/client (based on RitterMod PR by killemth)
- Add fallback for days per month calculation during early load (based on RitterMod PR by killemth)
- Refactor subType resolution into helper function with logging (based on RitterMod)
- Several smaller bug fixes and improvements
- Added Migration manager (based on RitterMod)

## V1.0.0.0

Initial release based on Arrow-kb's FS25_RealisticLivestock mod.