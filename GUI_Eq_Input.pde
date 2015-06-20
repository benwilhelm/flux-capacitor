class GUI_Eq_Input extends GUI_Eq {

  GUI_Eq_Input(int xCoord, int yCoord, int width, int height) {
    super(xCoord, yCoord, width, height);
  }

  public void draw(float[] levels, int domFreqBin, int tickMin, int tickMax) {
    pushMatrix();
    translate(this.x, this.y);
    noStroke();
    fill(220);
    rect(0, 0, w, h);

    if (levels != null && levels.length > 0) {
      for (int i=0; i<this.w; i++) {
        int levelIndex = (i * levels.length) / this.w;
        
        stroke(96);
        if (levelIndex >= tickMin && levelIndex < tickMax) {
          stroke(96, 192, 0);
        }

        int level = (int)( levels[levelIndex] * this.h );
        line(i, this.h, i, this.h - level - 1);
      }
    }

    stroke(255, 0, 0);
    int domFreqX;
    if (levels.length > 0) {
      domFreqX = domFreqBin * this.w / levels.length;
    } else {
      domFreqX = 0;
    }
    line(domFreqX, this.h, domFreqX, 0);

    popMatrix();
  }
}