package com.gsn.games.battleslots.models {
    import com.gsn.games.battleslots.data.BattleSpinState;
    import com.gsn.games.slots.models.SlotModel;
    import com.gsn.games.slots.models.SlotsGameModel;

    /**
     * This model keeps track of...
     */
    public class SKSSlotsGameModel extends SlotsGameModel {
        // ATTRIBUTES
        // PUBLIC
		public var miniWheelTokensWon:Number = 0;	// 0 = no miniwheelspin this wincycle, otherwise total tokens won during minigame
        public var playingFreeGameFromFriend:Boolean    = false; // Indicates if we are playing this game as a reward from another player
   		
		public function getMonsters():Array {
			var bss:Object = SlotModel.instance.gameState.spinState;
			return [];
		}
	}
}
