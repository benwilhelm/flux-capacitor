class GUI_DropdownOutputMode extends GUI_DropdownGeneric {

  GUI_DropdownOutputMode(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name, xCoord, yCoord);

    this.setId(rand.nextInt())
        .setLabel("Output Mode")
        .setPosition(x, y)
        ;

    this.addItem("Simple" , View_ChannelControl.OUTPUT_MODE_SIMPLE);
    this.addItem("HSB"    , View_ChannelControl.OUTPUT_MODE_HSB);

  }

}
