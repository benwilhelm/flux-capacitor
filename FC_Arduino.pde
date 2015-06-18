import cc.arduino.*;

static class FC_Arduino {
   private static Arduino instance = null;
   protected FC_Arduino() {
      // Exists only to defeat instantiation.
   }

   public static Arduino getInstance() {
      return instance;
   }

   public static Arduino initialize(PApplet p) {
      instance = new Arduino(p, Arduino.list()[1], 57600);
      return instance;
   }
}