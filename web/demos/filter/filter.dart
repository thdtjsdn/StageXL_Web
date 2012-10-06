import 'dart:math';
import 'dart:html' as html;
import 'package:dartflash/dartflash.dart';

Stage stage;
RenderLoop renderLoop;

void main()
{
  // Initialize the Display List
  stage = new Stage('stage', html.document.query('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load the astronaut image
  BitmapData.loadImage('../common/images/Astronaut.jpg').then(drawFilters);
}

void drawFilters(BitmapData astronautBitmapData)
{
  var astronautRectangle = new Rectangle(0, 0, astronautBitmapData.width, astronautBitmapData.height);

  // all filters will be applied to this BitmapData

  var bitmapData = new BitmapData(940, 500, true, 0x000000);
  var bitmap = new Bitmap(bitmapData);
  stage.addChild(bitmap);

  // define some filters

  List filters = [
    {'name': 'DropShadowFilter (black)', 'filter': new DropShadowFilter(10, PI / 4, Color.Black, 0.8, 8, 8) },
    {'name': 'GlowFilter (red)', 'filter': new GlowFilter(Color.Red, 1.0, 16, 16) },
    {'name': 'ColorMatrixFilter (grayscale)', 'filter': new ColorMatrixFilter.grayscale() },
    {'name': 'ColorMatrixFilter (invert)', 'filter': new ColorMatrixFilter.invert() },
    {'name': 'BlurFilter (radius 1)', 'filter': new BlurFilter(1, 1) },
    {'name': 'BlurFilter (radius 2)', 'filter': new BlurFilter(2, 2) },
    {'name': 'BlurFilter (radius 4)', 'filter': new BlurFilter(4, 4) },
    {'name': 'BlurFilter (radius 8)', 'filter': new BlurFilter(8, 8) }
  ];

  // apply all filters to the BitmapData

  for(int i = 0; i < filters.length; i++)
  {
    var x = 240 * (i % 4);
    var y = 240 * (i ~/ 4);
    var filter = filters[i]["filter"];
    var name = filters[i]["name"];

    bitmapData.applyFilter(astronautBitmapData, astronautRectangle, new Point(x, y + 20), filter);

    var textField = new TextField();
    textField.defaultTextFormat = new TextFormat('Helvetica Neue, Helvetica, Arial', 14, Color.Black);
    textField.x = x;
    textField.y = y;
    textField.width = 200;
    textField.text = name;
    bitmapData.draw(textField, textField.transformationMatrix);
  }
}