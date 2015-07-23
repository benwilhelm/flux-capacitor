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
  GUI_SliderInertia     inertiaSlider;
  GUI_RangeEnvelope     envelopeRange;

  GUI_TextfieldOutputChannels outputChannelSelector;
  GUI_GroupOutputSimple       outputGroupSimple;
  GUI_GroupOutputHSB          outputGroupHSB;
  GUI_DropdownOutputMode      outputModeSelector;

  int x, y;
  int startDmxChannel;
  int[] outputChannels;
  float[] env;

  protected boolean enabled;
  protected int outputMode, simpleAttribute, hueAttribute, saturationAttribute, brightnessAttribute;

  final static int PANEL_WIDTH  = 640;
  final static int PANEL_HEIGHT = 170;

  final static int OUTPUT_MODE_SIMPLE = 2;
  final static int OUTPUT_MODE_HSB    = 4;

  final static int ATTRIBUTE_FREQUENCY =   8;
  final static int ATTRIBUTE_VOLUME    =  16;
  final static int ATTRIBUTE_FULLNESS  =  32;
  final static int ATTRIBUTE_SPECTRUM  =  64;
  final static int ATTRIBUTE_DEFINE    = 128;


  View_ChannelControl(PApplet p, FC_AudioAnalyzer analyzer, int xCoord, int yCoord) {
    applet = p;
    audioAnalyzer = analyzer;
    x = xCoord;
    y = yCoord;

    control = new ControlP5(applet);

    enableButton     = new GUI_BangEnableChannel(control, "enableButton", this.x+5, this.y+10);
    inputEq  = new GUI_Eq_Input(25,  10, 200, 50);
    outputEq = new GUI_Eq(25, 90, 200, 50);
    envelopeRange    = new GUI_RangeEnvelope(control, "envelopeRange", this.x+5, this.y+65);

    multiplierSlider = new GUI_SliderMultiplier(control, "multiplierSlider", this.x+250, this.y+10);
    offsetSlider     = new GUI_SliderOffset(control, "offsetSlider", this.x+285, this.y+10);
    inertiaSlider    = new GUI_SliderInertia(control, "inertiaSlider", this.x+320, this.y+10);

    outputChannelSelector = new GUI_TextfieldOutputChannels(control, "outputChannelSelector", this.x+450, this.y+10);
    outputGroupSimple     = new GUI_GroupOutputSimple(control, "outputGroupSimple", this.x+350, this.y+75);
    outputGroupHSB        = new GUI_GroupOutputHSB(control, "outputGroupHSB", this.x+350, this.y+75);
    outputModeSelector    = new GUI_DropdownOutputMode(control, "outputModeSelector", this.x+350, this.y+60);

  }

  public void setup(int startChannel) {
    inputEq.setup();
    outputEq.setup();
    startDmxChannel = startChannel;
  }

  public void draw() {
    pushMatrix();

    translate(x, y);
    noStroke();
    fill(200);
    rect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);
    env = audioAnalyzer.getEnvelope();
    int domFreqBin = audioAnalyzer.getDominantFrequencyBin();
    outputChannels = outputChannelSelector.getChannels();
    inputEq.draw(audioAnalyzer.getScaledFeatures(), domFreqBin, audioAnalyzer.getEnvelopeMin(), audioAnalyzer.getEnvelopeMax() );

    if (enabled) {
      outputEq.draw(env, domFreqBin-audioAnalyzer.getEnvelopeMin());
      enableButton.setColorForeground(color(96, 192, 0));
      writeChannels();
    } else {
      enableButton.setColorForeground(color(192, 0, 0));
    }

    if (ENABLE_ARTNET_IN) {
      setValuesFromArtnet();
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

  protected void writeChannels() {
    switch (outputMode) {
    case OUTPUT_MODE_SIMPLE:
      writeChannelsSimple();
      break;

    case OUTPUT_MODE_HSB:
      writeChannelsHSB();
      break;
    }
  }

  protected void writeChannelsSimple() {
    if (env.length <= 0) {
      return;
    }
    
    float[] levels = { 0 };
    switch (simpleAttribute) {
    case ATTRIBUTE_SPECTRUM:
      levels = env;
      signalWriter.writeSpan(outputChannels, levels);
      break;

    case ATTRIBUTE_FULLNESS:
      float fullness = average(env);
      levels[0] = fullness;
      signalWriter.writeSimple(outputChannels, levels);
      break;

    case ATTRIBUTE_VOLUME:
      float max = max(env);
      levels[0] = max;
      signalWriter.writeSimple(outputChannels, levels);
      break;

    case ATTRIBUTE_FREQUENCY:
      int domFreqBin = audioAnalyzer.getDominantFrequencyBin();
      int envMin = audioAnalyzer.getEnvelopeMin();
      int envMax = audioAnalyzer.getEnvelopeMax();
      float level = (float) map(domFreqBin, envMin, envMax, 0, 1);
      levels[0] = level;
      signalWriter.writeSimple(outputChannels, levels);
      break;
    }

  }

  protected void writeChannelsHSB() {
    int hue        = getAttributeValue(hueAttribute, "hue");
    int saturation = getAttributeValue(saturationAttribute, "saturation");
    int brightness = getAttributeValue(brightnessAttribute, "brightness");

    signalWriter.writeHsb(outputChannels, hue, saturation, brightness);
  }

  protected void killChannels() {
    switch (outputMode) {
    case OUTPUT_MODE_SIMPLE:
      float[] zeroLevel = {0};
      signalWriter.writeSimple(outputChannels, zeroLevel);
      break;

    case OUTPUT_MODE_HSB:
      writeChannelsHSB();
      signalWriter.writeHsb(outputChannels, 0, 0, 0);
      break;
    }
  }

  protected int getAttributeValue(int att, String def) {

    int ret = 0;
    switch ( att ) {
    case ATTRIBUTE_FULLNESS:
      float fullness = average(env);
      ret = (int) map(fullness, 0, 1, 0, signalWriter.getChannelMax());
      break;

    case ATTRIBUTE_VOLUME:
      float max = max(env);
      ret = (int) map(max, 0, 1, 0, signalWriter.getChannelMax());
      break;

    case ATTRIBUTE_FREQUENCY:
      int domFreqBin = audioAnalyzer.getDominantFrequencyBin();
      int envMin = audioAnalyzer.getEnvelopeMin();
      int envMax = audioAnalyzer.getEnvelopeMax();
      ret = (int) map(domFreqBin, envMin, envMax, 0, signalWriter.getChannelMax());
      break;

    case ATTRIBUTE_DEFINE:

      GUI_TextfieldAttribute attDefiner = null;

      if (def == "hue") {
        attDefiner = outputGroupHSB.hueAttributeInput;
      }

      if (def == "saturation") {
        attDefiner = outputGroupHSB.saturationAttributeInput;
      }

      if (def == "brightness") {
        attDefiner = outputGroupHSB.brightnessAttributeInput;
      }

      if (attDefiner != null) {
        try {
          ret = Integer.parseInt(attDefiner.getText());
        } catch (Exception e) {}
      }
      break;
    }

    return ret;
  }

  void setValuesFromArtnet() {
    this.enabled    = artNetListener.getChannelValue(this.startDmxChannel) > 0;
    int rangeMinDmx = artNetListener.getChannelValue(this.startDmxChannel + 1);
    int rangeMaxDmx = artNetListener.getChannelValue(this.startDmxChannel + 2);
    int multDmx     = artNetListener.getChannelValue(this.startDmxChannel + 3);
    int offsetDmx   = artNetListener.getChannelValue(this.startDmxChannel + 4);
    int inertiaDmx  = artNetListener.getChannelValue(this.startDmxChannel + 5);
    int outputModeDmx = artNetListener.getChannelValue(this.startDmxChannel + 6);
    int simpleOutputSelectorDmx = artNetListener.getChannelValue(this.startDmxChannel + 7);

    int hueAttributeDmx = artNetListener.getChannelValue(this.startDmxChannel + 8);
    int saturationAttributeDmx = artNetListener.getChannelValue(this.startDmxChannel + 9);
    int brightnessAttributeDmx = artNetListener.getChannelValue(this.startDmxChannel + 10);

    envelopeRange.setRangeByDmx(rangeMinDmx, rangeMaxDmx);
    multiplierSlider.setValueDmx(multDmx);
    offsetSlider.setValueDmx(offsetDmx);
    inertiaSlider.setValueDmx(inertiaDmx);
    outputModeSelector.setIndexDmx(outputModeDmx);
    outputGroupSimple.simpleAttributeSelector.setIndexDmx(simpleOutputSelectorDmx);
    outputGroupHSB.hueAttributeSelector.setIndexDmx(hueAttributeDmx);
    outputGroupHSB.saturationAttributeSelector.setIndexDmx(saturationAttributeDmx);
    outputGroupHSB.brightnessAttributeSelector.setIndexDmx(brightnessAttributeDmx);
  }

  void controlEvent(ControlEvent e) {
    int eId = e.getId();

    // ENABLE/DISABLE
    if (eId == enableButton.getId()) {
      boolean enbl = toggleEnabled();
      if (!enbl) {
        killChannels();
      }
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

    // INERTIA
    if (eId == inertiaSlider.getId()) {
      float val = inertiaSlider.getValue();
      audioAnalyzer.setInertia(val);
    }

    // OUTPUT MODE SELECTOR
    if (eId == outputModeSelector.getId()) {
      outputMode = (int)outputModeSelector.getValue();
      toggleOutputGroups();
    }

    if (eId == outputGroupSimple.simpleAttributeSelector.getId()) {
      simpleAttribute = (int)outputGroupSimple.simpleAttributeSelector.getValue();
    }

    if (eId == outputGroupHSB.hueAttributeSelector.getId()) {
      hueAttribute = (int)outputGroupHSB.hueAttributeSelector.getValue();
    }

    if (eId == outputGroupHSB.saturationAttributeSelector.getId()) {
      saturationAttribute = (int)outputGroupHSB.saturationAttributeSelector.getValue();
    }

    if (eId == outputGroupHSB.brightnessAttributeSelector.getId()) {
      brightnessAttribute = (int)outputGroupHSB.brightnessAttributeSelector.getValue();
    }
  }
}
