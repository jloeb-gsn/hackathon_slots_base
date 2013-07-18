package com.gsn.games.battleslots.events {
	import flash.events.Event;
	
	public class SKSAnalyticsEvents extends Event {
		
		
		
		//acts
		public static const ACT_SHOW_TUTORIAL:String    = "showTutorial";
		
		//categories
		public static const CAT_TUT_SCR_1:String      = "tutorial_screen_1";
		
		//labels
		public static const LAB_TUT_AGREE:String	=	"tutorial_click_ok";
		
		
		public function SKSAnalyticsEvents(type:String) {
			super(type);
		}
	}
}