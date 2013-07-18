package com.gsn.games.battleslots.data
{
    import com.gsn.games.slots.data.SpinState;
    import com.gsn.games.slots.data.DataObject;

	public class MiniGameMove extends DataObject
	{
		public var moneySlotNumber:Number;
		public var totalPayout:Number;
		public var badgesWon:Array;
		public var type:String;
		public var multiplier:Number;
		public var newGameState:SpinState;		
	}
}