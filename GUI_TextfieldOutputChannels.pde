import controlP5.*;

class GUI_TextfieldOutputChannels extends Textfield {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_TextfieldOutputChannels(ControlP5 ctrl, int xCoord, int yCoord) {
    
    super(ctrl, "outputChannels");
    this.control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setWidth(160)
        .setLabel("Output Channels")
        ;

  }
}