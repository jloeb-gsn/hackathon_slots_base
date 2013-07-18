package com.gsn.games.battleslots.ui
{
    import com.gsn.shared.Utils;
    
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.gsn.games.slots.ui.DialogHelper;

    public class BadgeDialogHelper extends DialogHelper
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

		public var badgeId:int;

        //--------------------------------------------
        // Protected & Private Properties
        //--------------------------------------------

        //--------------------------------------------
        // Getters & Setters
        //--------------------------------------------
		
		public function get tokenAward():Number
		{
			return parseFloat(mc.tokensTxt.text);
		}
		public function set tokenAward(amt:Number):void
		{
			mc.tokensTxt.text = Utils.numToCurrency(amt);
		}
		
		public function get badgeName():String
		{
			return mc.badgeNameTxt.text;
		}
		public function set badgeName(name:String):void
		{
			mc.badgeNameTxt.text = name;
		}
		
        //--------------------------------------------
        // Public Methods
        //--------------------------------------------

        public function BadgeDialogHelper(clip:MovieClip = null)
        {
            super(clip);
        }

        public override function setRequiredProps():void
        {
            //requiredProps = ["messageTxt", "imageHolder"];
        }
		
		public function setImage(bmp:Bitmap):void
		{
			if (bmp)
			{
				mc.imageHolder.addChild(bmp);
			}
		}
		
		public function removeImage():void
		{
			while (mc.imageHolder.numChildren > 0)
			{
				mc.imageHolder.removeChildAt(0);
			}
		}


        //--------------------------------------------
        // Event Handlers
        //--------------------------------------------


        //--------------------------------------------
        // Protected & Private Methods
        //--------------------------------------------

    }
}
