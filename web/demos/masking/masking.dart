import 'dart:math';
import 'dart:html' as html;
import 'package:dartflash/dartflash.dart';

Stage stage;
ResourceManager resourceManager;
RenderLoop renderLoop;
Random random = new Random();

class FlowerField extends DisplayObjectContainer {
  
  FlowerField()   {
    
    for(int i = 0; i < 150; i++) {
      
      int f = 1 + random.nextInt(3);

      BitmapData bitmapData = resourceManager.getBitmapData('flower$f');
      Bitmap bitmap = new Bitmap(bitmapData);
      bitmap.pivotX = 64;
      bitmap.pivotY = 64;
      bitmap.x = 64 + random.nextInt(940 - 128);
      bitmap.y = 64 + random.nextInt(500 - 128);
      addChild(bitmap);

      Tween tween = new Tween(bitmap, 600, TransitionFunction.linear);
      tween.animate('rotation', PI * 60.0);
      renderLoop.juggler.add(tween);
    }
  }
}

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------

void main() {
  
  // initialize the Display List

  stage = new Stage('myStage', html.document.query('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // define three Masks for later use

  List<Point> starPath = new List<Point>();

  for(int i = 0; i < 6; i++) {
    num a1 = (i * 60) * PI / 180;
    num a2 = (i * 60 + 30) * PI / 180;
    starPath.add(new Point(470 + 200 * cos(a1), 250 + 200 * sin(a1)));
    starPath.add(new Point(470 + 100 * cos(a2), 250 + 100 * sin(a2)));
  }

  Mask rectangleMask = new Mask.rectangle(100, 100, 740, 300);
  Mask circleMask = new Mask.circle(470, 250, 200);
  Mask customMask = new Mask.custom(starPath);

  // use the Resource class to load some Bitmaps

  resourceManager = new ResourceManager()
    ..addBitmapData('flower1', '../common/images/Flower1.png')
    ..addBitmapData('flower2', '../common/images/Flower2.png')
    ..addBitmapData('flower3', '../common/images/Flower3.png');

  resourceManager.load().then((result) {
    
    // draw a nice looking field of flowers

    FlowerField flowerField = new FlowerField();
    flowerField.pivotX = 470;
    flowerField.pivotY = 250;
    flowerField.x = 470;
    flowerField.y = 250;
    stage.addChild(flowerField);

    // add html-button event listeners

    html.query('#mask-none').onClick.listen((e) => flowerField.mask = null);
    html.query('#mask-rectangle').onClick.listen((e) => flowerField.mask = rectangleMask);
    html.query('#mask-circle').onClick.listen((e) => flowerField.mask = circleMask);
    html.query('#mask-custom').onClick.listen((e) => flowerField.mask = customMask);
    html.query('#mask-spin').onClick.listen((e) {
      Tween rotate = new Tween(flowerField, 2.0, TransitionFunction.easeInOutBack);
      rotate.animate('rotation', PI * 4.0);
      rotate.onComplete = () => flowerField.rotation = 0.0;
      renderLoop.juggler.add(rotate);
    });
  });
}
