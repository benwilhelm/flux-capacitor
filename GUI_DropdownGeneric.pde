import controlP5.*;

class GUI_DropdownGeneric extends DropdownList {

  Random rand = new Random();
  ControlP5 control;
  int x, y;

  GUI_DropdownGeneric(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;
  }


  void setIndexDmx(int dmxValue) {
    int idx = (int) map(dmxValue, 0, 255, 0, this.getListBoxItems().length);
    this.setIndex(idx);
  }
}
