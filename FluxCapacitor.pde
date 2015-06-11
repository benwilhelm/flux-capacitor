import processing.opengl.*;

FC_AudioInput input1;
FC_AudioProcessor processor1;
GUI_ChannelControl channel1Control;

void setup() {
  frameRate(30);
  size(600, 400, OPENGL);

  input1 = new FC_AudioInput("08-Strobes.mp3", FC_AudioInput.TYPE_TRACK);
  processor1 = new FC_AudioProcessor(input1);
  channel1Control = new GUI_ChannelControl(processor1, 10, 10);

  channel1Control.setup();
}

void draw() {
  background(255);
  channel1Control.draw();
}