import controlP5.*;

class GUI_TextfieldAttribute extends Textfield {

  ControlP5 control;
  int x, y;

  Random rand = new Random();

  GUI_TextfieldAttribute(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;


    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setSize(30, 15)
        .setLabelVisible(false)
        .setLabel("")
        ;
  }
}