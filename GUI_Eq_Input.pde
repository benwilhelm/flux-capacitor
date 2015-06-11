class GUI_Eq_Input extends GUI_Eq {

  GUI_Eq_Input(int xCoord, int yCoord, int width, int height) {
    super(xCoord, yCoord, width, height);
  }

  public void draw(int[] levels, int tickMin, int tickMax) {
    float scale = (float)this.h / (float)this.channelMax;
    if (levels != null && levels.length > 0) {
      for (int i=0; i<this.w; i++) {
        int levelIndex = (i * levels.length) / this.w;
        
        stroke(96);
        if (levelIndex >= tickMin && levelIndex < tickMax) {
          stroke(128, 128, 0);
        }

        int level = (int)( scale * levels[levelIndex] );
        line(i+x, this.h+y, i+x, this.h + y - level - 1);
      }
    }
  }
}