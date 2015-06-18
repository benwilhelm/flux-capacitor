class GUI_Eq {

  protected int x, y, w, h;

  GUI_Eq(int xCoord, int yCoord, int width, int height) {
    x = xCoord;
    y = yCoord;
    w = width;
    h = height;
  }

  public void setup() {
    //...
  }

  public void draw(float[] levels) {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(220);
    rect(0, 0, w, h);
    
    fill(96);
    stroke(96);
    if (levels != null && levels.length > 0) {
      for (int i=0; i<this.w; i++) {
        int levelIndex = (i * levels.length) / this.w;
        int level = (int)( levels[levelIndex] * this.h );
        line(i, this.h, i, this.h - level - 1);
      }
    }

    popMatrix();
  }

}