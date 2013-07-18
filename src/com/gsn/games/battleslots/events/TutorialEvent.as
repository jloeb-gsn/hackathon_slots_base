package com.gsn.games.battleslots.events {
    import flash.events.Event;
    /**
     * This event is related to badges
     */
    public class TutorialEvent extends Event {
        protected static const TYPE:String = "TutorialEvent_";

		public static const SHOW_TUTORIAL_SCREEN:String = TYPE + "SHOW_TUTORIAL_SCREEN";
		public static const HIDE_TUTORIAL_SCREEN:String = TYPE + "HIDE_TUTORIAL_SCREEN";
        
		public var tutorialNum:int;
		public var extraData:Object;
		
		// A link to some data to communicate to the listener     
		public function TutorialEvent(type:String, tutNum:int = 0, extraDataObj:Object = null) {
			super(type);
			tutorialNum = tutNum;
			extraData = extraDataObj;
		}
		
		// Cloning needed to access source events as injection in command classes
		public override function clone():Event {
			return new TutorialEvent(type, tutorialNum);
		}
		
    }
}
