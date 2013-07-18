package com.gsn.games.battleslots.views.overrides {
	import com.gsn.games.battleslots.views.MonsterCollectionView;
	import com.gsn.games.battleslots.views.TrainerCardView;
	import com.gsn.games.shared.utils.DebugUtils;
	import com.gsn.games.slots.events.SlotsDialogEvent;
	import com.gsn.games.slots.views.dialogs.DialogLayerView;
	
	public class SKSDialogLayerView extends DialogLayerView {
		
		//add tutorial dialogs (and others) here.
		protected var trainerCard:TrainerCardView;
		protected var monsterCollections:MonsterCollectionView;
		
		public function SKSDialogLayerView() {
			super();
		}
		
		public function showHideMonsterCollection(monsterList:Array):void {
			
			if (monsterCollections == null) {
				monsterCollections = new MonsterCollectionView();
				monsterCollections.addEventListener(SlotsDialogEvent.DIALOG_CLOSED, onDialogClosed);
			}
			var show:Boolean = !this.contains(monsterCollections);
			if (show)
				monsterCollections.initializeMonsterData(monsterList);
			DebugUtils.log("showHideMonsterCollection : showing? "+show);
			ShowHideView(monsterCollections, show);
		}
		
		public function showHideTrainerCard(monsterList:Array):void {
			if (trainerCard == null) {
				trainerCard = new TrainerCardView();
				trainerCard.addEventListener(SlotsDialogEvent.DIALOG_CLOSED, onDialogClosed);
			}
			var show:Boolean = !this.contains(trainerCard);
			if (show){
				//do any initialization with data that needs to happen
			}
			
			ShowHideView(trainerCard, show);
		}
	}
}