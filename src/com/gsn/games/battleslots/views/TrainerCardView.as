package com.gsn.games.battleslots.views
{
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.battleslots.data.MonsterConstants;
	import com.gsn.games.battleslots.events.SKSSlotsDialogEvent;
	import com.gsn.games.shared.assetsmanagement.AssetManager;
	import com.gsn.games.shared.assetsmanagement.AssetVO;
	import com.gsn.games.shared.components.mcbutton.MCButton;
	import com.gsn.games.shared.ui.BaseView;
	import com.gsn.games.shared.utils.DebugUtils;
	import com.gsn.games.shared.utils.FlashUtils;
	import com.gsn.games.slots.events.SlotsDialogEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TrainerCardView extends BaseView {
		
		protected var m_baseAsset:Sprite;
		protected var btn_backToGame:MovieClip;
		protected var btn_challenge:MovieClip;
		
		protected var returnMCB:MCButton;
		protected var challengeMCB:MCButton;
		
		public function TrainerCardView() {
			super();//PANEL_trainercard
			initAssetLoads();
		}
		
		protected function initAssetLoads():void {
			var v:Vector.<String> = new Vector.<String>();
			v.push("PANEL_trainercard");
			v.push("BTN_Popup_BackToGame");
			v.push("BTN_Popup_Challenge");
			new MonsterConstants();
			for (var idx:int = 0; idx < MonsterConstants.monsters.length; idx++){
				v.push("MC_"+MonsterConstants.monsters[idx]);
			}
			AssetManager.instance.bulkRequest(v, onAssetsLoaded);
		}
		
		protected function onAssetsLoaded(v:Vector.<AssetVO>):void {
			for each (var vo:AssetVO in v) {
				switch (vo.name) {
					case "PANEL_trainercard":
						m_baseAsset = vo.asset as Sprite;
						break;
					case "BTN_Popup_BackToGame":
						btn_backToGame = vo.asset as MovieClip;
						break;
					case "BTN_Popup_Challenge":
						btn_challenge = vo.asset as MovieClip;
						break;
					default:
						//assume it's a MC_pokemonName
						var spl:Array = vo.name.split('_');
						if (spl.length > 1){
							MonsterConstants.monsterImageMap[spl[1]] = vo.asset as MovieClip;
						}
						break;
				}
			}
			buildPanelContents();
		}
		
		protected function buildPanelContents():void {
			DebugUtils.log("Building panel");
			FlashUtils.swapSymbols("PROP_btn_backToGame", btn_backToGame, m_baseAsset);
			FlashUtils.swapSymbols("PROP_challenge_button", btn_challenge, m_baseAsset);
			
			returnMCB = new MCButton(btn_backToGame);
			returnMCB.addEventListener(MouseEvent.CLICK, btnClose_click);
			
			challengeMCB = new MCButton(btn_challenge);
			challengeMCB.addEventListener(MouseEvent.CLICK, onChallenge);
			
			m_baseAsset.x = 230;
			m_baseAsset.y = 150;
			addChild(m_baseAsset);
		}
		
		public function setupPanel(m:Monster):void {
			var monsterName:String = m.name;
			FlashUtils.swapSymbols("MC_monster", MonsterConstants.monsterImageMap[monsterName] as MovieClip, m_baseAsset);
		}
		
		/**
		 * Triggered when players click on the close button.
		 * The behavior is as follows:
		 * If we have more badges to show, we show the next one, 
		 * otherwise we close the popup. (!)
		 * 
		 * */
		protected function btnClose_click(event:MouseEvent):void {			
			dispatchEvent(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.TRAINER_CARD));
			dispatchEvent(new SlotsDialogEvent(SlotsDialogEvent.DIALOG_CLOSED));
		}
		
		protected function onChallenge(event:MouseEvent):void {
			dispatchEvent(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.CHALLENGE_FRIENDS));
			dispatchEvent(new SlotsDialogEvent(SlotsDialogEvent.DIALOG_CLOSED));
		}
		
	}
}