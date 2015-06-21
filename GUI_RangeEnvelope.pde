import controlP5.*;

color foreGround = color(120, 80);
color backGround = color( 96, 60);

class GUI_RangeEnvelope extends Range {


  
  ControlP5 control;
  int x, y;

  Random rand = new Random();

  GUI_RangeEnvelope(ControlP5 ctrl, int xCoord, int yCoord) {
    super(ctrl, "envelopeRange");
    this.x = xCoord;
    this.y = yCoord;


    this.setId(rand.nextInt())
        .setBroadcast(false)
        .setPosition(x, y)
        .setLabelVisible(false)
        .setSize(240, 20)
        .setHandleSize(20)
        .setRange(0, FC_AudioAnalyzer.CHANNEL_MAX)
        .setRangeValues(0, FC_AudioAnalyzer.CHANNEL_MAX)
        .setBroadcast(true)
        .setColorForeground(foreGround)
        .setColorBackground(backGround)
        ;
  }
}