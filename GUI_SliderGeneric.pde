import controlP5.*;

class GUI_SliderGeneric extends Slider {

  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_SliderGeneric(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;
  }

  void setValueDmx(int dmxValue) {
    float val = map(dmxValue, 0, 255, this.getMin(), this.getMax());
    this.setValue(val);
  }
}
