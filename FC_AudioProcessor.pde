/**
 * Class is responsible for taking the FFT from the given audio input and 
 * providing the values from the selected envelope transformations
 */

class FC_AudioProcessor {

  FC_AudioInput audioInput;

  protected int envelopeMin = 0; 
  protected int envelopeMax = 50; 
  protected int signalOffset  = 0;
  protected float signalMultiplier = 1;

  public final static int CHANNEL_MAX = 256;

  FC_AudioProcessor(FC_AudioInput theInput) {
    audioInput = theInput;
  }


  public void setup() {

  }

  public void draw() {

  }

  /**
   * returns audioInput's features mapped through the envelope parameters
   */
  public int[] getEnvelope() {
    int[] levels = getScaledFeatures();
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
  public int[] getScaledFeatures() {
    float[] features = audioInput.getFeatures();
    int[]   outputLevels = {};
    if (features != null && features.length > 0) {
      for (int i=0; i<features.length; i++) {
        float feature = features[i];        
        int level = (int)(feature * CHANNEL_MAX);
        level *= signalMultiplier;
        level += signalOffset;
        level  = constrain(level, 0, CHANNEL_MAX);
        outputLevels = append(outputLevels, level);
      }
    }
    return outputLevels;
  }

  /**
   * Passthru method for audioInput.getFeaturesLinear()
   */
  public int[] getInputFeaturesLinear() {
    return audioInput.getFeaturesLinear();
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

  public void setSignalMultiplier(float mult) {
    signalMultiplier = mult;
  }

  public float getSignalMultiplier() {
    return signalMultiplier;
  }
}