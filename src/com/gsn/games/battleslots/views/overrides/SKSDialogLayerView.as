package com.gsn.games.battleslots.views.overrides {
	import com.gsn.games.battleslots.data.Monster;
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
		
		public function showHideMonsterCollection(monsterList:Array, activeMonster:Monster):void {
			
			if (monsterCollections == null) {
				monsterCollections = new MonsterCollectionView();
				monsterCollections.addEventListener(SlotsDialogEvent.DIALOG_CLOSED, onDialogClosed);
			}
			var show:Boolean = !this.contains(monsterCollections);
			if (show)
				monsterCollections.initializeMonsterData(monsterList,activeMonster);
			DebugUtils.log("showHideMonsterCollection : showing? "+show);
			ShowHideView(monsterCollections, show);
		}
		
		public function showHideTrainerCard(activeMonster:Monster):void {
			if (trainerCard == null) {
				trainerCard = new TrainerCardView();
				trainerCard.addEventListener(SlotsDialogEvent.DIALOG_CLOSED, onDialogClosed);
			}
			var show:Boolean = !this.contains(trainerCard);
			if (show){
				trainerCard.setupPanel(activeMonster);
			}
			
			ShowHideView(trainerCard, show);
		}
	}
}