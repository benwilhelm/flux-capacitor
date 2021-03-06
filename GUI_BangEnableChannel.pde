import controlP5.*;
import java.util.Random;

class GUI_BangEnableChannel extends Bang {

  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_BangEnableChannel(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setSize(10, 10)
        .setId(rand.nextInt())
        .setTriggerEvent(Bang.RELEASE)
        .setLabelVisible(false)
        ;

  }

}
