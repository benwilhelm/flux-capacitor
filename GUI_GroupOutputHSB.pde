import controlP5.*;

class GUI_GroupOutputHSB extends Group {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_GroupOutputHSB(ControlP5 ctrl, int xCoord, int yCoord) {
    super(ctrl, "outputGroupHSB");
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setSize(260, 80)
        .setLabel("Output HSB")
        .setBackgroundColor(128)
        .disableCollapse()
        .setVisible(false)
        ;
  }

}
