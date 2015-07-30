/**
 * Class is responsible for taking the levels provided by the Audio Processor
 * and the parameter mappings provided by the Channel Control GUI, and writing
 * a DMX512 output signal
 */


class FC_SignalWriter {

  protected int channelMax = 255;
  protected int[] levelArray = new int[512];
  protected int[] lastLevelArray = new int[512];

  FC_SignalWriter() {
    Arrays.fill(lastLevelArray, 0);
    Arrays.fill(levelArray, 0);
  }

  void resetLevels() {
    lastLevelArray = Arrays.copyOf(levelArray, levelArray.length);
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
        outputLevel = constrain(outputLevel, 0, channelMax);
        outputLevels = append(outputLevels, (int)(outputLevel * channelMax));
        outputLevel = inputLevels[i];
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
    int idx = channel-1;
    int newLevel = levelArray[idx] + level;
    levelArray[idx] = constrain(newLevel, 0, channelMax);
  }

  void sendLevels() {
    String packet = "";
    for (int i=0; i<levelArray.length; i++) {
      if (levelArray[i] != lastLevelArray[i]) {
        packet += str(i + 1) + "c" + str(levelArray[i]) + "w";
      }
    }
    myPort.write(packet);
  }

  int getChannelMax() {
    return channelMax;
  }

  void debug(int startChan, int endChan) {
    fill(96);
    noStroke();
    int x = 10;
    int y = height - 20;
    text("Debug Channels: ", x, y);
    x += 125;
    for (int i=startChan; i<=endChan; i++) {
      int level = levelArray[i-1];
      String out = i + ": " + level;
      text(out, x, y);
      rect(x+50, y - level/2, 10, level/2);
      x += 100;
    }
  }
}
