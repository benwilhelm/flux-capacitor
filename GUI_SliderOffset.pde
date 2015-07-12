class GUI_SliderOffset extends GUI_SliderGeneric {

  GUI_SliderOffset(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name, xCoord, yCoord);

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(x, y)
        .setSize(20,130)
        .setRange(-1, 1)
        .setValue(0)
        .setLabel("+/-")
        .setBroadcast(true)
        ;
  }
}
