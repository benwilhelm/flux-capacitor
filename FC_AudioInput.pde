import beads.*;
import org.jaudiolibs.beads.*;


AudioContext ac;
ShortFrameSegmenter sfs;
PowerSpectrum ps;
FFT fft;

/** 
 * This class is an abstraction to allow for substitution of different
 * audio libraries, such as Minim or Beads. Responsible for providing a
 * raw audio signal or Fast Fourier Transform to the FC_AudioProcessor class
 */
class FC_AudioInput {

  public static final int TYPE_TRACK = 1;
  public static final int TYPE_INPUT = 2;
  
  FC_AudioInput(String trackName, int inputType) {
    ac = new AudioContext();
    Gain g = new Gain(ac, 2, 0.3);
    ac.out.addInput(g);

    SamplePlayer player = null;
    try {
      String samplePath = sketchPath("") + "data/" + trackName;
      player = new SamplePlayer(ac, new Sample(samplePath));
      g.addInput(player);
    } catch (Exception e) {
      e.printStackTrace();
    }


    // UGen microphoneIn = ac.getAudioInput();
    sfs = new ShortFrameSegmenter(ac);
    sfs.addInput(ac.out);
    // sfs.addInput(microphoneIn);
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
  public int[] getFeaturesLinear() {
    int[] features = {};
    return features;
  }
}
