package com.gsn.games.battleslots.commands {
	import com.gsn.games.slots.commands.ConfigureGameCmd;
	import com.gsn.games.slots.data.SpinState;
	import com.gsn.games.battleslots.data.BattleSpinState;
	
	public class SKSConfigureCommand extends ConfigureGameCmd {
		public function SKSConfigureCommand() { super(); }
		
		override protected function getSpinState():SpinState {
			return new BattleSpinState();
		}
	}
}