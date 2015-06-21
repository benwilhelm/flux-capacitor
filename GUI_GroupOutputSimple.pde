import controlP5.*;

class GUI_GroupOutputSimple extends Group {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_DropdownAttributeSelector simpleAttributeSelector;

  GUI_GroupOutputSimple(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
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

    simpleAttributeSelector = new GUI_DropdownAttributeSelector(control, "simpleAttributeSelector", 10, 20);
    simpleAttributeSelector.setGroup(this);

  }

}
