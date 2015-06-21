import controlP5.*;

class GUI_SliderOffset extends Slider {

  ControlP5 control;
  int x, y;

  Random rand = new Random();

  GUI_SliderOffset(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(x, y)
        .setSize(20,130)
        .setRange(-1, 1)
        .setValue(0)
        .setLabel("+/-")
        .setBroadcast(true)
        ;
  }
}