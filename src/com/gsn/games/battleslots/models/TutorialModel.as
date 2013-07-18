package com.gsn.games.battleslots.models {
    import com.gsn.games.shared.utils.DebugUtils;
    import com.gsn.games.slots.models.SlotModel;
    
    import org.robotlegs.mvcs.Actor;

    /**
     * Adds slot-machine specific properties to GameConfig objects.
     */
    public class TutorialModel extends Actor {
		
		
		[Inject]
		public var model:SlotModel;
		
		public static const TUTORIAL_MODE_SEQUENTIAL:String = "sequential";
		
        // Keeps track of the slots machine State
		public var isTutorialCohortActive:Boolean = true;
        public var wasClickToSpinShown:Boolean;		
		public var wasPlayMiniWheelShown:Boolean;
		public var wasSpinAgainShown:Boolean;
		public var wasCollectionItemWonShown:Boolean;
		
        public function TutorialModel() {
            super();

			// TODO: TEST TO SEE IF TUTORIAL COHORT IS ENABLED. If so, set each value according to server tracked value.
			wasClickToSpinShown = wasPlayMiniWheelShown =  wasSpinAgainShown =  wasCollectionItemWonShown = true;
        }
		
		public function get shouldSpinBeFree():Boolean {
			return isTutorialCohortActive && model.gameState.spinState.spinNumber == 0;
		}

		
        /**
         * Sets the appropriate properties based on the passed in flash variables.
         * @param flashVars An object containing key/value pairs for the properties to set.
         * @param facebookUserId The facebook user id for the current player.
		 * @param totalSpins The total number of spins the user has done on WoF Slots. If > 20, no tutorial is shown.
         */
        public function applyFlashVars(flashVars:Object, facebookUserId:Number, isNewUser:Boolean):void {
			// TODO: TEST TO SEE IF TUTORIAL COHORT IS ENABLED. If so, set each value according to server tracked value.
            
            	DebugUtils.log("### - TUTORIAL cohort is: OFF");

				wasClickToSpinShown =  wasPlayMiniWheelShown =  wasSpinAgainShown = wasCollectionItemWonShown = true;
			
        }
        

    }
}
