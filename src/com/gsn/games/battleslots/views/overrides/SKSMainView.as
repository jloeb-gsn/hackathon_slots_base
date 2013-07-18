package com.gsn.games.battleslots.views.overrides {
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.battleslots.views.InviteFriendsView;
	import com.gsn.games.battleslots.views.MonsterView;
	import com.gsn.games.battleslots.views.TutorialLayerView;
	import com.gsn.games.shared.utils.LayerManager;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.views.MainView;
	
	import flash.events.Event;
	
	public class SKSMainView extends MainView {
		
		// PROPERTIES
		public var inviteFriendsView	:InviteFriendsView;
		public var tutorialLayer:TutorialLayerView; // Reference to the tutorials layer
		
		//test for ghostbusters
		public var monsterView:MonsterView;
		
		protected var isWheelShowing:Boolean = false;
		protected var cohortInviteFriends	:Boolean = false;
		
		public function SKSMainView() { super();}
		
        /**
        * This is a total override of the initialize function of the base class.
        * We don't want any logoview in skinnable slots.
        * So until we refactor the parent to make this happen, this is duplicated here.
        * */
        override protected function initialize(e:Event = null):void 
        {			
            super.initialize(e);
            // Adding the logo
			dispatchEvent(new GameEvent(MonsterEvent.SET_ACTIVE));
            layerManager.removeChild(logoView, LayerManager.FOREGROUND_LAYER);
            logoView = null;
        }

		
		override protected function addGameUI():void {
			// Adding the dialogs wrapper - this class handles the visibility of all other dialogs
			dialogLayer = new SKSDialogLayerView();
			layerManager.addChild(dialogLayer, LayerManager.DIALOGS_LAYER);
			gameUI = new SKSGameUIView();
			layerManager.addChild(gameUI, LayerManager.GUI_LAYER);
			monsterView = new MonsterView();
			layerManager.addChild(monsterView, LayerManager.DIALOGS_LAYER);
		}
		
		override protected function addBackground():void {
			bgView = new SKSBackgroundView();
			layerManager.addChild(bgView, LayerManager.BACKGROUND_LAYER);
		}
		
		/**
		 * Sets flag for cohort value from gameConfigManager in mediator.
		 */
		public function setInviteFriendsCohortFlag():void {
			cohortInviteFriends = true;
		}
		
	}
}