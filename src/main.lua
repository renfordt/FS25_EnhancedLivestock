--[[
    main.lua
    Main loader for Enhanced LivestockRM.
    Loads all dependencies in the correct order.

    IMPORTANT: The loading order is critical - do not reorder without testing.
    Author: renfordt (based on Ritters RealisticLivestockRM and Arrow-kb's Realistic Livestock)
]]

local modDirectory = g_currentModDirectory


-- SECTION 1: GUI Loading Screen
source(modDirectory .. "src/gui/MPLoadingScreen.lua")

-- SECTION 2: Animal Husbandry - Cluster System
source(modDirectory .. "src/animals/husbandry/cluster/EnhancedLivestock_AnimalCluster.lua")
source(modDirectory .. "src/animals/husbandry/cluster/EnhancedLivestock_AnimalClusterHusbandry.lua")
source(modDirectory .. "src/animals/husbandry/cluster/EnhancedLivestock_AnimalClusterSystem.lua")
source(modDirectory .. "src/animals/husbandry/cluster/VisualAnimal.lua")

-- SECTION 3: Animal Husbandry - Placeables
source(modDirectory .. "src/animals/husbandry/placeables/PlaceableHusbandry.lua")
source(modDirectory .. "src/animals/husbandry/placeables/PlaceableHusbandryLiquidManure.lua")
source(modDirectory .. "src/animals/husbandry/placeables/PlaceableHusbandryStraw.lua")
source(modDirectory .. "src/animals/husbandry/placeables/PlaceableHusbandryWater.lua")
source(modDirectory .. "src/animals/husbandry/placeables/EnhancedLivestock_PlaceableHusbandryAnimals.lua")
source(modDirectory .. "src/animals/husbandry/placeables/EnhancedLivestock_PlaceableHusbandryMilk.lua")
source(modDirectory .. "src/animals/husbandry/placeables/EnhancedLivestock_PlaceableHusbandryFood.lua")
source(modDirectory .. "src/animals/husbandry/placeables/EnhancedLivestock_PlaceableHusbandryPallets.lua")

-- SECTION 4: Animal Husbandry - Core Systems
source(modDirectory .. "src/animals/husbandry/AnimalSystemStateEvent.lua")
source(modDirectory .. "src/animals/husbandry/EnhancedLivestock_HusbandrySystem.lua")
source(modDirectory .. "src/animals/husbandry/EnhancedLivestock_AnimalNameSystem.lua")
source(modDirectory .. "src/animals/husbandry/EnhancedLivestock_AnimalSystem.lua")

-- SECTION 5: Animal Shop - Controllers
source(modDirectory .. "src/animals/shop/controllers/AnimalScreenBase.lua")
source(modDirectory .. "src/animals/shop/controllers/AnimalScreenDealer.lua")
source(modDirectory .. "src/animals/shop/controllers/AnimalScreenDealerFarm.lua")
source(modDirectory .. "src/animals/shop/controllers/AnimalScreenDealerTrailer.lua")
source(modDirectory .. "src/animals/shop/controllers/AnimalScreenTrailer.lua")
source(modDirectory .. "src/animals/shop/controllers/AnimalScreenTrailerFarm.lua")

-- SECTION 6: Animal Shop - Events
source(modDirectory .. "src/animals/shop/events/AIAnimalBuyEvent.lua")
source(modDirectory .. "src/animals/shop/events/AIAnimalInseminationEvent.lua")
source(modDirectory .. "src/animals/shop/events/AIAnimalSellEvent.lua")
source(modDirectory .. "src/animals/shop/events/AIBulkMessageEvent.lua")
source(modDirectory .. "src/animals/shop/events/AnimalBuyEvent.lua")
source(modDirectory .. "src/animals/shop/events/AnimalInseminationEvent.lua")
source(modDirectory .. "src/animals/shop/events/AnimalInseminationResultEvent.lua")
source(modDirectory .. "src/animals/shop/events/AnimalMoveEvent.lua")
source(modDirectory .. "src/animals/shop/events/AnimalSellEvent.lua")
source(modDirectory .. "src/animals/shop/events/SemenBuyEvent.lua")

-- SECTION 7: Animal Shop - Core
source(modDirectory .. "src/animals/shop/AnimalItemNew.lua")
source(modDirectory .. "src/animals/shop/EnhancedLivestock_AnimalItemStock.lua")

-- SECTION 8: Events (General)
source(modDirectory .. "src/events/DewarManagerStateEvent.lua")
source(modDirectory .. "src/events/DewarNitrogenRefillEvent.lua")
source(modDirectory .. "src/events/HusbandryMessageStateEvent.lua")
source(modDirectory .. "src/events/ReturnStrawEvent.lua")
source(modDirectory .. "src/events/SemenSellEvent.lua")

-- SECTION 9: Farms
source(modDirectory .. "src/farms/FarmManager.lua")
source(modDirectory .. "src/farms/EnhancedLivestock_FarmStats.lua")

-- SECTION 10: Fill Types
source(modDirectory .. "src/fillTypes/EnhancedLivestock_FillTypeManager.lua")

-- SECTION 11: Breeding Mathematics
source(modDirectory .. "src/BreedingMath.lua")

-- SECTION 12: GUI Elements
source(modDirectory .. "src/gui/elements/DoubleOptionSliderElement.lua")
source(modDirectory .. "src/gui/elements/RenderElement.lua")
source(modDirectory .. "src/gui/elements/TripleOptionElement.lua")

-- SECTION 13: GUI Dialogs and Frames
source(modDirectory .. "src/gui/EnhancedLivestock_AnimalScreen.lua")
source(modDirectory .. "src/gui/VisualAnimalsDialog.lua")
source(modDirectory .. "src/gui/NameInputDialog.lua")
source(modDirectory .. "src/gui/EnhancedLivestockFrame.lua")
source(modDirectory .. "src/gui/AnimalAIDialog.lua")
source(modDirectory .. "src/gui/AnimalFilterDialog.lua")
source(modDirectory .. "src/gui/AnimalInfoDialog.lua")
source(modDirectory .. "src/gui/DiseaseDialog.lua")
source(modDirectory .. "src/gui/EarTagColourPickerDialog.lua")
source(modDirectory .. "src/gui/FileExplorerDialog.lua")
source(modDirectory .. "src/gui/InGameMenuSettingsFrame.lua")
source(modDirectory .. "src/gui/ProfileDialog.lua")
source(modDirectory .. "src/gui/EL_InfoDisplayKeyValueBox.lua")
source(modDirectory .. "src/gui/EnhancedLivestock_InGameMenuAnimalsFrame.lua")

-- SECTION 14: Migration System
source(modDirectory .. "src/migration/ELMigrationManager.lua")
source(modDirectory .. "src/migration/ELMigrationDialog.lua")
source(modDirectory .. "src/migration/ELItemSystemMigration.lua")

-- SECTION 15: Hand Tools
source(modDirectory .. "src/handTools/specializations/HandToolHorseBrush.lua")
source(modDirectory .. "src/handTools/HandTool.lua")
source(modDirectory .. "src/handTools/HandToolSystem.lua")
source(modDirectory .. "src/handTools/ELHandTools.lua")

-- SECTION 16: Objects
source(modDirectory .. "src/objects/Dewar.lua")

-- SECTION 17: Placeables
source(modDirectory .. "src/placeables/EnhancedLivestock_PlaceableSystem.lua")

-- SECTION 18: Player
source(modDirectory .. "src/player/EnhancedLivestock_PlayerHUDUpdater.lua")
source(modDirectory .. "src/player/EnhancedLivestock_PlayerInputComponent.lua")

-- SECTION 19: Vehicles
source(modDirectory .. "src/vehicles/specializations/EnhancedLivestock_LivestockTrailer.lua")
source(modDirectory .. "src/vehicles/specializations/Rideable.lua")
source(modDirectory .. "src/vehicles/EnhancedLivestock_VehicleSystem.lua")

-- SECTION 20: Core Mod Files
source(modDirectory .. "src/AIAnimalManager.lua")
source(modDirectory .. "src/AIStrawUpdater.lua")
source(modDirectory .. "src/AnimalBirthEvent.lua")
source(modDirectory .. "src/AnimalDeathEvent.lua")
source(modDirectory .. "src/AnimalMonitorEvent.lua")
source(modDirectory .. "src/AnimalNameChangeEvent.lua")
source(modDirectory .. "src/AnimalPregnancyEvent.lua")
source(modDirectory .. "src/AnimalUpdateEvent.lua")
source(modDirectory .. "src/DiseaseTreatmentEvent.lua")
source(modDirectory .. "src/DewarManager.lua")
source(modDirectory .. "src/DewarNitrogenRefill.lua")
source(modDirectory .. "src/Disease.lua")
source(modDirectory .. "src/DiseaseManager.lua")
source(modDirectory .. "src/NutritionManager.lua")
source(modDirectory .. "src/FSCareerMissionInfo.lua")
source(modDirectory .. "src/I18N.lua")
source(modDirectory .. "src/EnhancedLivestock.lua")
source(modDirectory .. "src/EnhancedLivestock_Animal.lua")
source(modDirectory .. "src/EnhancedLivestock_FSBaseMission.lua")
source(modDirectory .. "src/ELConsoleCommandManager.lua")
source(modDirectory .. "src/ELMessage.lua")
source(modDirectory .. "src/ELSettings.lua")
source(modDirectory .. "src/EL_BroadcastSettingsEvent.lua")

-- SECTION 21: EPP Integration
source(modDirectory .. "src/integrations/EPPButcherIntegration.lua")
source(modDirectory .. "src/integrations/events/EPPButcherProcessEvent.lua")
source(modDirectory .. "src/integrations/events/EPPButcherResultEvent.lua")