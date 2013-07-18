package com.gsn.games.battleslots.events
{
    import com.gsn.games.core.models.badgemanager.vo.BadgeVO;

    import flash.events.Event;

    /**
     * Event that contains a BadgeVO object.
     * NOTE: Could be merged with BadgeManagerEvent if the constants were added there.
     * @author rdixon
     * */
    public class BadgeDisplayEvent extends Event
    {
        public static const DISPLAY_BADGE:String   = "displayBadge";
        public static const BADGE_DISPLAYED:String = "badgeDisplayed";

        public var vo:BadgeVO;

        public function BadgeDisplayEvent(type:String, badgeVo:BadgeVO = null)
        {
            super(type);
            vo = badgeVo;
        }

        override public function clone():Event
        {
            return new BadgeDisplayEvent(type, vo);
        }
    }
}
