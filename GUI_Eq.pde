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
    //...
  }

  public void draw(int[] levels) {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(220);
    rect(0, 0, w, h);
    
    fill(96);
    stroke(96);
    float scale = (float)h / (float)channelMax;
    if (levels != null && levels.length > 0) {
      for (int i=0; i<this.w; i++) {
        int levelIndex = (i * levels.length) / this.w;
        int level = (int)( scale * levels[levelIndex] );
        line(i, this.h, i, this.h - level - 1);
      }
    }

    popMatrix();
  }

  public void setChannelMax(int max) {
    channelMax = max;
  }
}