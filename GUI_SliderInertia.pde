import controlP5.*;

class GUI_SliderInertia extends Slider {

  ControlP5 control;
  int x, y;

  Random rand = new Random();

  GUI_SliderInertia(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(x, y)
        .setSize(20,130)
        .setRange(0, 1)
        .setValue(0)
        .setLabel("Inertia")
        .setBroadcast(true)
        ;
  }
}