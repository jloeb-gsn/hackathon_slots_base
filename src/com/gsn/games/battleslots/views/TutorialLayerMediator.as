package com.gsn.games.battleslots.views
{
    import com.gsn.games.core.controllers.events.DataRequestEvent;
    import com.gsn.games.core.models.gameconfigmanager.IGameConfigManager;
    import com.gsn.games.core.models.languagemanager.ILanguageManager;
    import com.gsn.games.core.models.playermanager.IPlayerManager;
    import com.gsn.games.shared.utils.DebugUtils;
    import com.gsn.games.slots.events.SpinRequestEvent;
    import com.gsn.games.slots.models.SlotModel;
    import com.gsn.games.battleslots.data.TutorialType;
    import com.gsn.games.slots.events.GameEvent;
    import com.gsn.games.battleslots.events.TutorialEvent;
    import com.gsn.games.battleslots.events.SKSMiniGameEvent;
    import com.gsn.games.battleslots.models.TutorialModel;
    import com.gsn.games.slots.services.GameAnalytics;
    
    import org.robotlegs.mvcs.Mediator;

    public class TutorialLayerMediator extends Mediator
    {
        //--------------------------------------------
        // Static Properties
        //--------------------------------------------


        //--------------------------------------------
        // Static Methods
        //--------------------------------------------


        //--------------------------------------------
        // Public Properties
        //--------------------------------------------

        // INJECTIONS
        [Inject]
        public var view:TutorialLayerView; // Reference to the dialogs container view

		[Inject]
		public var model:SlotModel; // Reference to the slot model
		
		[Inject]
		public var tutorialModel:TutorialModel;

        [Inject]
        public var langMgr:ILanguageManager; // Reference to the resources manager

        [Inject]
        public var playerMgr:IPlayerManager; // Reference to player's information

        [Inject]
        public var config:IGameConfigManager; // Reference to the configuration manager
			
		[Inject]
		public var analytics:GameAnalytics; // Reference to the Analytics manager
		
		public var curTutScreenNum:int = 0;
		
		
        //--------------------------------------------
        // Protected & protected Properties
        //--------------------------------------------


        //--------------------------------------------
        // Getters & Setters
        //--------------------------------------------


        //--------------------------------------------
        // Public Methods
        //--------------------------------------------

        public function TutorialLayerMediator() {
            super();
        }

        // ------- Mediator overrides -------

        /**
        * Handles inputs / outputs between the game and the dialogs container.
        *  
        * */
        override public function onRegister():void {
            // Listening to events dispatched from the game:
			addContextListener(TutorialEvent.HIDE_TUTORIAL_SCREEN, handleHideTutScreen);
            addContextListener(TutorialEvent.SHOW_TUTORIAL_SCREEN, handleShowTutScreen);
			addContextListener(SpinRequestEvent.REQUEST_SPIN, handleMainSpinBtnClicked);
			addContextListener(SKSMiniGameEvent.WHEEL_MINI_GAME_SPIN_BEGUN, handleMiniGameSpinBtnClicked);
        }
		
        /**
         * Fired when the view is removed from the stage.
         * Handle all cleanup of eventListeners here.
         * */
        override public function onRemove():void {
			removeContextListener(TutorialEvent.HIDE_TUTORIAL_SCREEN, handleHideTutScreen);
            removeContextListener(TutorialEvent.SHOW_TUTORIAL_SCREEN, handleShowTutScreen);
			removeContextListener(SpinRequestEvent.REQUEST_SPIN, handleMainSpinBtnClicked);
			removeContextListener(SKSMiniGameEvent.WHEEL_MINI_GAME_SPIN_BEGUN, handleMiniGameSpinBtnClicked);
        }
        
        //--------------------------------------------
        // Protected & protected Methods
        //--------------------------------------------
        
        
        //--------------------------------------------
        // Event Handlers
        //--------------------------------------------
        
        protected function handleShowTutScreen(event:TutorialEvent):void {
			if (curTutScreenNum > 0) {
				DebugUtils.log("### - ERROR: handleShowTutScreen() trying to show tutorial screen #"+event.tutorialNum+" when current tutorial screen #"+curTutScreenNum+" is still showing.");
			} else {
				curTutScreenNum = event.tutorialNum;
				DebugUtils.log("### - showHideTutScreen(show) #"+curTutScreenNum)
				view.showHideTutorial(curTutScreenNum, true);
			}
        }
		
		protected function handleHideTutScreen(event:TutorialEvent):void {
			if (curTutScreenNum == 0) {
				DebugUtils.log("### - ERROR: handleHideTutScreen() trying to hide tutorial screen #"+curTutScreenNum+" when current no tutorial screen is showing.");
			} else {
				DebugUtils.log("### - handleHideTutScreen() #"+curTutScreenNum)
				view.showHideTutorial(curTutScreenNum, false);
				
				// Set the appropriate flag to indicate that a particular tutorial has been shown to the user
				switch (curTutScreenNum) {
					case TutorialType.CLICK_TO_SPIN:
						tutorialModel.wasClickToSpinShown = true;
						break;
					case TutorialType.SPIN_AGAIN:
						tutorialModel.wasSpinAgainShown = true;
						break;
					case TutorialType.WON_COLLECTION_ITEM:
						tutorialModel.wasCollectionItemWonShown = true;
						break;
					case TutorialType.SPIN_THE_MINI_GAME:
						tutorialModel.wasPlayMiniWheelShown = true;
						break
					default:
						DebugUtils.log("ERROR: An Unknown Tutorial Screen was shown!");
				}
				
				curTutScreenNum = 0;
			}
			
		}
		
		protected function handleMainSpinBtnClicked(e:DataRequestEvent):void {
			DebugUtils.log("### - handleMainSpinBtnClicked()");
			handleHideTutScreen(new TutorialEvent(TutorialEvent.HIDE_TUTORIAL_SCREEN, curTutScreenNum));
			//remove event listener when we're done with it, so we dont keep firing unnecessary events
			if (tutorialModel.wasSpinAgainShown && tutorialModel.wasClickToSpinShown){
				removeContextListener(SpinRequestEvent.REQUEST_SPIN, handleMainSpinBtnClicked);
			}
		}
		
		protected function handleMiniGameSpinBtnClicked(e:GameEvent):void {
			DebugUtils.log("### - handleMiniGameSpinBtnClicked()")
			handleHideTutScreen(new TutorialEvent(TutorialEvent.HIDE_TUTORIAL_SCREEN, curTutScreenNum));
		}

    }
}
