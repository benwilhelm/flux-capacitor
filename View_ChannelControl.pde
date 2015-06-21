import controlP5.*;

class View_ChannelControl {

  PApplet applet;
  FC_AudioAnalyzer audioAnalyzer;
  GUI_Eq_Input  inputEq;
  GUI_Eq outputEq;

  ControlP5 control;

  GUI_BangEnableChannel enableButton;
  GUI_SliderMultiplier  multiplierSlider;
  GUI_SliderOffset      offsetSlider;
  GUI_RangeEnvelope     envelopeRange;

  GUI_TextfieldOutputChannels outputChannelSelector;
  GUI_GroupOutputSimple       outputGroupSimple;
  GUI_GroupOutputHSB          outputGroupHSB;
  GUI_DropdownOutputMode      outputModeSelector;

  FC_SignalWriter signalWriter;

  int x, y;
  int[] whiteChannels = { 5, 6, 9, 10, 11 };

  protected boolean enabled;
  protected int     outputMode;

  final static int PANEL_WIDTH  = 640;
  final static int PANEL_HEIGHT = 170;

  View_ChannelControl(PApplet p, FC_AudioAnalyzer analyzer, int xCoord, int yCoord) {
    applet = p;
    audioAnalyzer = analyzer;
    x = xCoord;
    y = yCoord;

    control = new ControlP5(applet);
    signalWriter = new FC_SignalWriter(FC_SignalWriter.OUTPUT_MODE_PIN);

    enableButton     = new GUI_BangEnableChannel(control, "enableButton", this.x+5, this.y+10);
    inputEq  = new GUI_Eq_Input(25,  10, 200, 50);
    outputEq = new GUI_Eq(25, 90, 200, 50);
    envelopeRange    = new GUI_RangeEnvelope(control, "envelopeRange", this.x+5, this.y+65);

    multiplierSlider = new GUI_SliderMultiplier(control, "multiplierSlider", this.x+250, this.y+10);
    offsetSlider     = new GUI_SliderOffset(control, "offsetSlider", this.x+300, this.y+10);

    outputChannelSelector = new GUI_TextfieldOutputChannels(control, "outputChannelSelector", this.x+450, this.y+10);
    outputGroupSimple     = new GUI_GroupOutputSimple(control, "outputGroupSimple", this.x+350, this.y+75);
    outputGroupHSB        = new GUI_GroupOutputHSB(control, "outputGroupHSB", this.x+350, this.y+75);
    outputModeSelector    = new GUI_DropdownOutputMode(control, "outputModeSelector", this.x+350, this.y+60);

  }

  public void setup() {
    inputEq.setup();
    outputEq.setup();
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
      outputEq.draw(env, domFreqBin-audioAnalyzer.getEnvelopeMin());
      // signalWriter.writeSpan(whiteChannels, env);
      // signalWriter.writeSimple(whiteChannels, env);
      enableButton.setColorForeground(color(96, 192, 0));
    } else {
      enableButton.setColorForeground(color(192, 0, 0));
    }

    fill(0);
    text("[Input Selector]", 350, 25);

    popMatrix();
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