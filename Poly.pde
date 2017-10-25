

class Poly extends ILayer implements IRandomizable {
  int slices;
  PVector[] points;
  
  float r;
  float max_r = height * 2f;
  float a;
  int offset;
  
  int life_left;
  int life_total;
  
   Poly(int _slices, int _offset) {
    points = new PVector[MAX_VERTS];
    offset = _offset;
    //r = t2radius(t_ms2t(offset));
    //a = t2angle(t_ms2t(offset));
    a = radians(90f);
    set_slices(_slices);
    
    life_total = T_MS_FULL_CYCLE;
    life_left = T_MS_FULL_CYCLE - offset;
  }
  
  void set_slices(int n) {
    slices = n;
    float increment = radians(360f / slices);
    for (int i = 0; i < n; i++) {
      float a = increment * i;
      points[i] = new PVector(cos(a), sin(a));
    }
  }

  // angle equations
  float get_angle(IEquation eq, float t) {
    return eq.F(t * TAU);
  }
  
  // radius equations
  float get_radius(IEquation eq, float t) {
    t = eq.F(t);
    if (t > 1.0f) {
      t = 0.0f;
    }
    return t * max_r;
  }
  
  void updt(int ms, IEquation radius_eq, IEquation angle_eq) {
    float t = t_ms2t(ms + offset);
    r = get_radius(radius_eq, t);
    a = get_angle(angle_eq, t);
  }
  
 void updt(float t, IEquation radius_eq, IEquation angle_eq) {
    r = get_radius(radius_eq, t);
    a = get_angle(angle_eq, t);
  }
  
 void draw() {
   //poly_draw();
   point_draw();
  }
  
  void poly_draw() {
    noFill();
    stroke(255);
    strokeWeight(height * 0.001f);
    
    pushMatrix();
    
    rotateZ(a);
    
    beginShape();
    for (int i = 0; i <= slices - 1; i++) {
      PVector p1 = points[i];
      vertex(p1.x * r, p1.y * r);
    }
    endShape(CLOSE);
    popMatrix();
  }
  
  void point_draw() {
    stroke(255);
    strokeWeight(height * 0.01f);
    
    pushMatrix();
    
    rotateZ(a);
    
    for (int i = 0; i <= slices - 1; i++) {
      PVector p1 = points[i];
      point(p1.x * r, p1.y * r);
    }
    
    popMatrix();
  }
  
  void rng() {
    
  }
  
  IRandomizable[] get_rng_children() {
    return new IRandomizable[] {};
  }
  
  // void draw(float _a) {
  //  stroke(255);
  //  strokeWeight(height * 0.001f);
    
  //  pushMatrix();
  //  rotateZ(_a);
    
  //  for (int i = 0; i < slices - 1; i++) {
  //    PVector p1 = points[i];
  //    PVector p2 = points[i+1];
  //    line(p1.x, p1.y, p2.x, p2.y); 
  //  }
    
  //  PVector p1 = points[0];
  //  PVector p2 = points[slices-1];
    
  //  line(p1.x, p1.y, p2.x, p2.y);
    
  //  popMatrix();
  //}
  
}