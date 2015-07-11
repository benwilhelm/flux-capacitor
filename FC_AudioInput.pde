import beads.*;
import org.jaudiolibs.beads.*;


AudioContext ac;
ShortFrameSegmenter sfs;
PowerSpectrum ps;
MelSpectrum mel;
Frequency domFreq;
FFT fft;
int lastDominantBin = 0;

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
    Gain g = new Gain(ac, 2, 1.0);
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
    mel = new MelSpectrum(12, FC_AudioAnalyzer.CHANNEL_MAX);
    ps.addListener(mel);
    domFreq = new Frequency(12);
    mel.addListener(domFreq);
    ac.out.addDependent(sfs);
    ac.start();
  }

  public float[] getFeatures() {
    return mel.getFeatures();
  }

  public int getDominantFrequencyBin() {
    try {
      float freq = domFreq.getFeatures();
      int bin = mel.getBinForFreq(freq);
      if (bin == FC_AudioAnalyzer.CHANNEL_MAX - 1) {
        bin = 0;
      }

      return bin;
    } catch (Exception e) {
      return 0;
    }
  }

}
