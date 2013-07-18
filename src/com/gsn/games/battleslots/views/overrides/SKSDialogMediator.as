package com.gsn.games.battleslots.views.overrides
{
	import com.gsn.games.slots.views.mediators.DialogMediator;
	
	public class SKSDialogMediator extends DialogMediator {
		
		public function SKSDialogMediator() { super(); }
		
		protected var m_typeCastView:SKSDialogLayerView;
		
		/////REGISTER/Remove///////
		override public function onRegister():void {
			m_typeCastView = view as SKSDialogLayerView;
			
			super.onRegister();

		}
		
		override public function onRemove():void {
			super.onRemove();
		}
		
		
	}
}