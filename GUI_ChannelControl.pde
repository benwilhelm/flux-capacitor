import controlP5.*;

class GUI_ChannelControl {

  PApplet applet;
  FC_AudioAnalyzer audioAnalyzer;
  GUI_Eq_Input inputEq;
  GUI_Eq outputEq;
  Random rand;

  ControlP5 control;
  Range envelopeRange;
  Slider multiplierSlider, offsetSlider;
  Bang enableButton;

  FC_SignalWriter signalWriter;

  int x, y;
  int[] whiteChannels = { 5, 6, 9, 10, 11 };
  protected boolean enabled;
  final static int PANEL_WIDTH  = 400;
  final static int PANEL_HEIGHT = 200;

  GUI_ChannelControl(PApplet p, FC_AudioAnalyzer analyzer, int xCoord, int yCoord) {
    applet = p;
    audioAnalyzer = analyzer;
    x = xCoord;
    y = yCoord;
    inputEq  = new GUI_Eq_Input(10,  10, 150, 50);
    outputEq = new GUI_Eq(10, 90, 150, 50);

    control = new ControlP5(applet);

    rand = new Random();
  }

  public void setup() {
    inputEq.setup();
    outputEq.setup();

    signalWriter = new FC_SignalWriter(FC_SignalWriter.OUTPUT_MODE_PIN);
    envelopeRange = this.setupEnvelopeRange();
    multiplierSlider = this.setupMultiplierSlider();
    offsetSlider = this.setupOffsetSlider();
    enableButton = this.setupEnableBang();
  }

  public void draw() {
    pushMatrix();

    translate(x, y);
    noStroke();
    fill(200);
    rect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
    inputEq.draw(audioAnalyzer.getScaledFeatures(), audioAnalyzer.getEnvelopeMin(), audioAnalyzer.getEnvelopeMax() );
    float[] env = audioAnalyzer.getEnvelope();
    
    if (enabled) {
      outputEq.draw(env);
      // signalWriter.writeSpan(whiteChannels, env);
      signalWriter.writeSimple(whiteChannels, env);
    }

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
                  .setRange(0, FC_AudioAnalyzer.CHANNEL_MAX)
                  .setRangeValues(audioAnalyzer.getEnvelopeMin(), audioAnalyzer.getEnvelopeMax())
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
                  .setRange(-10,10)
                  .setValue(0)
                  .setBroadcast(true);
  }

  Slider setupOffsetSlider() {
    return control.addSlider("offsetSlider")
                  .setId(rand.nextInt())
                  .setBroadcast(false)
                  .setPosition(this.x+225, this.y+10)
                  .setSize(20,150)
                  .setRange(-1, 1)
                  .setValue(0)
                  .setBroadcast(true);
  }

  Bang setupEnableBang() {
    return control.addBang("enableButton")
                  .setPosition(this.x, this.y)
                  .setSize(10, 10)
                  .setId(rand.nextInt())
                  .setTriggerEvent(Bang.RELEASE)
                  .setLabelVisible(false);
  }


  boolean toggleEnabled() {
    this.enabled = !this.enabled;
    return this.enabled;
  }

  void controlEvent(ControlEvent e) {
    int eId = e.getId();
    
    // ENABLE/DISABLE
    if (eId == enableButton.getId()) {
      toggleEnabled();
    }

    // ENVELOPE RANGE
    if (eId == envelopeRange.getId()) {
      int min = (int)e.getController().getArrayValue(0);
      int max = (int)e.getController().getArrayValue(1);
      audioAnalyzer.setEnvelopeRange(min, max);
    }

    // SIGNAL MULTIPLIER
    if (eId == multiplierSlider.getId()) {
      float val = multiplierSlider.getValue();
      audioAnalyzer.setSignalMultiplier(val);
    }

    // SIGNAL OFFSET
    if (eId == offsetSlider.getId()) {
      float val = offsetSlider.getValue();
      audioAnalyzer.setSignalOffset(val);
    }
  }
}