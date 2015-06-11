class GUI_Eq {

  protected int x, y, w, h;
  protected int channelMax = 256;

  GUI_Eq(int xCoord, int yCoord, int width, int height) {
    x = xCoord;
    y = yCoord;
    w = width;
    h = height;
  }

  public void setup() {
    fill(192);
    rect(x, y, w, h);
  }

  public void draw(int[] levels) {
    stroke(96);
    float scale = (float)h / (float)channelMax;
    if (levels != null && levels.length > 0) {
      for (int i=0; i<this.w; i++) {
        int levelIndex = (i * levels.length) / this.w;
        int level = (int)( scale * levels[levelIndex] );
        line(i+x, this.h+y, i+x, this.h + y - level - 1);
      }
    }
  }

  public void setChannelMax(int max) {
    channelMax = max;
  }
}