package com.gsn.games.battleslots.views
{
	import com.gsn.games.core.controllers.events.SendInviteEvent;
	import com.gsn.games.slots.services.GameAnalytics;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * Mediator : communication point between a view and the game.
	 * This class should not have any UI Logic.
	 */
	public class InviteFriendsMediator extends Mediator {
		// INJECTIONS
		// Reference to the view mapped to this mediator
		[Inject]
		public var view			:InviteFriendsView;
		[Inject]
		public var analytics	:GameAnalytics; // Reference to the Analytics manager
		
		// Needed to inject properties of view
		//[Inject]
		//public var injector:IInjector;
		
		// CONSTANTS
		
		// PROPERTIES
		
		// GETTERS/SETTERS
		
		// PUBLIC
		/**
		 * Fired as soon as the mapped View is added to stage.
		 * */
		override public function onRegister():void 
		{
			trace("onRegister+++");
			
			// Add View listeners here
			addViewListener(SendInviteEvent.SEND_INVITE, onInviteFriends);
			
			// <Add contextListeners here>
			addContextListener(SendInviteEvent.SEND_INVITE_COMPLETE, onSendInviteComplete);
			addContextListener(SendInviteEvent.SEND_INVITE_CANCEL, onSendInviteCancel);
			
			
			// Call the super.onRegister() to complete mediation
			super.onRegister();
			trace("onRegister---");
		}
		
		/**
		 * Fired when the view is removed from the stage.
		 * Handle all cleanup of eventListeners here.
		 * */
		override public function onRemove():void {
			
			// Clean up listeners
			//removeViewListener(MyGameEvent.SOME_VIEW_EVENT, dispatch);
			//removeContextListener(MyGameEvent.SOME_GAME_EVENT, onSomeEvent);
			
			// <Add your code here>
			
			// Call the super.onRemove() to complete removal of the mediator
			super.onRemove();
		}
		
		// PRIVATE
		protected function onInviteFriends(event:SendInviteEvent):void
		{
			//Analytics
			analytics.trackEvent(GameAnalytics.CAT_INVITE_FRIENDS, GameAnalytics.ACT_SHOW_DIALOG, GameAnalytics.LAB_INVITE_PANEL);
			
			dispatch(event);
		}
		
		protected function onSendInviteComplete(event:SendInviteEvent):void
		{
			analytics.trackEvent(GameAnalytics.CAT_INVITE_FRIENDS, GameAnalytics.ACT_SHOW_DIALOG, GameAnalytics.LAB_SUCCESS);
		}
		protected function onSendInviteCancel(event:SendInviteEvent):void
		{
			analytics.trackEvent(GameAnalytics.CAT_INVITE_FRIENDS, GameAnalytics.ACT_CANCELED, GameAnalytics.LAB_CANCEL);
		}
		
	}
	
}
