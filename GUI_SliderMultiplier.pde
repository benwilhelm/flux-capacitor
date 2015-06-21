import controlP5.*;

class GUI_SliderMultiplier extends Slider {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_SliderMultiplier(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    this.control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(xCoord, yCoord)
        .setSize(20,130)
        .setRange(-10,10)
        .setValue(0)
        .setLabel("MULT")
        .setBroadcast(true)
        ;

  }
}