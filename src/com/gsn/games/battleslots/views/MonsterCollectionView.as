package com.gsn.games.battleslots.views
{
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
	
	public class MonsterCollectionView extends BaseView {
		
		protected var m_baseAsset:Sprite;
		protected var btn_backToGame:MovieClip;
		protected var gfx_background    :Sprite;
		
		protected var returnMCB:MCButton;
		
		public function MonsterCollectionView() {
			super();
			initAssetLoads();
		}
		
		protected function initAssetLoads():void {
			
			var v:Vector.<String> = new Vector.<String>();
			v.push("PANEL_MonsterColl");
			v.push("BTN_Popup_BackToGame");
			v.push("GFX_SummaryBg");
			AssetManager.instance.bulkRequest(v, onAssetsLoaded);
		}
		
		protected function onAssetsLoaded(v:Vector.<AssetVO>):void {
			for each (var vo:AssetVO in v) {
				switch (vo.name) {
					case "PANEL_MonsterColl":
						m_baseAsset = vo.asset as Sprite;
						break;
					case "GFX_SummaryBg":
						gfx_background = vo.asset as MovieClip;
						break;
					case "BTN_Popup_BackToGame":
						btn_backToGame = vo.asset as MovieClip;
						break;
				}
			}
			buildPanelContents();
		}
		
		protected function buildPanelContents():void {
			DebugUtils.log("Building panel");
			FlashUtils.swapSymbols("PROP_bg", gfx_background, m_baseAsset);
			FlashUtils.swapSymbols("PROP_btn_backToGame", btn_backToGame, m_baseAsset);
			returnMCB = new MCButton(btn_backToGame);
			returnMCB.addEventListener(MouseEvent.CLICK, btnClose_click);
			//set up bouncing monster image
			//m_monsterImg = (m_baseAsset.getChildByName("MC_monster") as MovieClip);
			addChild(m_baseAsset);
		}
		
		/**
		 * Triggered when players click on the close button.
		 * The behavior is as follows:
		 * If we have more badges to show, we show the next one, 
		 * otherwise we close the popup. (!)
		 * 
		 * */
		protected function btnClose_click(event:MouseEvent):void {			
			dispatchEvent(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.MONSTER_COLLECTION));
			dispatchEvent(new SlotsDialogEvent(SlotsDialogEvent.DIALOG_CLOSED));
		}
		
		public function initializeMonsterData(monsterList:Array):void {
			
		}
	}
}