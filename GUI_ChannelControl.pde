class GUI_ChannelControl {

  FC_AudioProcessor audioProcessor;
  GUI_Eq_Input inputEq;
  GUI_Eq outputEq;
  int x, y;
  final static int PANEL_WIDTH  = 360;
  final static int PANEL_HEIGHT = 250;

  GUI_ChannelControl(FC_AudioProcessor processor, int xCoord, int yCoord) {
    audioProcessor = processor;
    x = xCoord;
    y = yCoord;
    inputEq  = new GUI_Eq_Input(50,  10, 300, 100);
    outputEq = new GUI_Eq(50, 120, 300, 100);
  }

  public void setup() {
    noStroke();
    fill(255);

    pushMatrix();
    translate(x, y);
    rect(0, 0, PANEL_WIDTH, PANEL_HEIGHT);

    inputEq.setup();
    outputEq.setup();
    popMatrix();
  }

  public void draw() {
    pushMatrix();
    translate(x, y);
    inputEq.draw(audioProcessor.getScaledFeatures(), audioProcessor.getEnvelopeMin(), audioProcessor.getEnvelopeMax() );
    outputEq.draw(audioProcessor.getEnvelope());
    popMatrix();
  }
}