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
		}

		private function createPalette(targetCol:uint, startCol:uint = 0xffffff):void {
			var ssR:Number = (startCol >> 16) & 0xff;
			var ssG:Number = (startCol >> 8) & 0xff;
			var ssB:Number = startCol & 0xff;
			var colR:uint;
			var colG:uint;
			var colB:uint;
			const red:uint = (targetCol >> 16) & 0xFF;
			const green:uint = (targetCol >> 8) & 0xFF;
			const blue:uint = targetCol & 0xFF;
			const indexR:Number = (ssR - red) / 256;
			const indexG:Number = (ssG - green) / 256;
			const indexB:Number = (ssB - blue) / 256;

			for (var i:int = 0; i < 256; i++) {
				var ay:int = 0;
				var ss2R:uint = colR;
				var ss2G:uint = colG;
				var ss2B:uint = colB;
				var index2R:Number = ss2R / 256;
				var index2G:Number = ss2G / 256;
				var index2B:Number = ss2B / 256;
				var col2R:uint;
				var col2G:uint;
				var col2B:uint;

				ssR -= indexR;
				ssG -= indexG;
				ssB -= indexB;
				colR = ssR;
				colG = ssG;
				colB = ssB;

				for (var k:int = 0; k < 256; k++) {
					palettePixels.setPixel(i, ay, col2R * 0x10000 + col2G * 0x100 + col2B);
					ss2R -= index2R;
					ss2G -= index2G;
					ss2B -= index2B;
					col2R = ss2R;
					col2G = ss2G;
					col2B = ss2B;
					ay++;
				}
			}
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