class GUI_DropdownAttributeSelector extends GUI_DropdownGeneric {

  GUI_DropdownAttributeSelector(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name, xCoord, yCoord);
  
    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setWidth(200)
        .setLabel("Select")
        .setBarHeight(15)
        .setBackgroundColor(COLOR_DARK_GREY)
        .setItemHeight(20)
        ;

    this.addItem("Simple Volume", View_ChannelControl.ATTRIBUTE_VOLUME);
    this.addItem("Frequency Spectrum", View_ChannelControl.ATTRIBUTE_SPECTRUM);
    this.addItem("Dominant Frequency", View_ChannelControl.ATTRIBUTE_FREQUENCY);
    this.addItem("Fullness", View_ChannelControl.ATTRIBUTE_FULLNESS);
  }
}
