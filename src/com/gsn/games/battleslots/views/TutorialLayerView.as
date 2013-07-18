package com.gsn.games.battleslots.views {
    import com.gsn.games.core.models.languagemanager.LanguageManager;
    import com.gsn.games.shared.ui.BaseView;
    import com.gsn.games.shared.utils.DebugUtils;
    import com.gsn.games.battleslots.data.TutorialType;
    import com.gsn.games.battleslots.events.TutorialEvent;
    
    import flash.display.Sprite;
    
    import org.robotlegs.core.IInjector;

    /**
    * Container for all dialogs.
    * Will be deprecated shortly as we move all dialogs/views handling to the main view
    * */
    public class TutorialLayerView extends BaseView {
		// Needed to inject properties of view
		[Inject]
		public var injector:IInjector;
        //--------------------------------------------
        // Static Properties
        //--------------------------------------------

        //--------------------------------------------
        // Static Methods
        //--------------------------------------------


        //--------------------------------------------
        // Public Properties
        //--------------------------------------------

        // References to all dialogs used in the game
		
        //--------------------------------------------
        // Protected & Private Proerties
        //--------------------------------------------
        protected var closeBtnClass:Class;
        protected var greenBtnClass:Class;
        
        //--------------------------------------------
        // Getters & Setters
        //--------------------------------------------


        //--------------------------------------------
        // Public Methods
        //--------------------------------------------

        public function TutorialLayerView() {
            DebugUtils.log("TutorialLayerView(clip)");
            super();
        }

		/**
		 * Generic function to show or hide a view.
		 * */
		public function showHideTutorial(tutNum:int, show:Boolean=true, disableUI:Boolean=false):void {
			var view:Sprite;
			
			switch(tutNum) {
				
				default:
					break;
			}
			
			if (show) {
				addChild(view);
			} else if (this.contains(view)) {
				removeChild(view);
			}
		}

        //--------------------------------------------
        // Event Handlers
        //--------------------------------------------


		
		
		//--------------------------------------------
		// Protected & Private Methods
		//--------------------------------------------
        
        /**
        * Closes the view that dispatched the event
        * */
        protected function onTutorialClosed(event:TutorialEvent):void {
			showHideTutorial(event.tutorialNum, false);
            // Redispatch the closed dialog event
            dispatchEvent(event);
        }


    }
}
