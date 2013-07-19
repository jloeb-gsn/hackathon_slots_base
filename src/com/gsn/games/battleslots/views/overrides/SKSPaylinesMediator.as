package com.gsn.games.battleslots.views.overrides {
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.battleslots.events.SKSMiniGameEvent;
	import com.gsn.games.slots.data.SlotEngineDefs;
	import com.gsn.games.slots.data.SpinOutcome;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.views.mediators.PaylinesMediator;
	
	public class SKSPaylinesMediator extends PaylinesMediator {
		public function SKSPaylinesMediator() { 
			SlotEngineDefs.paylineMarkers_x = 168;
			super(); 
		}
		
		// ------- Mediator overrides -------
		override public function onRegister():void {
			addContextListener(SKSMiniGameEvent.HIGHLIGHT_MINI_WHEEL_WIN_LINE, onHighlightWinLine, GameEvent);
			super.onRegister();
		}
		
		override public function onRemove():void {
			removeContextListener(SKSMiniGameEvent.HIGHLIGHT_MINI_WHEEL_WIN_LINE, onHighlightWinLine, GameEvent);
			
			super.onRemove();
		}
		
		override protected function shouldShowLineType(type:String):Boolean {
			return type != SKSMiniGameEvent.RESULT_TYPE_MINI_GAME;
		}
		
		override public function highlightWinLine(line:SpinOutcome, altMsg:String=null):void {
			if (line.symbols.length >= 4){
				trace("Got 4+ symbols-- applying bonussssss");
				applyStatsWinnings(line.outcomeId, line.symbols.length);
			}
			super.highlightWinLine(line, altMsg);
		}
		
		protected function applyStatsWinnings(outcomeId:int, numSymbols:int):void {
			var activeMonster:Monster = (model.gameState.spinState as BattleSpinState).getActiveMonster();
			var amount:int = (numSymbols == 5) ? 3: 1;
			var stat:String;
			switch (outcomeId) {//kinda jenky-- maybe find a better place for this mapping...
				case SlotEngineDefs.FIVE_ICON_AS: //health
				case SlotEngineDefs.FOUR_ICON_AS: //health
					stat = Monster.HEALTH;
					break;
				case SlotEngineDefs.FIVE_ICON_BS: //ATTACK
				case SlotEngineDefs.FOUR_ICON_BS: //ATTACK
					stat = Monster.ATTACK;
					break;
				case SlotEngineDefs.FIVE_ICON_CS: //DEFENSE
				case SlotEngineDefs.FOUR_ICON_CS: //DEFENSE
					stat = Monster.DEFENSE;
					break;
				case SlotEngineDefs.FIVE_ICON_DS: //ENERGY
				case SlotEngineDefs.FOUR_ICON_DS: //ENERGY
					stat = Monster.ENERGY;
					break;
				case SlotEngineDefs.FIVE_ICON_ES: //XP
				case SlotEngineDefs.FOUR_ICON_ES: //XP
					stat = Monster.XP;
					break;
				case SlotEngineDefs.FOUR_JACKPOTS://new monster flow- short circuit the rest of this 
				case SlotEngineDefs.FIVE_JACKPOTS:
					dispatch(new MonsterEvent(MonsterEvent.NEW_MONSTER,activeMonster,Monster.ID, amount));
					return;
			}
			if (stat == Monster.XP){//xp is a permanent buff, the rest are just boosts.
				dispatch(new MonsterEvent(MonsterEvent.ADD_XP,activeMonster,stat,amount));
			} else {
				dispatch(new MonsterEvent(MonsterEvent.BOOST_STAT,activeMonster,stat,amount));
			}
		}
	}
}