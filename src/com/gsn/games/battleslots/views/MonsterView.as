package com.gsn.games.battleslots.views {
	
	import com.gsn.games.battleslots.data.Monster;
	import com.gsn.games.shared.assetsmanagement.AssetManager;
	import com.gsn.games.shared.assetsmanagement.AssetVO;
	import com.gsn.games.shared.ui.BaseView;
	import com.gsn.games.shared.utils.DebugUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class MonsterView extends BaseView {
		
		protected var m_meter:Sprite;
		protected var m_monsterImg:MovieClip;
		protected var m_statAnim:MovieClip;
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
			m_statAnim.visible = false;
			
			m_monsterImg.play();
			//set up stats text
			health_tf = (m_meter.getChildByName("TF_health") as TextField);
			attack_tf = (m_meter.getChildByName("TF_attack") as TextField);
			energy_tf = (m_meter.getChildByName("TF_energy") as TextField);
			exp_tf =	(m_meter.getChildByName("TF_xp") as TextField);
			defense_tf= (m_meter.getChildByName("TF_defense") as TextField);
			addChild(m_meter);
		}
		
		public function setMonsterData(monst:Monster):void {
			health_tf.text = "HP: "+monst.getTotalStat(Monster.HEALTH);
			attack_tf.text = "Attack: "+monst.getTotalStat(Monster.ATTACK);
			energy_tf.text = "Energy: "+monst.getTotalStat(Monster.ENERGY);
			defense_tf.text = "Defense: "+monst.getTotalStat(Monster.DEFENSE);
			exp_tf.text = "XP: "+monst.xp+" (level "+monst.getLevel()+")";
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