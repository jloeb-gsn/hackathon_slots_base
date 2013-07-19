package com.gsn.games.battleslots.data {
	import flash.utils.Dictionary;
		
	public class MonsterConstants {
		
		public static var monsters:Array;
		
		public static var monsterImageMap:Dictionary = new Dictionary();
		
		public function MonsterConstants() {
			setMonsters();
		}
		
		private function setMonsters():void {
			monsters = [
				"pikachu",
				"squirtle",
				"magikarp",
				"exeggutor",
				"charizard",
				"vulpix",
				"kadabra",
				"weedle",
				"pidgey",
				"diglet",
				"bulbasaur",
				"koffing"
			];
		}
	}
}