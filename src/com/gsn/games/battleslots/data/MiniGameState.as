package com.gsn.games.battleslots.data
{
	import com.gsn.games.slots.data.DataObject;

    public class MiniGameState extends DataObject
    {
        //--------------------------------------------
        // Static Properties
        //--------------------------------------------
        
        
        //--------------------------------------------
        // Static Methods
        //--------------------------------------------
        
        
        //--------------------------------------------
        // Public Properties
        //--------------------------------------------
        
        public var engineName:String = "";
        public var verificationKey:String = "";
        public var verificationKeyUsageCount:int = 1;
		public var tokensBet:int = 1;
        
        //--------------------------------------------
        // Protected & Private Proerties
        //--------------------------------------------
        
        
        //--------------------------------------------
        // Getters & Setters
        //--------------------------------------------
        
        
        //--------------------------------------------
        // Public Methods
        //--------------------------------------------
        
        public function MiniGameState()
        {
            super();
        }
        
        //--------------------------------------------
        // Event Handlers
        //--------------------------------------------
        
        
        
        //--------------------------------------------
        // Protected & Private Methods
        //--------------------------------------------
        
    }
}