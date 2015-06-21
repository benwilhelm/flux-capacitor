import controlP5.*;

class GUI_BangEnableChannel extends Bang {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_BangEnableChannel(ControlP5 ctrl, int xCoord, int yCoord) {
    super(ctrl, "enableButton");
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
