import processing.opengl.*;
import processing.serial.*;
import cc.arduino.*;

FC_AudioInput input1;
FC_AudioAnalyzer analyzer1, analyzer2;
View_ChannelControl channel1Control, channel2Control;

Arduino arduino;

final int ANODE_LOW  = Arduino.HIGH;
final int ANODE_HIGH = Arduino.LOW;

void setup() {
  frameRate(30);
  size(800, 600, OPENGL);
  
  FC_Arduino.initialize(this);
  arduino = FC_Arduino.getInstance();

  input1 = new FC_AudioInput(FC_AudioInput.TYPE_MIC, "");
  
  analyzer1 = new FC_AudioAnalyzer(input1);
  analyzer2 = new FC_AudioAnalyzer(input1);

  channel1Control = new View_ChannelControl(this, analyzer1, 10,  10);
  channel2Control = new View_ChannelControl(this, analyzer2, 10, 220);

  channel1Control.setup();
  channel2Control.setup();

  for (int pin=3; pin<=13; pin++) {
    arduino.pinMode(pin, Arduino.OUTPUT);
    arduino.digitalWrite(pin, ANODE_LOW);
  }
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