/**
 * Class is responsible for taking the FFT from the given audio input and 
 * providing the values from the selected envelope transformations
 */

class FC_AudioAnalyzer {

  FC_AudioInput audioInput;
  
  public final static int CHANNEL_MAX = 256;

  protected int envelopeMin = 0; 
  protected int envelopeMax = CHANNEL_MAX; 
  protected float signalOffset  = 0;
  protected float signalMultiplier = 1;


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
      eMax = min(eMax, levels.length-1);
      return Arrays.copyOfRange(levels, eMin, eMax);
    }
    return null;
  }

  /**
   * Passthru method for audioInput.getFeatures()
   */
  public float[] getScaledFeatures() {
    float[] features = audioInput.getFeatures();
    float[] outputLevels = {};

    float multiplyBy = convertMultiplier(signalMultiplier);

    if (features != null && features.length > 0) {
      for (int i=0; i<features.length; i++) {
        float level = features[i];
        level *= multiplyBy;
        level += signalOffset;
        level  = constrain(level, 0, 1);
        outputLevels = append(outputLevels, level);
      }
    }
    return outputLevels;
  }

  /**
   * Passthru method for audioInput.getDominantFrequency()
   */
  public int getDominantFrequencyBin() {
    return audioInput.getDominantFrequencyBin();
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
}