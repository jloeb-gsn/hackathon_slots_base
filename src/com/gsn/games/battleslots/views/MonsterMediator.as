package com.gsn.games.battleslots.views
{
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.battleslots.data.MonsterConstants;
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.battleslots.events.SKSSlotsDialogEvent;
	import com.gsn.games.minigame.controllers.events.MinigameCompleteEvent;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.events.SlotsDialogEvent;
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
			
			addContextListener(MonsterEvent.NEW_MONSTER, onMonsterGained);
			addContextListener(MinigameCompleteEvent.COMPLETE, onMinigameComplete);
			
			addContextListener(SlotsDialogEvent.DIALOG_OPENED, onDialogOpen);
			addContextListener(SlotsDialogEvent.DIALOG_CLOSED, onDialogClose);
			
			addViewListener(SKSSlotsDialogEvent.MONSTER_COLLECTION, dispatch);
			addViewListener(SKSSlotsDialogEvent.TRAINER_CARD, dispatch);
			super.onRegister();
		}
		
		override public function onRemove():void {
			removeContextListener(MonsterEvent.SET_ACTIVE,onMonsterChanged);
			removeContextListener(MonsterEvent.ADD_STAT, onAddStat);
			removeContextListener(MonsterEvent.BOOST_STAT, onBoost);
			removeContextListener(MonsterEvent.ADD_XP, onXPGained);
			removeContextListener(MinigameCompleteEvent.COMPLETE, onMinigameComplete);
			
			removeViewListener(SKSSlotsDialogEvent.MONSTER_COLLECTION, dispatch);
			removeViewListener(SKSSlotsDialogEvent.TRAINER_CARD, dispatch);
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
		
		protected function onDialogOpen(e:Event):void {
			view.toggleButtons(false);
		}
		
		protected function onDialogClose(e:Event):void {
			view.toggleButtons(true);
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
		
		protected function onMonsterGained(e:MonsterEvent):void {
			var choices:Array = (model.gameState.spinState as BattleSpinState).chooseNewMonsters(e.amount);
			if (choices.length == 1) {//if only one option, show the accept dialog
				dispatch(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.KEEP_MONSTER,'',choices));
			} else { //if multiple choices, show the choose dialog
				dispatch(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.OFFER_MONSTER_CHOICE,'',choices));
			}
		}
	}
}