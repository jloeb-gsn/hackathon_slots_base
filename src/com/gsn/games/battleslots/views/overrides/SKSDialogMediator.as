package com.gsn.games.battleslots.views.overrides
{
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.events.SKSSlotsDialogEvent;
	import com.gsn.games.slots.views.mediators.DialogMediator;
	
	import flash.events.Event;
	
	public class SKSDialogMediator extends DialogMediator {
		
		public function SKSDialogMediator() { super(); }
		
		protected var m_typeCastView:SKSDialogLayerView;
		
		/////REGISTER/Remove///////
		override public function onRegister():void {
			m_typeCastView = view as SKSDialogLayerView;
			addContextListener(SKSSlotsDialogEvent.MONSTER_COLLECTION, onMonsterCollection);
			addContextListener(SKSSlotsDialogEvent.TRAINER_CARD, onTrainerCard);
			addContextListener(SKSSlotsDialogEvent.OFFER_MONSTER_CHOICE, onChooseAMonster);
			addContextListener(SKSSlotsDialogEvent.KEEP_MONSTER, onOfferMonsterToKeep);
			super.onRegister();

		}
		
		override public function onRemove():void {
			removeContextListener(SKSSlotsDialogEvent.MONSTER_COLLECTION, onMonsterCollection);
			removeContextListener(SKSSlotsDialogEvent.TRAINER_CARD, onTrainerCard);
			super.onRemove();
		}
		
		protected function onMonsterCollection(e:Event):void {
			var bs:BattleSpinState = (model.gameState.spinState as BattleSpinState);
			m_typeCastView.showHideMonsterCollection(bs.getMonsters(), bs.getActiveMonster());
		}
		
		protected function onTrainerCard(e:Event):void {
			m_typeCastView.showHideTrainerCard((model.gameState.spinState as BattleSpinState).getActiveMonster());
		}
		
		protected function onOfferMonsterToKeep(e:SKSSlotsDialogEvent):void {
			
		}
		
		protected function onChooseAMonster(e:SKSSlotsDialogEvent):void {
			
		}
	}
}