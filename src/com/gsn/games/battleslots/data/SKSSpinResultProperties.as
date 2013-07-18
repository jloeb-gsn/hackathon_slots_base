package com.gsn.games.battleslots.data {
	import com.gsn.games.slots.data.FreePlayMiniGameResult;
	import com.gsn.games.slots.data.SpinResultPropertyCollection;
	import com.gsn.games.slots.data.SpinState;
	
	public class SKSSpinResultProperties extends SpinResultPropertyCollection {
		
		public function SKSSpinResultProperties() { 
			super(); 
		}
		
		override public function addProperty(name:String, obj:Object):void {
			switch (name) {
				default:
					super.addProperty(name, obj);
					break;
			}
		}
		
		override public function getNewSpinState():SpinState {
			return new BattleSpinState();
		}
	}
}