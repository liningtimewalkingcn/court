package supportClasses
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.IInvalidating;
	import mx.core.InteractionMode;
	import mx.events.FlexMouseEvent;
	
	import spark.components.Group;
	import spark.components.Scroller;
	import spark.components.supportClasses.ScrollerLayout;
	import spark.core.IViewport;
	import spark.core.NavigationUnit;
	import spark.utils.MouseEventUtil;

	public class MyScroller extends Scroller
	{
		/**
		 *  @private
		 */
		override protected function attachSkin():void
		{
			super.attachSkin();
			skin.addEventListener(MouseEvent.MOUSE_WHEEL, myskin_mouseWheelHandler);
		}
		
		protected function myskin_mouseWheelHandler(event:MouseEvent):void {
			const vp:IViewport = viewport;
			if ( !vp || !vp.visible)
				return;
			
			// Dispatch the "mouseWheelChanging" event. If preventDefault() is called
			// on this event, the event will be cancelled.  Otherwise if  the delta
			// is modified the new value will be used.
			var changingEvent:FlexMouseEvent = MouseEventUtil.createMouseWheelChangingEvent(event);
			if (!dispatchEvent(changingEvent))
			{
				event.preventDefault();
				return;
			}
			
			const delta:int = changingEvent.delta * 50;
			
			var nSteps:uint = Math.abs(event.delta * 50);
			var navigationUnit:uint;
			
			// Scroll delta "steps".  If the VSB is up, scroll vertically,
			// if -only- the HSB is up then scroll horizontally.
			
			// TODO: The problem is that viewport.validateNow() doesn’t necessarily 
			// finish the job, see http://bugs.adobe.com/jira/browse/SDK-25740.   
			// Since some imprecision in mouse-wheel scrolling is tolerable this is
			// ok for now.  For 4.next we should add Scroller API for (reliably) 
			// scrolling in different increments and refactor code like this to 
			// depend on it.  Also applies to VScroller and HScroller mouse
			// handlers.
			
			if (verticalScrollBar && verticalScrollBar.visible)
			{
				navigationUnit = (delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
				for (var vStep:int = 0; vStep < nSteps; vStep++)
				{
					var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
					if (!isNaN(vspDelta))
					{
						vp.verticalScrollPosition += vspDelta;
						if (vp is IInvalidating)
							IInvalidating(vp).validateNow();
					}
				}
				event.preventDefault();
			}
			else if (horizontalScrollBar && horizontalScrollBar.visible)
			{
				navigationUnit = (delta < 0) ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
				for (var hStep:int = 0; hStep < nSteps; hStep++)
				{
					var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
					if (!isNaN(hspDelta))
					{
						vp.horizontalScrollPosition += hspDelta;
						if (vp is IInvalidating)
							IInvalidating(vp).validateNow();
					}
				}
				event.preventDefault();
			}            
		}
	}
}