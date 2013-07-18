/**
 * SKSGameUIMediator.as
 * 
 * Handles additional events that will change the game ui. Primary use is for kicking players
 * out of autospin mode. 
 */
package com.gsn.games.battleslots.views.overrides {
	
	import com.gsn.games.slots.events.FreeSpinsMiniGameEvent;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.events.SlotsDialogEvent;
	import com.gsn.games.slots.views.mediators.GameUIMediator;
	
	public class SKSGameUIMediator extends GameUIMediator {
		public function SKSGameUIMediator() { super(); }
		
		override public function onRegister():void {
			addContextListener(FreeSpinsMiniGameEvent.END_FREE_SPINS, onEndFreeSpins);
			addContextListener(SlotsDialogEvent.SHOW_BADGE_DIALOGS, onStopAutoSpins);
			super.onRegister();
		}
		
		override public function onRemove():void {
			removeContextListener(FreeSpinsMiniGameEvent.END_FREE_SPINS, onEndFreeSpins);
			removeContextListener(SlotsDialogEvent.SHOW_BADGE_DIALOGS, onStopAutoSpins);
			super.onRemove();
		}
		
		///////////
		/**
		 * Triggered when free spins are over
		 * */
		protected function onEndFreeSpins(e:GameEvent) : void {
			view.enableUI(playerMgr.tokens);
		}
	}
}