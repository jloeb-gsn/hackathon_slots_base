package com.gsn.games.battleslots.views
{
    import com.gsn.games.core.controllers.events.SendInviteEvent;
    import com.gsn.games.core.models.common.datarequests.vo.SendInviteVO;
    import com.gsn.games.shared.assetsmanagement.AssetManager;
    import com.gsn.games.shared.assetsmanagement.AssetVO;
    import com.gsn.games.shared.ui.BaseView;
    import com.gsn.games.shared.utils.FlashUtils;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class InviteFriendsView extends BaseView {

        // PROPERTIES
        // Button for opening the invitation view
        private var pnl_InviteBtn:Sprite;
        private var btn_InviteFriends:MovieClip;


        // PUBLIC
        public function InviteFriendsView() {
            super();

            //
            initInvite();
        }


        // PROTECTED
        /**
         * Request assets for CLICK TO SPIN tutorial screen.
         */
        protected function initInvite():void {

            var v:Vector.<String> = new Vector.<String>();
            v.push("BTN_InviteFriends");
            v.push("PANEL_InviteFriendsButton");

            AssetManager.instance.bulkRequest(v, onAssetsLoadedInviteGUI);
        }

        private function onAssetsLoadedInviteGUI(v:Vector.<AssetVO>):void {
            // Loop over all assets returned from request

            for each (var vo:AssetVO in v) {
                switch (vo.name) {
                    case "PANEL_InviteFriendsButton":
                        pnl_InviteBtn = vo.asset as Sprite;
                        this.addChild(pnl_InviteBtn);
                        break;
                    case "BTN_InviteFriends":
                        btn_InviteFriends = vo.asset as MovieClip;
                        break;
                }
            }

            buildHomePanel();

        }

        private function buildHomePanel():void {
            // The panel containing the collections button on the main game page

            if (pnl_InviteBtn && btn_InviteFriends) {
                FlashUtils.swapSymbols("PROP_button", btn_InviteFriends, pnl_InviteBtn);
				btn_InviteFriends.addEventListener(MouseEvent.CLICK, onInviteClick);
                    // Disabled until gameState is loaded and initialize() is called
                    //inviteMCB.enabledOverride = true;
                    //inviteMCB.enabled = false;
            }
        }

        private function onInviteClick(event:MouseEvent):void {
            var msg:String = "Invite some friends to play!";
            var msgTitle:String = "Invite Friends!";
            var msgKey:String = "wof.invite.friends";
            var gameData:String = "game.data";
//            var excludeEncryptedIds:Array;
//            var includeEncryptedIds:Array;
			
			//Dispatach event to mediator.var sendInviteEvent:SendInviteEvent = new SendInviteEvent(SendInviteEvent.SEND_INVITE);
			var sendInviteEvent:SendInviteEvent = new SendInviteEvent(SendInviteEvent.SEND_INVITE);
			var sendInviteVO:SendInviteVO = new SendInviteVO(msg, msgTitle, msgKey, gameData);
			sendInviteEvent.vo = sendInviteVO;
			dispatchEvent(sendInviteEvent);
        }
    }
}
