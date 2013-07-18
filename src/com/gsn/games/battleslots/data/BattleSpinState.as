package com.gsn.games.battleslots.data {
	
	import com.gsn.games.shared.utils.DebugUtils;
	import com.gsn.games.slots.data.DataObject;
	import com.gsn.games.slots.data.SpinState;
	
	public class BattleSpinState extends SpinState {
		
		protected var _miniGameState:MiniGameState;
		//public var monsters:Array = [];
		public var activeMonsterIndex:int = 0;//Where the active monster is in this list. Start with the first one
		protected var m_monsterObjects:Array = [];
		
		public function BattleSpinState() { 
			super(); 
			generateStartingMonsters();
		}
		
		public function get monsters():Array {
			var result:Array = [];
			for (var idx:int = 0; idx < m_monsterObjects.length; idx++){
				result.push((m_monsterObjects[idx] as Monster).getSavableObject());
			}
			return result;
		}
		
		public function getMonsters():Array {
			return m_monsterObjects;
		}
		
		override public function toObject():Object {
			var result:Object = super.toObject();
			result.monsters = this.monsters;
			return result;
		}
		
		protected function generateStartingMonsters():void {
			var baseStats:Object = {};
			baseStats[Monster.ENERGY] = 1;
			//set up different base stats for each, for now. 
			baseStats[Monster.HEALTH] = 5;
			baseStats[Monster.ATTACK] = 2;
			baseStats[Monster.DEFENSE] = 2;
			var m:Monster = new Monster("pikachu_1",baseStats);
			m_monsterObjects.push( m);
			baseStats[Monster.DEFENSE] = 4;
			baseStats[Monster.ATTACK] = 1;
			baseStats[Monster.HEALTH] = 4;
			var m2:Monster = new Monster("squirtle_1",baseStats);
			m_monsterObjects.push(m2);
		}
		
		public override function setFromObject(obj:Object):void
		{
			if (!obj.hasOwnProperty("miniGameState")) {
				_miniGameState = null;
			}
			if (obj.hasOwnProperty("monsters")){
				var arr:Array = obj.monsters as Array;
				for (var idx:int = 0; idx < arr.length; idx++){
					m_monsterObjects[idx] = new Monster(arr[idx].id,arr[idx].baseStats, arr[idx].xp, arr[idx].boosts);
				}
			}
			super.setFromObject(obj);
		}
		
		override protected function setProperty(propName:String, obj:Object):void {
			switch (propName)
			{
				case "miniGameState":
					_miniGameState = DataObject.instantiate(obj[propName], "com.gsn.games.battleslots.data.MiniGameState", true);
					break;
				case "monsters":
					break;
				default:
					super.setProperty(propName, obj);
			}
		}
		
		public function changeActiveMonster(newMonster:Monster):void {
			DebugUtils.log("CHANGING ACTIVE MONSTER OUT FOR A NEW VERSION!");
			m_monsterObjects[activeMonsterIndex] = newMonster;
		}
		
		override public function get miniGameState():Object {
			return _miniGameState;
		}
		
		/**
		 * @param	Monster		monster		The monster object to set as the active monster.
		 */
		public function setMonsterActive(monster:Monster):void {
			activeMonsterIndex = m_monsterObjects.indexOf(monster);
		}
		
		public function getActiveMonster():Monster {
			return m_monsterObjects[activeMonsterIndex];
		}
	}
}