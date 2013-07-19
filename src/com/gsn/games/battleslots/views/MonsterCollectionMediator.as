package com.gsn.games.battleslots.views {
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.slots.models.SlotModel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MonsterCollectionMediator extends Mediator {
		
		[Inject]
		public var model:SlotModel;
		
		public function MonsterCollectionMediator()
		{
			super();
		}
		
		override public function onRegister():void {
			super.onRegister();
			addViewListener(MonsterEvent.SET_ACTIVE, onMonsterChoose, MonsterEvent);
		}
		
		protected function onMonsterChoose(e:MonsterEvent):void {
			trace("Setting monster active: "+e.monster.name);
			(model.gameState.spinState as BattleSpinState).setMonsterActive(e.monster);
			dispatch(new MonsterEvent(e.type, e.monster, e.stat, e.amount));
		}
	}
}