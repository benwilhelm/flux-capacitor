import controlP5.*;

class View_ChannelControl {

  PApplet applet;
  FC_AudioAnalyzer audioAnalyzer;
  GUI_Eq_Input  inputEq;
  GUI_Eq outputEq;
  Random rand;

  ControlP5 control;
  Bang enableButton;
  Range envelopeRange;
  Slider offsetSlider;
  GUI_SliderMultiplier multiplierSlider;
  Textfield outputChannelSelector;
  DropdownList outputModeSelector;

  Group outputGroupSimple, outputGroupHSB;

  FC_SignalWriter signalWriter;

  int x, y;
  int[] whiteChannels = { 5, 6, 9, 10, 11 };

  protected boolean enabled;
  protected int     outputMode;

  final static int PANEL_WIDTH  = 640;
  final static int PANEL_HEIGHT = 170;

  final protected static int OUTPUT_MODE_SIMPLE = 1;
  final protected static int OUTPUT_MODE_HSB    = 2;

  View_ChannelControl(PApplet p, FC_AudioAnalyzer analyzer, int xCoord, int yCoord) {
    applet = p;
    audioAnalyzer = analyzer;
    x = xCoord;
    y = yCoord;
    inputEq  = new GUI_Eq_Input(25,  10, 150, 50);
    outputEq = new GUI_Eq(25, 90, 150, 50);

    control = new ControlP5(applet);

    rand = new Random();
  }

  public void setup() {
    inputEq.setup();
    outputEq.setup();

    signalWriter = new FC_SignalWriter(FC_SignalWriter.OUTPUT_MODE_PIN);
    envelopeRange = this.setupEnvelopeRange();
    multiplierSlider = new GUI_SliderMultiplier(control, this.x+210, this.y+10);
    offsetSlider = this.setupOffsetSlider();
    enableButton = this.setupEnableBang();
    outputChannelSelector = this.setupOutputChannelSelector();
    outputGroupSimple = this.setupOutputGroupSimple();
    outputGroupHSB = this.setupOutputGroupHSB();
    outputModeSelector = this.setupOutputModeSelector();
  }

  public void draw() {
    pushMatrix();

    translate(x, y);
    noStroke();
    fill(200);
    rect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
    float[] env = audioAnalyzer.getEnvelope();
    int domFreqBin = audioAnalyzer.getDominantFrequencyBin();
    
    inputEq.draw(audioAnalyzer.getScaledFeatures(), domFreqBin, audioAnalyzer.getEnvelopeMin(), audioAnalyzer.getEnvelopeMax() );

    if (enabled) {
      outputEq.draw(env, domFreqBin);
      // signalWriter.writeSpan(whiteChannels, env);
      // signalWriter.writeSimple(whiteChannels, env);
      text(domFreqBin + "", 10, 550);
      enableButton.setColorForeground(color(96, 192, 0));
    } else {
      enableButton.setColorForeground(color(192, 0, 0));
    }

    fill(0);
    text("[Input Selector]", 350, 25);

    popMatrix();
  }



  Range setupEnvelopeRange() {
    return control.addRange("envelopeRange")
                  .setId(rand.nextInt())
                  .setBroadcast(false)
                  .setPosition(this.x+5, this.y+65)
                  .setLabelVisible(false)
                  .setSize(190, 20)
                  .setHandleSize(20)
                  .setRange(0, FC_AudioAnalyzer.CHANNEL_MAX)
                  .setRangeValues(audioAnalyzer.getEnvelopeMin(), audioAnalyzer.getEnvelopeMax())
                  .setBroadcast(true)
                  .setColorForeground(color(120,80))
                  .setColorBackground(color(96,40))
                  ;
  }

  Slider setupOffsetSlider() {
    return control.addSlider("offsetSlider")
                  .setId(rand.nextInt())
                  .setBroadcast(false)
                  .setPosition(this.x+260, this.y+10)
                  .setSize(20,130)
                  .setRange(-1, 1)
                  .setValue(0)
                  .setLabel("+/-")
                  .setBroadcast(true);
  }

  Bang setupEnableBang() {
    return control.addBang("enableButton")
                  .setPosition(this.x+5, this.y+10)
                  .setSize(10, 10)
                  .setId(rand.nextInt())
                  .setTriggerEvent(Bang.RELEASE)
                  .setLabelVisible(false);
  }

  Textfield setupOutputChannelSelector() {
    return control.addTextfield("outputChannelSelector")
                  .setPosition(this.x+450, this.y+10)
                  .setWidth(160)
                  .setLabel("Output Channels")
                  ;
  }

  DropdownList setupOutputModeSelector() {
    DropdownList ddl = control.addDropdownList("outputModeSelector")
                              .setId(rand.nextInt())
                              .setLabel("Output Mode")
                              .setPosition(this.x+350, this.y+60);

    ddl.addItem("Simple", OUTPUT_MODE_SIMPLE);
    ddl.addItem("HSB", OUTPUT_MODE_HSB);

    return ddl;
  }

  Group setupOutputGroupSimple() {
    Group group = control.addGroup("outputGroupSimple");
    group.setPosition(this.x+350, this.y+75)
         .setSize(260, 40)
         .setLabel("Output Simple")
         .setBackgroundColor(128)
         .disableCollapse()
         .setVisible(false);
         ;

    return group;
  }

  Group setupOutputGroupHSB() {
    Group group = control.addGroup("outputGroupHSB");
    group.setPosition(this.x+350, this.y+75)
         .setSize(260, 80)
         .setLabel("Output HSB")
         .setBackgroundColor(128)
         .disableCollapse()
         .setVisible(false)
         ;

    return group;
  }

  boolean toggleEnabled() {
    this.enabled = !this.enabled;
    return this.enabled;
  }

  void toggleOutputGroups() {
    outputGroupSimple.setVisible(false);
    outputGroupHSB.setVisible(false);

    switch (outputMode) {
      case OUTPUT_MODE_SIMPLE:
        outputGroupSimple.setVisible(true);
        break;
      case OUTPUT_MODE_HSB:
        outputGroupHSB.setVisible(true);
        break;
    }
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

    // OUTPUT MODE SELECTOR
    if (eId == outputModeSelector.getId()) {
      outputMode = (int)outputModeSelector.getValue();
      toggleOutputGroups();
    }
  }
}