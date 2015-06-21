import controlP5.*;


class GUI_DropdownAttributeSelector extends DropdownList {
  
  ControlP5 control;
  int x, y;

  Random rand = new Random();

  GUI_DropdownAttributeSelector(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;


    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setWidth(200)
        .setLabel("Select")
        .setBarHeight(15)
        .setBackgroundColor(COLOR_DARK_GREY)
        .setItemHeight(20)
        ;
    
    this.addItem("Simple Volume", ATTRIBUTE_VOLUME);
    this.addItem("Frequency Spectrum", ATTRIBUTE_SPECTRUM);
    this.addItem("Dominant Frequency", ATTRIBUTE_FREQUENCY);
    this.addItem("Fullness", ATTRIBUTE_FULLNESS);
  }
}