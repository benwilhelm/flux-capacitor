import controlP5.*;

class GUI_ChannelControl {

  FC_AudioProcessor audioProcessor;
  GUI_Eq_Input inputEq;
  GUI_Eq outputEq;
  Random rand;

  ControlP5 control;
  Range envelopeRange;
  Slider multiplierSlider, offsetSlider;

  int x, y;
  final static int PANEL_WIDTH  = 400;
  final static int PANEL_HEIGHT = 200;

  GUI_ChannelControl(FC_AudioProcessor processor, int xCoord, int yCoord) {
    audioProcessor = processor;
    x = xCoord;
    y = yCoord;
    inputEq  = new GUI_Eq_Input(10,  10, 150, 50);
    outputEq = new GUI_Eq(10, 90, 150, 50);

    control = new ControlP5(APPLET);

    rand = new Random();
  }

  public void setup() {
    inputEq.setup();
    outputEq.setup();

    envelopeRange = this.setupEnvelopeRange();
    multiplierSlider = this.setupMultiplierSlider();
    offsetSlider = this.setupOffsetSlider();
  }

  public void draw() {
    pushMatrix();

    translate(x, y);
    noStroke();
    fill(200);
    rect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
    inputEq.draw(audioProcessor.getScaledFeatures(), audioProcessor.getEnvelopeMin(), audioProcessor.getEnvelopeMax() );
    outputEq.draw(audioProcessor.getEnvelope());

    popMatrix();
  }



  Range setupEnvelopeRange() {
    return control.addRange("envelopeRange")
                  .setId(rand.nextInt())
                  .setBroadcast(false)
                  .setPosition(this.x+10, this.y+65)
                  .setLabelVisible(false)
                  .setSize(150, 20)
                  .setHandleSize(20)
                  .setRange(0, FC_AudioProcessor.CHANNEL_MAX)
                  .setRangeValues(audioProcessor.getEnvelopeMin(), audioProcessor.getEnvelopeMax())
                  .setBroadcast(true)
                  .setColorForeground(color(96,40))
                  .setColorBackground(color(96,40));    
  }

  Slider setupMultiplierSlider() {
    return control.addSlider("multiplierSlider")
                  .setId(rand.nextInt())
                  .setBroadcast(false)
                  .setPosition(this.x+175, this.y+10)
                  .setSize(20,150)
                  .setRange(0,10)
                  .setValue(1)
                  .setBroadcast(true);
  }

  Slider setupOffsetSlider() {
    return control.addSlider("offsetSlider")
                  .setId(rand.nextInt())
                  .setBroadcast(false)
                  .setPosition(this.x+225, this.y+10)
                  .setSize(20,150)
                  .setRange(-1*FC_AudioProcessor.CHANNEL_MAX, FC_AudioProcessor.CHANNEL_MAX)
                  .setValue(0)
                  .setBroadcast(true);
  }


  void controlEvent(ControlEvent e) {
    int eId = e.getId();
    
    // ENVELOPE RANGE
    if (eId == envelopeRange.getId()) {
      int min = (int)e.getController().getArrayValue(0);
      int max = (int)e.getController().getArrayValue(1);
      audioProcessor.setEnvelopeRange(min, max);
    }

    // SIGNAL MULTIPLIER
    if (eId == multiplierSlider.getId()) {
      float val = multiplierSlider.getValue();
      audioProcessor.setSignalMultiplier(val);
    }

    // SIGNAL OFFSET
    if (eId == offsetSlider.getId()) {
      int val = (int)offsetSlider.getValue();
      audioProcessor.setSignalOffset(val);
    }
  }
}