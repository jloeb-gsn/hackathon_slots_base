package com.gsn.games.battleslots {

    import com.gsn.games.core.views.gameapp.CoreGameApp;
    import com.gsn.games.shared.utils.DebugUtils;
    import com.gsn.games.slots.engine.SlotsContextMapper;
    import com.gsn.games.slots.engine.SlotsGameContext;

	// AUTOMATED METADATA. DO NOT UPDATE.This metadata is replaced by the ANT task during compile
	[SWF(width="760", height="550", framerate="30", backgroundColor="#FFFFFF")]
	
    public class GameApp extends CoreGameApp {

        //
        public function GameApp() {
			DebugUtils.loggingLevel = DebugUtils.VERBOSE;
            // Initialize the GameContext
			var mappings:SlotsContextMapper = new BattleSlotsContextMappings(new SlotsGameContext(this));
			context = mappings.context;
			
        }
    }
}
