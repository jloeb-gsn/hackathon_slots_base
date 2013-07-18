package com.gsn.games.battleslots.data {
	import flash.utils.Dictionary;
	
	public class Monster {
		
		public static const HEALTH:String = "hp";
		public static const DEFENSE:String = "def";
		public static const ATTACK:String = "att";
		public static const ENERGY:String = "energy";
		public static const XP:String = "xp";
		public static const ID:String = "id";
		
		///Public monster properties due to the way instantiation from saved data happens. ////
		/** The unique id of the monster, independent of "species/type/name" */
		public var id:String;
		/** The name of the monster species that the user sees. */
		public var name:String;
		
		public var xp:Number;
		public var baseStats:Dictionary = new Dictionary();
		public var statBoosts:Dictionary = new Dictionary();
		
		///FUNCTIONS///
		
		/**
		 * Monster constructor -- all params optional due to 
		 * 
		 * @param	String		name		The unique id for the monster [species]_[unique#]
		 * @param	Dictionary	stats		The base stats for the monster [hp, def, att, energy]
		 * @param	Number		exp			The xp the monster has acquired
		 * @param	Dictionary	statsBoosts	The boosts to apply to the monsters stats.	
		 */
		public function Monster(name:String = "", stats:Object= null, exp:Number = 0, statsBoosts:Object = null) {
			var id_arr:Array = name.split('_');
			this.id = id_arr[1];
			this.name = id_arr[0];
			//break up name into species and unique id by "_"
			this.xp = exp;
			if (stats != null) {
				for (var str:String in stats) {
					this.baseStats[str] = stats[str];
				}
			}
			//if we are being passed boosts, add them
			if (statsBoosts != null) {
				for (var attr:String in statsBoosts) {
					this.statBoosts[attr] = statsBoosts[attr];
				}
			}
		}
		
		/**
		 * Returns the base stat (defaulting to 1 if the monster was set up incorrectly)
		 * 
		 * @param	String	type	The type of stat (ATTACK, HEALTH, ENERGY, etc.)
		 * 
		 * @return	Number	The monster's base value for the attribute
		 */
		public function getBaseStat(type:String):Number {
			return baseStats.hasOwnProperty(type) ? Number(baseStats[type]) : 1;
		}
		
		/**
		 * Returns the boost for the stat (defaulting to 0 if none is found)
		 * 
		 * @param	String	type	The type of stat (ATTACK, HEALTH, ENERGY, etc.)
		 * 
		 * @return	Number	The monster's boost value for the attribute
		 */
		public function getBoostForStat(type:String):Number {
			return statBoosts.hasOwnProperty(type) ? Number(statBoosts[type]) : 0;
		}
		
		/**
		 * Gets the boosted value (combined with the base value)
		 * 
		 * @param	String	type	The attribute name (HEALTH, ATTACK, etc.)
		 * @return	Number	The total combined value for the monster currently.
		 */
		public function getTotalStat(type:String):Number {
			var base:Number = getBaseStat(type);
			var mod:Number = getBoostForStat(type);
			return base + mod;
		}
		
		/**
		 * Empties out the current stat boosts
		 */
		public function clearBoosts():void {
			for (var attr:String in statBoosts){
				statBoosts[attr] = 0;
			}
		}
		
		public function addXP(amount:int):void {
			this.xp += amount;
		}
		
		/**
		 * Gets the level of the monster, based on the xp formula.
		 */
		public function getLevel():int {
			//for now, it's just 10xp per level always-- todo: make this a real thing.
			return int(Math.floor(xp/10.0) + 1);
		}
		
		/**
		 * The only way to permanently change stats.  Remember to trigger a save when doing this.
		 */
		public function addPermanentStat(statType:String, amount:int = 1):void {
			baseStats[statType] += amount;
		}
		
		/**
		 * The only way to permanently change stats.  Remember to trigger a save when doing this.
		 */
		public function addBoostToStat(statType:String, amount:int = 1):void {
			var prevValue:int = statBoosts.hasOwnProperty(statType) ? statBoosts[statType] : 0;
			statBoosts[statType] = amount + prevValue;
		}
		
		/**
		 * Returns the object format of this monster.
		 */
		public function getSavableObject():Object {
			var base:Object = {};
				base[Monster.ATTACK] = getBaseStat(Monster.ATTACK);
				base[Monster.DEFENSE] = getBaseStat(Monster.DEFENSE);
				base[Monster.ENERGY] = getBaseStat(Monster.ENERGY);
				base[Monster.HEALTH] = getBaseStat(Monster.HEALTH);
			
			var boost:Object = {};
			boost[Monster.ATTACK] = getBoostForStat(Monster.ATTACK);
			boost[Monster.DEFENSE] = getBoostForStat(Monster.DEFENSE);
			boost[Monster.ENERGY] = getBoostForStat(Monster.ENERGY);
			boost[Monster.HEALTH] = getBoostForStat(Monster.HEALTH);
			
			var result:Object = {
				"baseStats" : base,
				"boosts"	: boost
			};
			result[ID] = this.name+'_'+this.id;
			result[XP] = this.xp;
			return result;
		}
	}
}