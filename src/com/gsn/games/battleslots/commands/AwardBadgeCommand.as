package com.gsn.games.battleslots.commands {
    
    import com.gsn.games.core.controllers.events.BadgeManagerEvent;
    import com.gsn.games.core.models.badgemanager.BadgeManager;
    import com.gsn.games.core.models.badgemanager.IBadgeManager;
    import com.gsn.games.core.models.badgemanager.badges.BadgeModel;
    import com.gsn.games.core.models.badgemanager.badges.DynamicBadgeModel;
    import com.gsn.games.core.models.badgemanager.vo.BadgeVO;
    import com.gsn.games.core.models.gameconfigmanager.IGameConfigManager;
    import com.gsn.games.core.models.playermanager.IPlayerManager;
    import com.gsn.games.shared.utils.DebugUtils;
    import com.gsn.games.battleslots.data.BadgeConstants;
    import com.gsn.games.battleslots.events.SKSMiniGameEvent;
    import com.gsn.games.battleslots.models.SKSSlotsGameModel;
    import com.gsn.games.slots.data.RemoteSpinResult;
    import com.gsn.games.slots.data.SlotEngineDefs;
    import com.gsn.games.slots.data.SpinOutcome;
    import com.gsn.games.slots.events.BadgeEvent;
    import com.gsn.games.slots.events.SlotsDialogEvent;
    import com.gsn.games.slots.models.SlotModel;
    
    import org.robotlegs.mvcs.Command;
    
    /**
     * Checks the list of awarded badges, and dispatches the appropriate events
    * Performs all front-end maintenance related to badges
    * */
    public class AwardBadgeCommand extends Command {
        
        // INJECTIONS
        [Inject]
        public var badgeManager:IBadgeManager;
        
        [Inject]
        public var configManager:IGameConfigManager;
        
        [Inject]
        public var model:SlotModel;
		
		[Inject]
		public var gameModel:SKSSlotsGameModel;
		
        [Inject]
        public var player:IPlayerManager;
        
        // CONSTANTS
        
        // PROPERTIES
        
        // Transient properties to keep track of badges as we are collecting them after a spin complete
        protected var badgesEarned:Vector.<BadgeModel>; // Keeps track of all awarded badges (from BE aka Dynamic Badges, or FE - in-game badges
        protected var badgesUpdatedCounter:int = 0; // Counts in game badges
        protected var badgesToUpdate:Vector.<int>;

        // PUBLIC
        public function AwardBadgeCommand() {
            super();
        }
        
        /**
        * This function does three things:
        * 
        * 1) It processes the dynamic badges if any
        * 2) It dispatches progress updates for all "static" badges based on some specific rules (defined in this class)
        * 3) It dispatches the list of earned badges to the game
        * 
        **/
        override public function execute():void {
            DebugUtils.log("AwardBadgeCommand.execute+++");

            badgesUpdatedCounter = 0;
            badgesEarned = new Vector.<BadgeModel>();
            for each (var badge:DynamicBadgeModel in model.currentResult.badgesWon)
            {
                if (badge)
                {
                    badgeManager.addDynamicBadge(badge);
                    if (badge.progress == badge.target)
                    {
                        badgesEarned.push(badge);
                    }
                }
            }
            
            (this.badgeManager as BadgeManager).eventDispatcher.addEventListener(BadgeManagerEvent.BADGE_AWARDED, onBadgeAwarded);
            (this.badgeManager as BadgeManager).eventDispatcher.addEventListener(BadgeManagerEvent.BADGE_PROGRESS_UPDATE_COMPLETE, onBadgeProgressUpdateComplete);
            
            // Check badges - this code also triggers a series of BADGE_PROGRESS_UPDATE_COMPLETE && BADGE_AWARDED
            // When the last BADGE_PROGRESS_UPDATE_COMPLETE, we send a notification to the UI with the results - if any
            checkSlotMachineBadges(model.currentResult, model.winStreak);
        }
        
        protected function cleanup() : void
        {
            (this.badgeManager as BadgeManager).eventDispatcher.removeEventListener(BadgeManagerEvent.BADGE_AWARDED, onBadgeAwarded);
            (this.badgeManager as BadgeManager).eventDispatcher.removeEventListener(BadgeManagerEvent.BADGE_PROGRESS_UPDATE_COMPLETE, onBadgeProgressUpdateComplete);
        }
        
        /**
        * Triggered when a badge update request is complete
        * */
        protected function onBadgeProgressUpdateComplete(e:BadgeManagerEvent) : void {

            cleanup();

            // We are done updating all badges
            // Show results
            // Notify the game that we have new badges to display (assuming we have something to show)
            if (badgesEarned.length > 0)
            {
                for each (var b2:BadgeModel in badgesEarned)
                {
                    if ((b2.imageUrl == null) || (b2.imageUrl == ""))
                    {
                        // This loads the image directly. The image is accessible in the image property of the badge model
                        b2.imageUrl = configManager.settings.assetDir + "badges/130/b" + b2.id + ".png";
                    }
                }
                var evt:SlotsDialogEvent = new SlotsDialogEvent(SlotsDialogEvent.SHOW_BADGE_DIALOGS);
                evt.badgesToShow = badgesEarned;
                dispatch(evt);
            }
            else 
            {
                // There are no badges to show
                // Resume to the next step in the process
                DebugUtils.log("No more badges to update. Resume the win cycle");
                dispatch(new BadgeEvent(BadgeEvent.BADGES_SHOWN));
            }
        }
        
        /**
        * This is triggered each time a badge is awarded in the game.
        * We add it to the list of all badges earned during this spin.
        * */
        protected function onBadgeAwarded(e:BadgeManagerEvent) : void
        {
            var vo:BadgeVO = e.vo;
            var badge:BadgeModel = badgeManager.getBadgeById(vo.id);
            if (badgesEarned && badge)
            {
                // Set the image
                if ((badge.imageUrl == null) || (badge.imageUrl == ""))
                {
                    // This loads the image directly. The image is accessible in the image property of the badge model
                    badge.imageUrl = configManager.settings.assetDir + "badges/130/b" + badge.id + ".png";
                }
                badgesEarned.push(badge);
            }
        }
        
        /**
        * Triggers a progress update for all badges that qualify for this spin
        * */
        protected function updateBadgesProgress() : void
        {
            var badgeCount:int = badgesToUpdate.length;
            if (badgeCount > 0) {
                DebugUtils.log("We have a few badges to update");
				var badgeVOsToUpdate:Vector.<BadgeVO> = new Vector.<BadgeVO>();
                for (var i:int = 0; i<badgeCount; i++) {
					badgeVOsToUpdate.push(new BadgeVO(badgesToUpdate[i]));
                }
				this.badgeManager.updateRemoteMultipleBadgeProgress(badgeVOsToUpdate);
            } else {
                // There are no badges to show
                // Resume to the next step in the process
                DebugUtils.log("No badges to update. Resume the win cycle");
                cleanup();
                dispatch(new BadgeEvent(BadgeEvent.BADGES_SHOWN));
            }
        }
        
        /**
        * Updates badges information.
        * 
        * */
        protected function checkSlotMachineBadges(result:RemoteSpinResult, winStreak:int = 0):void
        {
            badgesToUpdate = new Vector.<int>();
			
            var row:SpinOutcome;
            var lineWinCount:int = 0;
            for each (row in result.outcomes) {
				
				
				
                if (row.outcomeId == SlotEngineDefs.THREE_MINI_GAMES) { 
                    badgesToUpdate.push(BadgeConstants.PLAY_MINIGAME_ONCE);
                 
                } else {
                    lineWinCount++;
                    
                    switch (row.outcomeId)
                    {
                        case SlotEngineDefs.FOUR_JACKPOTS:
                        case SlotEngineDefs.FIVE_JACKPOTS:
                            badgesToUpdate.push(BadgeConstants.FOUR_PLUS_JACKPOTS);
                            break;
                        
                        case SlotEngineDefs.FIVE_ICON_AS:
                            badgesToUpdate.push(BadgeConstants.FIVE_A_ICONS);
                            break;
                        
                        case SlotEngineDefs.FIVE_ICON_BS:
                            badgesToUpdate.push(BadgeConstants.FIVE_B_ICONS);
                            break;
                        
                        case SlotEngineDefs.FIVE_ICON_CS:
                            badgesToUpdate.push(BadgeConstants.FIVE_C_ICONS);
                            break;
                        
                        case SlotEngineDefs.FIVE_ICON_DS:
                            badgesToUpdate.push(BadgeConstants.FIVE_D_ICONS);
                            break;
                        
                        case SlotEngineDefs.FIVE_ICON_ES:
                            badgesToUpdate.push(BadgeConstants.FIVE_E_ICONS);
                            break;
                    }
                }
            }
            
            if (lineWinCount >= 4)
            {
                badgesToUpdate.push(BadgeConstants.FOUR_PLUS_WIN_LINES);
            }
            
            if (result.totalPayout >= 1000000)
            {
                badgesToUpdate.push(BadgeConstants.HIGH_ROLLER);
            }
            
            if (winStreak >= 10)
            {
                badgesToUpdate.push(BadgeConstants.WINNING_STREAK);
            }
            updateBadgesProgress();
        }    
    }
}
