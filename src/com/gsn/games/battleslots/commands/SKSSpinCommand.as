package com.gsn.games.battleslots.commands {
	import com.gsn.games.slots.commands.SpinCmd;
	import com.gsn.games.slots.data.SpinResultPropertyCollection;
	import com.gsn.games.battleslots.data.SKSSpinResultProperties;
	
	public class SKSSpinCommand extends SpinCmd {
		public function SKSSpinCommand() { super(); }
		
		override protected function getExtraDataContainer():SpinResultPropertyCollection {
			return new SKSSpinResultProperties();
		}
	}
}