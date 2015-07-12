import controlP5.*;

color foreGround = color(120, 80);
color backGround = color( 96, 60);

class GUI_RangeEnvelope extends Range {

  ControlP5 control;
  int x, y;
  int rangeMin, rangeMax;

  Random rand = new Random();

  GUI_RangeEnvelope(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;
    this.rangeMin = 0;
    this.rangeMax = FC_AudioAnalyzer.CHANNEL_MAX;

    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(x, y)
        .setLabelVisible(false)
        .setSize(240, 20)
        .setHandleSize(20)
        .setRange(rangeMin, rangeMax)
        .setRangeValues(rangeMin, rangeMax)
        .setBroadcast(true)
        .setColorForeground(foreGround)
        .setColorBackground(backGround)
        ;
  }

  void setRangeByDmx(float min, float max) {
    min = map(min, 0, 255, this.rangeMin, this.rangeMax);
    max = map(max, 0, 255, this.rangeMin, this.rangeMax);
    max = (min < max) ? max : min + 1;
    this.setRangeValues(min, max);
  }
}
