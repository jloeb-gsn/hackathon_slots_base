package com.gsn.games.battleslots.commands {
	import com.gsn.games.slots.commands.AddGameViewCommand;
	import com.gsn.games.battleslots.views.overrides.SKSMainView;
	
	public class AddSKSMainViewCommand extends AddGameViewCommand {
		public function AddSKSMainViewCommand() {super();}
		
		override protected function addMainView():void {
			contextView.addChild(new SKSMainView);
		}
		
	}
}