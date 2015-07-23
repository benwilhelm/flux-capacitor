import processing.opengl.*;
import processing.serial.*;
import cc.arduino.*;

FC_AudioInput input1;
FC_AudioAnalyzer analyzer1, analyzer2;
View_ChannelControl channel1Control, channel2Control;
ArtNetListener artNetListener;
FC_SignalWriter signalWriter;

final color   COLOR_DARK_GREY = color(96);
final int     DMX_ADDRESS_START = 13;
final boolean ENABLE_ARTNET_IN  = true;
Serial myPort;

byte[] inputDmxArray;

void setup() {
  frameRate(30);
  size(800, 600, OPENGL);

  println("Available Serial Ports:");
  printArray(Serial.list());
  String portName = Serial.list()[5];
  println(portName);
  println("Using Port: " + portName);
  myPort = new Serial(this, portName, 9600);

  input1 = new FC_AudioInput(FC_AudioInput.TYPE_MIC, "");
  artNetListener = new ArtNetListener();
  signalWriter = new FC_SignalWriter();

  analyzer1 = new FC_AudioAnalyzer(input1);
  analyzer2 = new FC_AudioAnalyzer(input1);

  channel1Control = new View_ChannelControl(this, analyzer1, 10,  10);
  channel2Control = new View_ChannelControl(this, analyzer2, 10, 220);

  channel1Control.setup(DMX_ADDRESS_START);
  channel2Control.setup(DMX_ADDRESS_START + 12);

  println("Setup complete.");
}

void draw() {
  background(255);
  inputDmxArray = artNetListener.getCurrentInputDmxArray();
  signalWriter.resetLevels();
  signalWriter.setLevelArray(inputDmxArray);
  channel1Control.draw();
  channel2Control.draw();
  signalWriter.debug(1, 6);
  signalWriter.sendLevels();
}

void exit() {
  println( "Exiting ...");
  artNetListener.stopArtNet();
  super.exit();
}

void controlEvent(ControlEvent e) {
  channel1Control.controlEvent(e);
  channel2Control.controlEvent(e);
}


float average(float[] elements) {
  float sum = 0;
  for (int i=0; i<elements.length; i++) {
    sum += elements[i];
  }
  return sum/elements.length;
}

int average(int[] elements) {
  int sum = 0;
  for (int i=0; i<elements.length; i++) {
    sum += elements[i];
  }
  return sum/elements.length;
}
