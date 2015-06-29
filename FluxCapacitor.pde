import processing.opengl.*;
import processing.serial.*;
import cc.arduino.*;

FC_AudioInput input1;
FC_AudioAnalyzer analyzer1, analyzer2;
View_ChannelControl channel1Control, channel2Control;


final color COLOR_DARK_GREY = color(96);
Serial myPort;

void setup() {
  frameRate(30);
  size(800, 600, OPENGL);
  colorMode(HSB);
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 57600);

  input1 = new FC_AudioInput(FC_AudioInput.TYPE_MIC, "");
  
  analyzer1 = new FC_AudioAnalyzer(input1);
  analyzer2 = new FC_AudioAnalyzer(input1);

  channel1Control = new View_ChannelControl(this, analyzer1, 10,  10);
  channel2Control = new View_ChannelControl(this, analyzer2, 10, 220);

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

