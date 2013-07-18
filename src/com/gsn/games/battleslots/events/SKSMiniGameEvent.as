package com.gsn.games.battleslots.events
{
    import com.gsn.games.slots.data.MiniGameResult;
    
    import flash.events.Event;

    public class SKSMiniGameEvent extends Event
    {
        public static const READY_TO_SELECT:String = "readyToSelect";
        public static const VALUE_SELECTED:String = "valueSelected";
        public static const MINIGAME_COMPLETE:String = "minigameComplete";
        public static const BACK_TO_GAME:String = "backToGame";
        public static const SHARE_SUMMARY   :String = "shareSummary";

        public static const PLAY_WHEEL_GAME     :String = "playWheelGame";
        public static const PLAY_FREE_GAME      :String = "playFreeGame";
        public static const PLAY_ENVELOPE_GAME  :String = "playEnvelopeGame";
        public static const WHEEL_SHOWN         :String = "wheelShown";
        public static const SPIN_WHEEL          :String = "spinWheel";
		
		//From GameEvent.as
		public static const WHEEL_MINI_GAME_WON	:String = "WheelMiniGameWon";
		public static const	SHOW_WHEEL_MINI_GAME	:String	= "showWheelMiniGame";
		public static const	WHEEL_MINI_GAME_HIDDEN	:String	= "wheelMiniGameHidden";
		public static const LAUNCH_WHEEL_MINI_GAME	:String = "LaunchWheelMiniGame";
		public static const WHEEL_MINI_GAME_BUY_RESPIN_CLICKED:String = "wheelMiniGameBuyRespinClicked";
		public static const WHEEL_MINI_GAME_REVEALED:String = "wheelMiniGameRevealed";
		public static const WHEEL_MINI_GAME_SPIN_BTN_CLICKED:String = "WheelMiniGameSpinBtnClicked";
		public static const WHEEL_MINI_GAME_SPIN_BEGUN:String = "wheelMiniGameSpinClicked";
		public static const HIGHLIGHT_MINI_WHEEL_WIN_LINE:String = "highlightMiniWheelWinLine"; 	//For highlighting just the WheelMiniGame win line.
		public static const DO_BUY_A_RESPIN:String        = "doBuyARespin";
		//from gameenginedefs
		public static const WHEEL_MINI_GAME_ART_SCALAR:Number = 0.4222222;
		public static const RESULT_TYPE_MINI_GAME:String = "MoneyWheelMiniGameResult";

		
        // Data
        public var gameName:String;
        public var value:int;
        public var betUnit:int;
        public var minigameResult:MiniGameResult;
        public var cumulativeSpinWin:Number = 0;

        public function SKSMiniGameEvent(type:String, gameName:String = "")
        {
            super(type, false, false);
            this.gameName = gameName;
        }

        public override function clone():Event
        {
            var newEvent:SKSMiniGameEvent = new SKSMiniGameEvent(this.type, this.gameName);
            newEvent.value = value;
            newEvent.betUnit = betUnit;
            newEvent.minigameResult = minigameResult;
            newEvent.cumulativeSpinWin = cumulativeSpinWin;
            return newEvent;
        }
    }
}