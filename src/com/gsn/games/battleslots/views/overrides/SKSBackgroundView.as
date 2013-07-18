package com.gsn.games.battleslots.views.overrides
{
	import com.gsn.games.slots.views.dialogs.BackgroundView;
	
	import flash.geom.ColorTransform;
	
	public class SKSBackgroundView extends BackgroundView
	{
		public function SKSBackgroundView()
		{
			super();
		}
		
        public function switchFreePlay(onOrOff:Boolean = true):void
		{
			circLeft.switchFreePlay(onOrOff);
			circRight.switchFreePlay(onOrOff);
			
			var colorTransform:ColorTransform;
			if (!onOrOff)
			{
				stopAnimating();
				colorTransform = new ColorTransform();
				tintPanelBg(colorTransform);
			}
			else
			{
				animate();
				//Get tint from tintClip.
				colorTransform = freeSpinTint.tintClip.transform.colorTransform;
				tintPanelBg(colorTransform, 1);
			}
		}
	}
}