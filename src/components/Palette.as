package components {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Alex
	 */
	public class Palette extends Sprite {
		private var leftColor:uint = 0xffffff;
		private var rightColor:uint = 0xff0000;

		private var leftControl:Sprite = new Sprite();
		private var palette:Sprite = new Sprite();
		private var rightControl:Sprite = new Sprite();

		private var controlPixels:BitmapData = new BitmapData(30, 256, false, 0xffff99);
		private var palettePixels:BitmapData = new BitmapData(256, 256, false, 0xffff99);

		public function Palette() {
			init();
		}

		private function init():void {
			createControl();
			createPalette(0xff0000);

			rightControl.addChild(new Bitmap(controlPixels));
			rightControl.x = 326;
			rightControl.y = 10;
			palette.addChild(new Bitmap(palettePixels));
			palette.x = 50;
			palette.y = 10;
			leftControl.addChild(new Bitmap(controlPixels));
			leftControl.y = 10;
			addChild(rightControl);
			addChild(palette);
			addChild(leftControl);

			leftControl.addEventListener(MouseEvent.MOUSE_MOVE, leftControl_overHandler);
			palette.addEventListener(MouseEvent.MOUSE_MOVE, palette_overHandler);
			rightControl.addEventListener(MouseEvent.MOUSE_MOVE, rightControl_overHandler);
		}

		private function createControl():void {
			var col:uint = 0xff0000;
			var delta:int = 0x000100;
			var py:int;

			controlPixels.lock();
			for (var i:int; i < 1536; i++) {
				if (col == 0xffff00)
					delta = -0x010000;
				else if (col == 0x00ff00)
					delta = 1;
				else if (col == 0x00ffff)
					delta = -0x100;
				else if (col == 0x0000ff)
					delta = 0x10000;
				else if (col == 0xff00ff)
					delta = -0x1;
				else if (col == 0xff0000)
					delta = 0x100;
				col += delta;

				if (i % 6 == 0)
					for (py = 0; py <= 30; py++) {
						controlPixels.setPixel(py, i / 6, col);
					}
			}
			controlPixels.unlock();
		}

		private function createPalette(targetCol:uint, startCol:uint = 0xffffff):void {
			var rowR:Number = (startCol >> 16) & 0xff;
			var rowG:Number = (startCol >> 8) & 0xff;
			var rowB:Number = startCol & 0xff;
			const targetR:uint = (targetCol >> 16) & 0xFF;
			const targetG:uint = (targetCol >> 8) & 0xFF;
			const targetB:uint = targetCol & 0xFF;

			const deltaRByX:Number = (rowR - targetR) / 256;
			const deltaGByX:Number = (rowG - targetG) / 256;
			const deltaBByX:Number = (rowB - targetB) / 256;

			palettePixels.lock();
			for (var x:int = 0; x < 256; x++) {
				var r:Number = Math.round(rowR);
				var g:Number = Math.round(rowG);
				var b:Number = Math.round(rowB);
				var deltaRByY:Number = r / 256;
				var deltaGByY:Number = g / 256;
				var deltaBByY:Number = b / 256;

				rowR -= deltaRByX;
				rowG -= deltaGByX;
				rowB -= deltaBByX;

				for (var y:int = 0; y < 256; y++) {
					palettePixels.setPixel(x, y, Math.round(r) * 0x10000 + Math.round(g) * 0x100 + Math.round(b));

					r -= deltaRByY;
					g -= deltaGByY;
					b -= deltaBByY;
				}
			}
			palettePixels.unlock();
		}

		private function leftControl_overHandler(e:MouseEvent):void {
			if (e.buttonDown) {
				leftColor = controlPixels.getPixel(leftControl.mouseX, leftControl.mouseY);
				createPalette(rightColor, leftColor);
				e.updateAfterEvent();
			}
		}

		private function palette_overHandler(e:MouseEvent):void {
			if (e.buttonDown) {
				rightColor = palettePixels.getPixel(palette.mouseX, palette.mouseY);
				createPalette(rightColor, leftColor);
				e.updateAfterEvent();
			}
		}

		private function rightControl_overHandler(e:MouseEvent):void {
			if (e.buttonDown) {
				rightColor = controlPixels.getPixel(rightControl.mouseX, rightControl.mouseY);
				createPalette(rightColor, leftColor);
				e.updateAfterEvent();
			}
		}
	}
}