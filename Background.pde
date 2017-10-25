

class Background extends ILayer {
  PImage bg;
  
   Background() {
    bg = loadImage("00.jpg");
  }
  
   void draw() {
    image(bg, 0, 0, (bg.width / height) * width, height);
  }
}

class ChromaticAberrationFilter extends ILayer  {
  PShader s;
  
  int blurSz;
  
  IEquation eq;
  
   ChromaticAberrationFilter(int maxBlurSize) {
    blurSz = maxBlurSize;  
    setup();
  }
  
   ChromaticAberrationFilter(IEquation _eq, int maxBlurSize) {
    eq = _eq; 
    blurSz = maxBlurSize;
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
}