import beads.*;
import org.jaudiolibs.beads.*;


AudioContext ac;
ShortFrameSegmenter sfs;
PowerSpectrum ps;
FFT fft;

/** 
 * This class is an abstraction to allow for substitution of different
 * audio libraries, such as Minim or Beads. Responsible for providing a
 * raw audio signal or Fast Fourier Transform to the FC_AudioAnalyzer class
 */
class FC_AudioInput {

  public static final int TYPE_TRACK = 1;
  public static final int TYPE_MIC   = 2;
  
  FC_AudioInput(int inputType, String trackName) {
    ac = new AudioContext();
    Gain g = new Gain(ac, 2, 0.3);
    ac.out.addInput(g);

    switch (inputType) {
      case TYPE_TRACK:
        SamplePlayer player = null;
        try {
          String samplePath = sketchPath("") + "data/" + trackName;
          player = new SamplePlayer(ac, new Sample(samplePath));
          g.addInput(player);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;

      case TYPE_MIC:
        UGen microphoneIn = ac.getAudioInput();
        g.addInput(microphoneIn);
        break;
    }

    sfs = new ShortFrameSegmenter(ac);
    sfs.addInput(ac.out);
    fft = new FFT();
    sfs.addListener(fft);
    ps = new PowerSpectrum();
    fft.addListener(ps);
    ac.out.addDependent(sfs);
    ac.start();
  }

  /**
   * Returns logarithmically mapped features of audio signal
   */
  public float[] getFeatures() {
    return ps.getFeatures();
  }

  /**
   * Returns linear features of audio signal
   */
  public float[] getFeaturesLinear() {
    float[] features = {};
    return features;
  }
}
