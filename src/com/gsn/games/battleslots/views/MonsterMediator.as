package com.gsn.games.battleslots.views
{
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.minigame.controllers.events.MinigameCompleteEvent;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.models.SlotModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MonsterMediator extends Mediator {
		
		
		[Inject]
		public var model:SlotModel; // Reference to the slot model
		[Inject]
		public var view:MonsterView;
		
		public function MonsterMediator() {
			super();
		}
		
		override public function onRegister():void {
			addContextListener(MonsterEvent.SET_ACTIVE,onMonsterChanged);
			addContextListener(MonsterEvent.ADD_STAT, onAddStat);
			addContextListener(MonsterEvent.BOOST_STAT, onBoost);
			addContextListener(MonsterEvent.ADD_XP, onXPGained);
			addContextListener(MinigameCompleteEvent.COMPLETE, onMinigameComplete);
			super.onRegister();
		}
		
		override public function onRemove():void {
			removeContextListener(MonsterEvent.SET_ACTIVE,onMonsterChanged);
			removeContextListener(MonsterEvent.ADD_STAT, onAddStat);
			removeContextListener(MonsterEvent.BOOST_STAT, onBoost);
			super.onRemove();
		}
		
		protected function onMinigameStart(e:Event):void {
			view.visible = false;
		}
		
		protected function onMinigameComplete(e:MinigameCompleteEvent):void {
			view.visible = true;
			(model.gameState.spinState as BattleSpinState).getActiveMonster().clearBoosts();
			dispatch(new GameEvent(GameEvent.SAVE_GAME_STATE));
			onMonsterChanged(new MonsterEvent(MonsterEvent.RESET_BOOSTS,(model.gameState.spinState as BattleSpinState).getActiveMonster()));
		}
		
		protected function onMonsterChanged(e:MonsterEvent):void {
			view.setMonsterData(e.monster);
		}
		
		protected function onXPGained(e:MonsterEvent):void {
			e.monster.addXP(e.amount);
			(model.gameState.spinState as BattleSpinState).changeActiveMonster(e.monster);
			dispatch(new GameEvent(GameEvent.SAVE_GAME_STATE));
			view.bounceStat(Monster.XP, e.amount);
			onMonsterChanged(e);
		}
		
		protected function onBoost(e:MonsterEvent):void {
			e.monster.addBoostToStat(e.stat,e.amount);
			(model.gameState.spinState as BattleSpinState).changeActiveMonster(e.monster);
			dispatch(new GameEvent(GameEvent.SAVE_GAME_STATE));
			view.bounceStat(e.stat, e.amount);
			onMonsterChanged(e);
		}
		
		protected function onAddStat(e:MonsterEvent):void {
			e.monster.addPermanentStat(e.stat, e.amount);
			(model.gameState.spinState as BattleSpinState).changeActiveMonster(e.monster);
			dispatch(new GameEvent(GameEvent.SAVE_GAME_STATE)); 
			view.bounceStat(e.stat, e.amount);
			onMonsterChanged(e);
		}
	}
}