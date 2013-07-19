package com.gsn.games.battleslots.events {
	import com.gsn.games.slots.events.SlotsDialogEvent;
	
	public class SKSSlotsDialogEvent extends SlotsDialogEvent {
		//Labels
		public static const TRAINER_CARD:String = "trainer_card_show";
		public static const MONSTER_COLLECTION:String = "monster_collection_show";
		public static const BUY_MONSTERS_DIALOG:String = "buy_monsters_show";
		public static const CHALLENGE_FRIENDS:String = "challenge_friends";
		public static const OFFER_MONSTER_CHOICE:String = "show_choice_of_monsters";
		public static const KEEP_MONSTER:String = "keep_monster_dialog";
		
		public var monsters:Array = [];
		
		public function SKSSlotsDialogEvent(type:String, label:String="", monsterList:Array = null) {
			super(type, label);
			if (monsterList != null) {
				monsters = monsterList;
			}
		}
	}
}