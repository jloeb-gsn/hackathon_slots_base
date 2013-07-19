package com.gsn.games.battleslots.views
{
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.battleslots.data.MonsterConstants;
	import com.gsn.games.battleslots.events.MonsterEvent;
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
	import flash.text.TextField;
	
	public class MonsterCollectionView extends BaseView {
		
		protected var m_baseAsset:Sprite;
		protected var btn_backToGame:MovieClip;
		protected var gfx_background    :Sprite;
		
		protected var returnMCB:MCButton;
		
		protected var backMCB:MCButton;
		protected var nextMCB:MCButton;
		
		protected var chooseBtns:Array = [];
		protected var m_panels:Array = [];
		
		protected var m_playerMonsters:Array = [];
		protected var m_activeMonster:Monster;
		protected var pageNumber:int = 0;
		
		public function MonsterCollectionView() {
			super();
			initAssetLoads();
		}
		
		protected function initAssetLoads():void {
			
			var v:Vector.<String> = new Vector.<String>();
			v.push("PANEL_MonsterColl");
			v.push("BTN_Popup_BackToGame");
			v.push("GFX_SummaryBg");
			new MonsterConstants();
			for (var idx:int = 0; idx < MonsterConstants.monsters.length; idx++){
				v.push("MC_"+MonsterConstants.monsters[idx]);
			}
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
			FlashUtils.swapSymbols("PROP_bg", gfx_background, m_baseAsset);
			FlashUtils.swapSymbols("PROP_btn_backToGame", btn_backToGame, m_baseAsset);
			
			m_panels[0] = (m_baseAsset.getChildByName("PANEL_monsterstat_0") as MovieClip);
			m_panels[1] = (m_baseAsset.getChildByName("PANEL_monsterstat_1") as MovieClip);
			m_panels[2] = (m_baseAsset.getChildByName("PANEL_monsterstat_2") as MovieClip);
			
			returnMCB = new MCButton(btn_backToGame);
			returnMCB.addEventListener(MouseEvent.CLICK, btnClose_click);
			
			backMCB = new MCButton(m_baseAsset.getChildByName("BTN_back") as MovieClip);
			backMCB.addEventListener(MouseEvent.CLICK, onBack);
			nextMCB = new MCButton(m_baseAsset.getChildByName("BTN_next") as MovieClip);
			nextMCB.addEventListener(MouseEvent.CLICK, onNext);

			addChild(m_baseAsset);
			redraw();
		}
		
		protected function onNext(e:MouseEvent):void {
			if (pageNumber*3+3 < MonsterConstants.monsters.length){
				pageNumber++;
			}
			redraw();
		}
		
		protected function onBack(e:MouseEvent):void {
			if (pageNumber > 0){
				pageNumber--;
			}
			redraw();
		}
		
		protected function redraw():void {
			backMCB.enabled = pageNumber > 0;	
			nextMCB.enabled = pageNumber*3+3 < MonsterConstants.monsters.length;
			
			//repopulate with new images... 
			var displayMonsters:Array = MonsterConstants.monsters.slice(pageNumber*3,pageNumber*3+3);
			for (var i:int = 0; i < m_panels.length; i++){
				(m_panels[i].MC_monstericon as MovieClip).removeChildren();
				//set up new mc
				var monstermc:MovieClip = MonsterConstants.monsterImageMap[displayMonsters[i]] as MovieClip;
				(m_panels[i].MC_monstericon as MovieClip).addChild(monstermc);
				var playerMonster:Monster = getMonsterByName(displayMonsters[i]);
				var levelText:TextField = (m_panels[i] as MovieClip).getChildByName('TF_level') as TextField;
				var ownedText:TextField = (m_panels[i] as MovieClip).getChildByName('TF_notowned') as TextField;//BTN_choose
				var activeText:TextField = (m_panels[i] as MovieClip).getChildByName('TF_active') as TextField;
				var monsterName:TextField = (m_panels[i] as MovieClip).getChildByName('TF_monstername') as TextField;
				chooseBtns[i] = new MCButton((m_panels[i] as MovieClip).getChildByName('BTN_choose') as MovieClip);
				var listener:Function = this["choose"+i] as Function;
				
				monsterName.text = (displayMonsters[i] as String).toUpperCase();
				if (playerMonster != null){
					ownedText.visible= false;
					levelText.visible = true;
					levelText.text = "Level: "+playerMonster.getLevel();
					
					activeText.visible = false;
					if (isMonsterActive(playerMonster)){
						activeText.visible = true;
						chooseBtns[i].visible = false;
					} else {
						chooseBtns[i].visible = true;
						chooseBtns[i].addEventListener(MouseEvent.CLICK, listener);
					}
				} else {
					ownedText.visible = true;
					levelText.visible = false;
					chooseBtns[i].visible = false;
					activeText.visible = false;
				}
			}
			
		}
		
		private function choose0(e:MouseEvent):void {
			var newMonster:Monster = getMonsterByName(MonsterConstants.monsters[pageNumber*3]);
			this.dispatchEvent(new MonsterEvent(MonsterEvent.SET_ACTIVE, newMonster));
			btnClose_click(e);
		}
		
		private function choose1(e:MouseEvent):void {
			var newMonster:Monster = getMonsterByName(MonsterConstants.monsters[pageNumber*3+1]);
			this.dispatchEvent(new MonsterEvent(MonsterEvent.SET_ACTIVE, newMonster));
			btnClose_click(e);
		}
		
		private function choose2(e:MouseEvent):void {
			var newMonster:Monster = getMonsterByName(MonsterConstants.monsters[pageNumber*3+2]);
			this.dispatchEvent(new MonsterEvent(MonsterEvent.SET_ACTIVE, newMonster));
			btnClose_click(e);
		}
		
		/**
		 * Triggered when players click on the close button.
		 * The behavior is as follows:
		 * If we have more badges to show, we show the next one, 
		 * otherwise we close the popup. (!)
		 * 
		 * */
		protected function btnClose_click(event:MouseEvent):void {			
			pageNumber = 0;
			dispatchEvent(new SlotsDialogEvent(SlotsDialogEvent.DIALOG_CLOSED));
			dispatchEvent(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.MONSTER_COLLECTION));
		}
		
		public function initializeMonsterData(monsterList:Array, activeMonster:Monster):void {
			m_playerMonsters = monsterList;
			m_activeMonster = activeMonster;
			redraw();
		}
		
		private function isMonsterActive(m:Monster):Boolean {
			return m_activeMonster == m;
		}
		
		private function getMonsterByName(name:String):Monster {
			var result:Monster;
			for (var i:int = 0; i < m_playerMonsters.length; i++){
				if ((m_playerMonsters[i] as Monster).name == name){
					result = (m_playerMonsters[i] as Monster);
					break;
				}
			}
			return result;
		}
	}
}