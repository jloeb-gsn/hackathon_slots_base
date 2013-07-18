package com.gsn.games.battleslots.views {
	
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.battleslots.events.MonsterEvent;
	import com.gsn.games.battleslots.events.SKSSlotsDialogEvent;
	import com.gsn.games.shared.assetsmanagement.AssetManager;
	import com.gsn.games.shared.assetsmanagement.AssetVO;
	import com.gsn.games.shared.ui.BaseView;
	import com.gsn.games.shared.ui.FrameButtonHelper;
	import com.gsn.games.shared.utils.DebugUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class MonsterView extends BaseView {
		
		protected var m_meter:Sprite;
		protected var m_monsterImg:MovieClip;
		protected var m_statAnim:MovieClip;
		protected var m_trainerCardMC:MovieClip;
		protected var m_myMonstersMC:MovieClip;
		
		protected var m_monsterButton:FrameButtonHelper;
		protected var m_trainerButton:FrameButtonHelper;
		
		protected var m_bounceTimer:Timer;
		
		protected var health_tf:TextField;
		protected var attack_tf:TextField;
		protected var energy_tf:TextField;
		protected var defense_tf:TextField;
		protected var exp_tf:TextField;
		
		public function MonsterView() {
			super();
			initAssetLoads();
			m_bounceTimer = new Timer(2000,0);
		}
		
		protected function initAssetLoads():void {
			
			var v:Vector.<String> = new Vector.<String>();
			v.push("PANEL_MonsterStats");
			
			AssetManager.instance.bulkRequest(v, onAssetsLoaded);
		}
		
		protected function onAssetsLoaded(v:Vector.<AssetVO>):void {
			for each (var vo:AssetVO in v) {
				switch (vo.name) {
					case "PANEL_MonsterStats":
						m_meter = vo.asset as Sprite;
						break;
				}
			}
			buildPanelContents();
		}
		
		protected function buildPanelContents():void {
			DebugUtils.log("Building panel");
			//set up bouncing monster image
			m_monsterImg = (m_meter.getChildByName("MC_monster") as MovieClip);
			m_statAnim = (m_meter.getChildByName("MC_statanim") as MovieClip);
			m_trainerCardMC = (m_meter.getChildByName("BTN_trainercard") as MovieClip);
			m_myMonstersMC = (m_meter.getChildByName("BTN_mymonsters") as MovieClip);
			m_statAnim.visible = false;
			
			m_monsterImg.play();
			//set up stats text
			health_tf = (m_meter.getChildByName("TF_health") as TextField);
			attack_tf = (m_meter.getChildByName("TF_attack") as TextField);
			energy_tf = (m_meter.getChildByName("TF_energy") as TextField);
			exp_tf =	(m_meter.getChildByName("TF_xp") as TextField);
			defense_tf= (m_meter.getChildByName("TF_defense") as TextField);
			
			setUpButtons();
			addChild(m_meter);
		}
		
		protected function setUpButtons():void {
			m_trainerButton = new FrameButtonHelper(m_trainerCardMC);
			m_trainerButton.addEventListener(MouseEvent.CLICK, onTrainerButtonClicked);
			
			m_monsterButton = new FrameButtonHelper(m_myMonstersMC);
			m_monsterButton.addEventListener(MouseEvent.CLICK, onMyMonstersButtonClicked);
		}
		
		public function toggleButtons(on:Boolean):void {
			m_monsterButton.isEnabled = on;
			m_trainerButton.isEnabled = on;
		}
		
		////// view event dispatchers ///
		
		protected function onMyMonstersButtonClicked(e:MouseEvent):void {
			dispatchEvent(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.MONSTER_COLLECTION));
		}
		
		protected function onTrainerButtonClicked(e:MouseEvent):void {
			dispatchEvent(new SKSSlotsDialogEvent(SKSSlotsDialogEvent.TRAINER_CARD));
		}
		
		////// view functions called by mediator /////
		
		public function setMonsterData(m:Monster):void {
			health_tf.text = m.getTotalStat(Monster.HEALTH)+" ("+m.getBaseStat(Monster.HEALTH) + " + " + m.getBoostForStat(Monster.HEALTH)+")";
			attack_tf.text = m.getTotalStat(Monster.ATTACK)+" ("+m.getBaseStat(Monster.ATTACK) + " + " + m.getBoostForStat(Monster.ATTACK)+")";
			energy_tf.text = m.getTotalStat(Monster.ENERGY)+" ("+m.getBaseStat(Monster.ENERGY) + " + " + m.getBoostForStat(Monster.ENERGY)+")";
			defense_tf.text = m.getTotalStat(Monster.DEFENSE)+" ("+m.getBaseStat(Monster.DEFENSE) + " + " + m.getBoostForStat(Monster.DEFENSE)+")";
			exp_tf.text = m.xp+" (level "+m.getLevel()+")";
		}
		
		public function bounceStat(stat:String, delta:int =1):void {
			var mct:MovieClip = m_statAnim.getChildByName('MC_text') as MovieClip;
			var tf:TextField = (mct.getChildByName('TF_statsinfo') as TextField);
			tf.text = stat + " +" + delta;
			m_statAnim.visible = true;
			m_statAnim.gotoAndPlay(1);
			m_bounceTimer.addEventListener(TimerEvent.TIMER, onBounceTimer);
			m_bounceTimer.start();
		}
		
		protected function onBounceTimer(e:TimerEvent):void {
			m_bounceTimer.stop();
			m_bounceTimer.reset();
			m_bounceTimer.removeEventListener(TimerEvent.TIMER, onBounceTimer);
			m_statAnim.visible = false;
			m_statAnim.stop();
		}
	}
}