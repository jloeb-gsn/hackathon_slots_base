package com.gsn.games.battleslots.views
{
	import com.gsn.games.slots.events.GameEvent;
	import com.gsn.games.slots.events.FreeSpinsMiniGameEvent;
	import com.gsn.games.battleslots.views.overrides.SKSBackgroundView;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * Mediator : communication point between a view and the game.
	 * This class should not have any UI Logic.
	 */
	public class BackgroundMediator extends Mediator
	{
		
		// INJECTIONS
		// Reference to the view mapped to this mediator
		[Inject]
		public var view:SKSBackgroundView;
		
		// PROPERTIES
		protected var testInFreeSpins:Boolean = false;
		
		// GETTERS/SETTERS
		
		
		// PUBLIC
		/**
		 * Fired as soon as the mapped View is added to stage.
		 * */
		override public function onRegister():void
		{
			
			// Listeners to the view - re-dispatch automatically to game 
			//addViewListener(GameEvent.UPDATE_MODEL, dispatch);
			
			// Listeners to the game
			addContextListener(FreeSpinsMiniGameEvent.FREE_SPINS_VALUE_SELECTED, onStartFreeSpins);
			addContextListener(FreeSpinsMiniGameEvent.END_FREE_SPINS, onEndFreeSpins);
			// Call the super.onRegister() to complete mediation
			super.onRegister();
		}
		
		/**
		 * Fired when the view is removed from the stage.
		 * Handle all cleanup of eventListeners here.
		 * */
		override public function onRemove():void
		{
			//removeContextListener(StartupEvent.GAMEFORGE2_READY, onGameModelUpdated, StartupEvent);
			
			// Call the super.onRemove() to complete removal of mediator
			super.onRemove();
		}
		
		
		// PROTECTED
		protected function onStartFreeSpins(event:GameEvent):void
		{
			view.switchFreePlay(true);
		}
		protected function onEndFreeSpins(event:GameEvent):void
		{
			view.switchFreePlay(false);
		}
		
		// PRIVATE
		
		
	}
	
}

