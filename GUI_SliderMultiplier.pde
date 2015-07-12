class GUI_SliderMultiplier extends GUI_SliderGeneric {

  GUI_SliderMultiplier(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name, xCoord, yCoord);

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(xCoord, yCoord)
        .setSize(20,130)
        .setRange(-50,50)
        .setValue(0)
        .setLabel("MULT")
        .setBroadcast(true)
        ;

  }
}
