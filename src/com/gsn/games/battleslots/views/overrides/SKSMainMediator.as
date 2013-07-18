package com.gsn.games.battleslots.views.overrides
{
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.data.TutorialType;
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.battleslots.events.TutorialEvent;
	import com.gsn.games.battleslots.models.TutorialModel;
	import com.gsn.games.shared.utils.DebugUtils;
	import com.gsn.games.slots.data.DataObject;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.events.SlotsDialogEvent;
	import com.gsn.games.slots.views.mediators.MainMediator;
	
	import flash.events.Event;
	
	public class SKSMainMediator extends MainMediator {
		public function SKSMainMediator() { super();}
		
		////////PROPERTIES/////////////////
		protected var m_typeCastedView:SKSMainView;
		
		/////////INJECTIONS/////////////
		[Inject]
		public var tutorialModel:TutorialModel;
		
		//////OVERRIDES//////////////
		
		/**
		 * When the Mediator is registered, add your listeners.
		 * I have included a few examples here.
		 * */
		override public function onRegister():void {
			super.onRegister();
			///////////////This is strange, but must be done/////////////
			m_typeCastedView = view as SKSMainView;
			
			//Additional wof-specific context listeners
			addContextListener(GameEvent.STEPS_COMPLETE, onStepsComplete);
			addViewListener(MonsterEvent.SET_ACTIVE, onMonsterConfigured);
			
			//addContextListener(MonsterEvent.ADD_STAT, dispatch);
			//addContextListener(MonsterEvent.BOOST_STAT, dispatch);
			//Tutorial and invite features 
			if(gameConfigManager.settings.extraFlashVars["WofInviteFriends"] == "true") {
				m_typeCastedView.setInviteFriendsCohortFlag();
			}
			tutorialModel.applyFlashVars(gameConfigManager.settings.extraFlashVars, playerMgr.settings.facebookUserId, Boolean(model.gameState.spinState.spinNumber < 20));	
		}
		
		
		/**
		 * Fired when the view is removed from the stage.
		 * Handle all cleanup of eventListeners here.
		 * */
		override public function onRemove():void {
			removeContextListener(GameEvent.STEPS_COMPLETE, onStepsComplete);
		}
		
		protected function onMonsterConfigured(e:Event):void {
			var ss:BattleSpinState = (model.gameState.spinState) as BattleSpinState;
			if (ss == null){
				ss = DataObject.instantiate(model.gameState.spinState, "com.gsn.games.battleslots.data.BattleSpinState", true);
			}
			dispatch(new MonsterEvent(MonsterEvent.SET_ACTIVE, ss.getActiveMonster()));
		}
		
		override protected function onDialogOpened(e:SlotsDialogEvent):void {
			super.onDialogOpened(e);
			//m_typeCastedView.showHideMonsterElem(false);
		}
		
		override protected function onDialogClosed(e:SlotsDialogEvent):void {
			super.onDialogClosed(e);
			//m_typeCastedView.showHideMonsterElem(true);
		}
		
		override protected function onResume(e:Event):void {
			super.onResume(e);
			// If the new user tutorial hasn't been shown yet, show it now. SKIP if there are not enough tokens to bet. (Shouldn't happen, but just in case.)
			if ((!tutorialModel.wasClickToSpinShown) && (playerMgr.tokens >= model.paylinesVO.totalBet) && (playerMgr.tokens>0)) {
				var theEvent:TutorialEvent = new TutorialEvent(TutorialEvent.SHOW_TUTORIAL_SCREEN, TutorialType.CLICK_TO_SPIN);
				dispatch(theEvent);
			}
		}
		
		//TUTORIAL RELATED
		protected function onStepsComplete(event:GameEvent):void {
			// If we are showing the second spin, show the second spin tutorial panel BUT SKIP if there aren't enough tokens for a spin
			if ((!tutorialModel.wasSpinAgainShown) && (playerMgr.tokens >= model.paylinesVO.totalBet) && (playerMgr.tokens>0)) {
				DebugUtils.log("### - Show the WoF Slots 'Spin Again' Tutorial");
				var theEvent:TutorialEvent = new TutorialEvent(TutorialEvent.SHOW_TUTORIAL_SCREEN, TutorialType.SPIN_AGAIN);
				dispatch(theEvent);
			}
		}
		
	}
}