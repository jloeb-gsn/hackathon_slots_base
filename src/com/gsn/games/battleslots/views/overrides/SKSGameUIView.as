package com.gsn.games.battleslots.views.overrides {
	import com.gsn.games.shared.ui.FrameButtonHelper;
	import com.gsn.games.slots.data.SlotEngineDefs;
	import com.gsn.games.slots.views.dialogs.GameUIView;
	
	import flash.events.MouseEvent;
	
	public class SKSGameUIView extends GameUIView {
		
		protected var freeCheatBtn:FrameButtonHelper;
		protected var minigameCheatBtn:FrameButtonHelper;
		
		public function SKSGameUIView() {super();}
		
		override public function addCheatButtons(running_y:Number):void {
			/*freeCheatBtn = createCheatButton( running_y += 30, "Free Play");
			
			envelopeCheatBtn = createCheatButton( running_y += 30, "Prize Env");
            */
			minigameCheatBtn = createCheatButton( running_y += 30, "MiniGame");
			super.addCheatButtons(running_y);
		}
		
		override protected function getTestOutcome(e:MouseEvent):int {
			var outcome:int = 0;
			if (e.target == freeCheatBtn)		{	outcome = SlotEngineDefs.FREE_PLAY_MINIGAME;	}
			else if (e.target == minigameCheatBtn) {	outcome = SlotEngineDefs.MINIGAME; }
			else {
				outcome = super.getTestOutcome(e);
			}
			return outcome;
		}
	}
}