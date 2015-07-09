/**
 * Class is responsible for taking the levels provided by the Audio Processor
 * and the parameter mappings provided by the Channel Control GUI, and writing
 * a DMX512 output signal
 */


class FC_SignalWriter {

  protected int channelMax = 255;
  protected int[] levelArray = new int[512];

  // no setup necessary?
  FC_SignalWriter() {
    Arrays.fill(levelArray, 0);
  }

  int[] setLevelArray(byte[] inputLevels) {
    for (int i=0; i<inputLevels.length; i++) {
      levelArray[i] = artNetListener.toInt(inputLevels[i]);
    }
    return levelArray;
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

  void writeHsb(int[] channels, int hue, int saturation, int brightness) {
    colorMode(HSB);
    color hsbColor = color(hue, saturation, brightness);

    int redVal   = (int)red(hsbColor);
    int greenVal = (int)green(hsbColor);
    int blueVal  = (int)blue(hsbColor);

    for (int i=0; i<channels.length; i++) {
      int redChannel   = channels[i];
      int greenChannel = channels[i]+1;
      int blueChannel  = channels[i]+2;

      writeChannel(redChannel, redVal);
      writeChannel(greenChannel, greenVal);
      writeChannel(blueChannel, blueVal);
    }
    colorMode(RGB);
  }

  void writeChannel(int channel, int level) {
    levelArray[channel - 1] = level;
  }

  void sendLevels() {
    String packet = "";
    for (int i=0; i<levelArray.length; i++) {
      packet += str(i + 1) + "c" + str(levelArray[i]) + "w";
    }
    myPort.write(packet);
  }

  int getChannelMax() {
    return channelMax;
  }
}
