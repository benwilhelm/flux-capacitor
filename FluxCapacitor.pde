import processing.opengl.*;

FC_AudioInput input1;
FC_AudioProcessor processor1, processor2;
GUI_ChannelControl channel1Control, channel2Control;

final PApplet APPLET = this;

void setup() {
  frameRate(30);
  size(800, 600, OPENGL);

  input1 = new FC_AudioInput("08-Strobes.mp3", FC_AudioInput.TYPE_TRACK);
  
  processor1 = new FC_AudioProcessor(input1);
  processor2 = new FC_AudioProcessor(input1);

  channel1Control = new GUI_ChannelControl(processor1, 10,  10);
  channel2Control = new GUI_ChannelControl(processor2, 10, 220);

  channel1Control.setup();
  channel2Control.setup();
}

void draw() {
  background(255);
  channel1Control.draw();
  channel2Control.draw();
}

void controlEvent(ControlEvent e) {
  channel1Control.controlEvent(e);
  channel2Control.controlEvent(e);
}