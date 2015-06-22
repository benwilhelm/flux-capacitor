import controlP5.*;

class GUI_GroupOutputHSB extends Group {
  
  Random rand = new Random();
  ControlP5 control;
  int x, y;
  GUI_DropdownAttributeSelector hueAttributeSelector, saturationAttributeSelector, brightnessAttributeSelector;
  GUI_TextfieldAttribute hueAttributeInput, saturationAttributeInput, brightnessAttributeInput;

  Knob knobHue, knobSaturation, knobBrightness;


  GUI_GroupOutputHSB(ControlP5 ctrl, String name, int xCoord, int yCoord) {
    super(ctrl, name);
    control = ctrl;
    this.x = xCoord;
    this.y = yCoord;

    this.setId(rand.nextInt())
        .setPosition(x, y)
        .setSize(260, 80)
        .setLabel("Output HSB")
        .setBackgroundColor(128)
        .disableCollapse()
        .setVisible(false)
        ;


    // listed in reverse order for rendering stack purposes.
    // surely there's a better way, but I don't know it at the moment.
    brightnessAttributeSelector = new GUI_DropdownAttributeSelector(ctrl, "brightnessAttributeSelector", 20, 70);
    brightnessAttributeSelector.setGroup(this);
    brightnessAttributeSelector.addItem("Define", View_ChannelControl.ATTRIBUTE_DEFINE);

    brightnessAttributeInput = new GUI_TextfieldAttribute(ctrl, "brightnessAttributeInput", 225, 54);
    brightnessAttributeInput.setGroup(this);

    saturationAttributeSelector = new GUI_DropdownAttributeSelector(ctrl, "saturationAttributeSelector", 20, 50);
    saturationAttributeSelector.setGroup(this);
    saturationAttributeSelector.addItem("Define", View_ChannelControl.ATTRIBUTE_DEFINE);

    saturationAttributeInput = new GUI_TextfieldAttribute(ctrl, "saturationAttributeInput", 225, 34);
    saturationAttributeInput.setGroup(this);

    hueAttributeSelector = new GUI_DropdownAttributeSelector(ctrl, "hueAttributeSelector", 20, 30);
    hueAttributeSelector.setGroup(this);
    hueAttributeSelector.addItem("Define", View_ChannelControl.ATTRIBUTE_DEFINE);

    hueAttributeInput = new GUI_TextfieldAttribute(ctrl, "hueAttributeInput", 225, 14);
    hueAttributeInput.setGroup(this);
  }

}
