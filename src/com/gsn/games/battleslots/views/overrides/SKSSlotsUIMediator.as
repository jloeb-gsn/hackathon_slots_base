package com.gsn.games.battleslots.views.overrides {
	
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.views.mediators.SlotsUIMediator;
	import com.gsn.games.battleslots.models.TutorialModel;
	
	public class SKSSlotsUIMediator extends SlotsUIMediator {
		
		[Inject]
		public var tutorial:TutorialModel;
		
		public function SKSSlotsUIMediator() {
			super();
		}
		
		override protected function getSpinEventParams(e:GameEvent):Object {
			var obj:Object = super.getSpinEventParams(e);
			//////TUTORIAL COHORT//////
			if (tutorial.shouldSpinBeFree){
				obj["tutorialMode"] = "sequential";
			}
			return obj;
		}
	}
}