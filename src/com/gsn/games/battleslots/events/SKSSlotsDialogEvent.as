package com.gsn.games.battleslots.events {
	import com.gsn.games.slots.events.SlotsDialogEvent;
	
	public class SKSSlotsDialogEvent extends SlotsDialogEvent {
		//Labels
		public static var SHARE_WHEEL_WIN	:String = "shareWheelWin";
		
		//Types
		public static const SHOW_WHEEL_SPIN_SUMMARY	:String	= "showWheelSpinSummary";
		public static const WHEEL_MINI_GAME_SUMMARY_CLOSED:String = "wheelMiniGameSummaryClosed";
		
		
		public function SKSSlotsDialogEvent(type:String, label:String="") {
			super(type, label);
		}
	}
}