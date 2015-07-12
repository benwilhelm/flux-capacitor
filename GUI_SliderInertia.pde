class GUI_SliderInertia extends GUI_SliderGeneric {

  GUI_SliderInertia(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name, xCoord, yCoord);

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(x, y)
        .setSize(20,130)
        .setRange(0, 1)
        .setValue(0)
        .setLabel("Inertia")
        .setBroadcast(true)
        ;
  }
}
