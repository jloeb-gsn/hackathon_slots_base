/**
 * SKSSpinWinCommand.as
 * 
 * The win command that adds additional game-specific win states that are not covered in the base SpinWinCycleCommand
 * (STOP REELS -> PROCESS MINI GAME -> CYCLE PAYLINES -> SHOW BADGES -> DISPLAY ALL PAYLINES -> ENABLE UI)
 * 
 * SlotEngineDefs.STEPS contains the full list of states, so any new states will also need to be added in the constructor of this class.
 */
package com.gsn.games.battleslots.commands {
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.models.TutorialModel;
	import com.gsn.games.slots.commands.SpinWinCycleCommand;
	import com.gsn.games.slots.events.GameEvent;
	
	public class BattleSpinWinCommand extends SpinWinCycleCommand {
		
		public static const PROCESS_STATS:String = "process_stat_boosts";
		
		[Inject]
		public var tutorialModel:TutorialModel;
		
		public function BattleSpinWinCommand() {
			super();
		}
		
		override protected function onEnterWinLinesCycleState():void {
			super.onEnterWinLinesCycleState();
		}
		
		/** @inherit */
        override protected function handleMiniGame():void {
            var isMinigameResult:Boolean = false;
			if ((model.currentResult.newGameState as BattleSpinState) &&
				(model.currentResult.newGameState as BattleSpinState).miniGameState) {
				isMinigameResult = true;
			}
            if (isMinigameResult) {
				dispatch(new GameEvent(GameEvent.SHOW_FANFARE));
                var e:GameEvent = new GameEvent(GameEvent.MINIGAME_START);
                dispatch(e);
            } else {
                // Process Transition out
                onNextStep();
            }
        }

      
	}
}