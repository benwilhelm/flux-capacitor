/**
 * Class is responsible for taking the levels provided by the Audio Processor
 * and the parameter mappings provided by the Channel Control GUI, and writing
 * a DMX512 output signal
 */

import cc.arduino.*;

class FC_SignalWriter {

  final static int OUTPUT_MODE_DMX = 512;
  final static int OUTPUT_MODE_PIN = 13;
  protected int outputMode, channelMax;
  protected Arduino arduino;

  FC_SignalWriter(int oMode) {
    arduino = FC_Arduino.getInstance();
    outputMode = oMode;
    
    switch(oMode) {
    case OUTPUT_MODE_PIN:
      channelMax = 255;
      break;

    case OUTPUT_MODE_DMX:
      channelMax = 255;
      break;
    }
  }

  void writeSimple(int[] channels, float[] inputLevels) {
    int outputLevel = (int) (channelMax * max(inputLevels));

    for (int i=0; i<channels.length; i++) {
      writeChannel(channels[i], outputLevel);
    }
  }

  void writeSpan(int[] channels, float[] inputLevels) {
    if (inputLevels == null) {
      return;
    }

    int[] outputLevels = {};
    float outputLevel = 0;
    // int widthOfBand = (int) inputLevels.length / channels.length;
    for (int i=0; i<inputLevels.length; i++) {
      int outputIndex =  (int) (i * channels.length) / inputLevels.length;

      if (outputIndex == outputLevels.length && i < inputLevels.length - 1) {
        outputLevel = max(outputLevel, inputLevels[i]); 
      } else {

        if (i == inputLevels.length - 1) {
          outputIndex++;
        }

        outputLevel = constrain(outputLevel, 0, channelMax);
        outputLevels = append(outputLevels, (int)(outputLevel * channelMax));
        outputLevel = 0;        
      }
    }

    for (int i=0; i<channels.length; i++) {
      if (i < outputLevels.length) {
        writeChannel(channels[i], outputLevels[i]);
      }
    }
  }

  void writeChannel(int channel, int level) {
    switch(outputMode) {
    case OUTPUT_MODE_PIN:
      writePin(channel, level);
      break;

    case OUTPUT_MODE_DMX:
      writeDmx(channel, level);
      break;
    }
  }

  void writePin(int channel, int level) {
    int intensity = channelMax - level;
    if (level == 0) {
      arduino.digitalWrite(channel, ANODE_LOW);
    } else {
      arduino.analogWrite(channel, intensity);
    }

    // text(channel + ": " + level, channel * 80 - 400, 550);
  }

  void writeDmx(int channel, int level) {
    return;
  }

}