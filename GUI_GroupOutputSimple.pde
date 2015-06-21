import controlP5.*;

class GUI_GroupOutputSimple extends Group {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_GroupOutputSimple(ControlP5 ctrl, int xCoord, int yCoord) {
    super(ctrl, "outputGroupSimple");
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setSize(260, 40)
        .setLabel("Output Simple")
        .setBackgroundColor(128)
        .disableCollapse()
        .setVisible(false);
        ;
  }

}
