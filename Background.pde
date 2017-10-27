
class SlideshowBackground extends ILayer {
  PImage[] bgs;
  int curr_bg = 0;
  int n_beats = 100;
  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      print("error");
      return null;
    }
  }
  
  void draw() {
    PImage bg = bgs[curr_bg];
    imageMode(CENTER);
    
    float f = float(width)/bg.width;
    image(bg, 0, 0, width, height);
  }
  
  void randomize() {
    if (bgs == null) {
      String[] files = listFileNames(sketchPath() + "\\data\\slides\\");
      bgs = new PImage[files.length];
      for (int i = 0; i < files.length; i++) {
        bgs[i] = loadImage("slides\\" + files[i]);
      }
    }
    curr_bg = int(random(0, bgs.length));
  }
}

class ChromaticAberrationFilter extends ILayer  {
  PShader s;
  
  int blurSz;
  
   ChromaticAberrationFilter() {
    setup();
  }
  
  void setup() {
    s = loadShader("chromaticaberration.glsl");
  }
  
   void draw() {    
    //float t = eq != null ? eq.F(T_CYCLE) : T_CYCLE;
    float t = T_HAT;
    
    s.set("blurSize", int(max(1.0f, t * blurSz)));
    filter(s);
  }
  
  void create_debug_menu(ControlP5 cp5) {
    cp5.addSlider("blur_sz").setRange(0.0,100.0).moveTo(get_tab_name()).plugTo(this);
  }
  
  void blur_sz(float f) {
    blurSz = (int)f;
  }
  
  void randomize() {
    blurSz = (int)random(1f, 5f);
  }
}