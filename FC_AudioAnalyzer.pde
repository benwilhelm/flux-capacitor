import java.util.Arrays;

/**
 * Class is responsible for taking the FFT from the given audio input and
 * providing the values from the selected envelope transformations
 */
class FC_AudioAnalyzer {


  FC_AudioInput audioInput;

  public final static int CHANNEL_MAX = 32;

  protected int envelopeMin = 0;
  protected int envelopeMax = CHANNEL_MAX;
  protected float signalOffset  = 0;
  protected float signalMultiplier = 1;
  protected float inertia = 0;
  protected float[][] levelHistory = new float[CHANNEL_MAX][];
  protected int[] domFreqBinHistory = new int[0];
  protected int lastDominantBin = 0;

  FC_AudioAnalyzer(FC_AudioInput theInput) {
    audioInput = theInput;
  }


  public void setup() {

  }

  public void draw() {

  }

  /**
   * returns audioInput's features mapped through the envelope parameters
   */
  public float[] getEnvelope() {
    float[] levels = getScaledFeatures();
    if (levels.length > 0) {
      int eMin = envelopeMin;
      int eMax = envelopeMin < envelopeMax ? envelopeMax : envelopeMin;
      eMax = min(eMax, levels.length);
      return Arrays.copyOfRange(levels, eMin, eMax);
    }
    return null;
  }

  public float[] getScaledFeatures() {
    float[] features = Arrays.copyOfRange(audioInput.getFeatures(), 0, FC_AudioAnalyzer.CHANNEL_MAX);
    // return features;
    float[] outputLevels = {};
    float multiplyBy = convertMultiplier(signalMultiplier);

    if (features != null && features.length > 0) {
      for (int i=0; i<features.length; i++) {
        float level = features[i];

        int historyLength = getLevelHistoryLength();
        if (levelHistory[i] == null) {
          levelHistory[i] = new float[historyLength];
        }
        levelHistory[i] = append(levelHistory[i], 0);
        levelHistory[i] = Arrays.copyOfRange(levelHistory[i], 0, historyLength);
        levelHistory[i] = splice(levelHistory[i], level, 0);
        float historicLevel = average(levelHistory[i]);

        level = max(level, historicLevel);
        level *= multiplyBy;
        level += signalOffset;
        level  = constrain(level, 0, 1);
        outputLevels = append(outputLevels, level);
      }
    }
    return outputLevels;
  }

  public int getDominantFrequencyBin() {
    int bin = audioInput.getDominantFrequencyBin();
    int ret = bin;
    if (bin <= envelopeMin) {
      ret = lastDominantBin;
    } else if ( bin > envelopeMax){
      ret = envelopeMax + 1;
    } else {
      int historyLength = getLevelHistoryLength();
      domFreqBinHistory = splice(domFreqBinHistory, bin, 0);
      domFreqBinHistory = Arrays.copyOfRange(domFreqBinHistory, 0, historyLength+1);
      int historicBin = average(domFreqBinHistory);
      ret = max(bin, historicBin);
      lastDominantBin = ret;
    }
    return ret;
  }

  public void setEnvelopeMin(int min) {
    envelopeMin = min;
  }

  public int getEnvelopeMin() {
    return envelopeMin;
  }

  public void setEnvelopeMax(int max) {
    envelopeMax = max;
  }

  public int getEnvelopeMax() {
    return envelopeMax;
  }

  public void setEnvelopeRange(int min, int max) {
    envelopeMin = min;
    envelopeMax = max;
  }

  public void setSignalMultiplier(float mult) {
    signalMultiplier = mult;
  }

  public float getSignalMultiplier() {
    return signalMultiplier;
  }

  public void setSignalOffset(float offset) {
    signalOffset = offset;
  }

  public float getSignalOffset() {
    return signalOffset;
  }

  public float getInertia() {
    return inertia;
  }

  public void setInertia(float i) {
    inertia = i;
  }

  /**
   * Poor man's log scale for the multiplier.
   * Negative values divide, positive values multiply
   * Values between -1 and 1 do nothing
   */
  protected float convertMultiplier(float mult) {
    if (mult >= -1 && mult <= 1) {
      mult = 1;
    } else if (mult < -1) {
      mult = -1 / mult;
    }

    return mult;
  }

  protected int getLevelHistoryLength() {
    return (int) (inertia * frameRate);
  }
}
