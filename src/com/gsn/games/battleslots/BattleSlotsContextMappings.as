/**
 * SkinnableSlotsContextMappings.as
 * 
 * Overrides the mappings of views/mediators/commands that the base swc shouldn't be using.
 */
package com.gsn.games.battleslots {
	import com.gsn.games.battleslots.commands.AddSKSMainViewCommand;
	import com.gsn.games.battleslots.commands.AwardBadgeCommand;
	import com.gsn.games.battleslots.commands.BattleSpinWinCommand;
	import com.gsn.games.battleslots.commands.SKSConfigureCommand;
	import com.gsn.games.battleslots.commands.SKSSpinCommand;
	import com.gsn.games.battleslots.data.BattleSpinState;
	import com.gsn.games.battleslots.models.SKSSlotsGameModel;
	import com.gsn.games.battleslots.models.TutorialModel;
	import com.gsn.games.battleslots.views.BackgroundMediator;
	import com.gsn.games.battleslots.views.MonsterCollectionMediator;
	import com.gsn.games.battleslots.views.MonsterCollectionView;
	import com.gsn.games.battleslots.views.MonsterMediator;
	import com.gsn.games.battleslots.views.MonsterView;
	import com.gsn.games.battleslots.views.TrainerCardMediator;
	import com.gsn.games.battleslots.views.TrainerCardView;
	import com.gsn.games.battleslots.views.TutorialLayerMediator;
	import com.gsn.games.battleslots.views.TutorialLayerView;
	import com.gsn.games.battleslots.views.overrides.SKSBackgroundView;
	import com.gsn.games.battleslots.views.overrides.SKSDialogLayerView;
	import com.gsn.games.battleslots.views.overrides.SKSDialogMediator;
	import com.gsn.games.battleslots.views.overrides.SKSGameUIMediator;
	import com.gsn.games.battleslots.views.overrides.SKSGameUIView;
	import com.gsn.games.battleslots.views.overrides.SKSMainMediator;
	import com.gsn.games.battleslots.views.overrides.SKSMainView;
	import com.gsn.games.battleslots.views.overrides.SKSPaylinesMediator;
	import com.gsn.games.battleslots.views.overrides.SKSSlotsUIMediator;
	import com.gsn.games.core.controllers.events.DataRequestEvent;
	import com.gsn.games.core.controllers.events.PlayerManagerEvent;
	import com.gsn.games.core.controllers.events.StartupEvent;
	import com.gsn.games.slots.commands.MinigameMoveCommand;
	import com.gsn.games.slots.data.SpinState;
	import com.gsn.games.slots.engine.SlotsContextMapper;
	import com.gsn.games.slots.engine.SlotsGameContext;
	import com.gsn.games.slots.events.BadgeEvent;
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.events.MiniGameEvent;
	import com.gsn.games.slots.events.SpinRequestEvent;
	import com.gsn.games.slots.models.SlotsGameModel;
	import com.gsn.games.slots.views.dialogs.PayTableView;
	import com.gsn.games.slots.views.dialogs.PaylinesView;
	import com.gsn.games.slots.views.dialogs.SlotsUIView;
	import com.gsn.games.slots.views.mediators.PayTableMediator;
	
	public class BattleSlotsContextMappings extends SlotsContextMapper {
		public function BattleSlotsContextMappings(context:SlotsGameContext) {
			super(context);
		}
		
		override protected function setupInjections():void {
			super.setupInjections();
			m_context.contextInjector.mapSingleton(SKSSlotsGameModel);
			m_context.contextInjector.mapSingleton(TutorialModel);
			
			mapRobotLegsInjections();
		}
		
		private function mapRobotLegsInjections():void {
			//Tells robotlegs to inject the inherited class instead of the parent-- robotlegs appears to treat
			//injections based on class name, rather than type (which makes sense)
			m_context.contextInjector.mapClass(SlotsGameModel, SKSSlotsGameModel);
			m_context.contextInjector.mapClass(SpinState, BattleSpinState);
		}
		
		override protected function addMainViewsAndMediators():void {
			m_context.contextMediatorMap.mapView(SKSBackgroundView, BackgroundMediator);
			m_context.contextMediatorMap.mapView(SKSMainView, SKSMainMediator);
			m_context.contextMediatorMap.mapView(SlotsUIView, SKSSlotsUIMediator);
			m_context.contextMediatorMap.mapView(SKSGameUIView, SKSGameUIMediator);
			m_context.contextCommandMap.mapEvent(StartupEvent.GAMEFORGE2_READY, AddSKSMainViewCommand, StartupEvent);
		}
		
		override protected function addDialogLayerView():void {
			m_context.contextMediatorMap.mapView(SKSDialogLayerView, SKSDialogMediator);
		}
		
		override protected function addPaylinesAndPayTable():void {
			m_context.contextMediatorMap.mapView(PaylinesView, SKSPaylinesMediator);
			m_context.contextMediatorMap.mapView(PayTableView, PayTableMediator);
		}
		
		override protected function mediatorViewSetup():void {
			super.mediatorViewSetup();
			m_context.contextMediatorMap.mapView(TutorialLayerView, TutorialLayerMediator);
			m_context.contextMediatorMap.mapView(MonsterView, MonsterMediator);
			m_context.contextMediatorMap.mapView(TrainerCardView, TrainerCardMediator);
			m_context.contextMediatorMap.mapView(MonsterCollectionView, MonsterCollectionMediator);
			//add other tutorial views here too
		}
		
		override protected function mediatorDialogSetup():void {
			super.mediatorDialogSetup();
		}
		
		override protected function setupSpinCommands():void {
			// Moves forward with the state machine associated to the spin command
			m_context.contextCommandMap.mapEvent(SpinRequestEvent.REQUEST_SPIN, SKSSpinCommand, DataRequestEvent);
			m_context.contextCommandMap.mapEvent(GameEvent.PROCESS_SPIN_WIN_CYCLE_COMMAND, BattleSpinWinCommand);
		}
		
		override protected function setUpConfigureCommands():void {
			m_context.contextCommandMap.mapEvent(PlayerManagerEvent.PLAYERMANAGER_STARTUP_COMPLETE, SKSConfigureCommand);	
		}
		
		override protected function setupCommandMap():void {
			super.setupCommandMap();
			// Badges
			m_context.contextCommandMap.mapEvent(BadgeEvent.AWARD_BADGES, AwardBadgeCommand);
			//Minigame
			m_context.contextCommandMap.mapEvent(MiniGameEvent.MINIGAME_MOVE, MinigameMoveCommand, DataRequestEvent);
		}
		
	}
}