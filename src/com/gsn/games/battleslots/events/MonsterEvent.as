package com.gsn.games.battleslots.events {
	import com.gsn.games.battleslots.data.Monster;
	
	import flash.events.Event;
	
	public class MonsterEvent extends Event {
		
		//Consts - do not require attribute
		public static const SET_ACTIVE:String = 'set_active';
		//consts - do require attribute
		public static const ADD_STAT:String = 'stat_increase';
		public static const BOOST_STAT:String = 'boost_increse';
		public static const RESET_BOOSTS:String = 'boost_reset';
		public static const LEVEL_UP:String = 'level_up';
		public static const ADD_XP:String = 'xp_gained';
		public static const NEW_MONSTER:String = 'new_monster';
		
		
		//Event vars
		public var monster:Monster;
		public var stat:String = Monster.XP;
		public var amount:int;
		
		public function MonsterEvent(type:String, a_monster:Monster, attribute:String = 'id', amnt:int = 1) {
			super(type);
			monster = a_monster;
			stat = attribute;
			amount = amnt;
		}
	}
}