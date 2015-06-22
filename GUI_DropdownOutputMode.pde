import controlP5.*;

class GUI_DropdownOutputMode extends DropdownList {

  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_DropdownOutputMode(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setLabel("Output Mode")
        .setPosition(x, y)
        ;
    
    this.addItem("Simple" , View_ChannelControl.OUTPUT_MODE_SIMPLE);
    this.addItem("HSB"    , View_ChannelControl.OUTPUT_MODE_HSB);

  }


}