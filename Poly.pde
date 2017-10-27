class Poly {
  int slices;
  PVector[] points;
  
  float r;
  float max_r = height * 2f;
  float a;
  
  float life;
  
   Poly(int _slices, float _offset) {
    points = new PVector[_slices];
    life = _offset;
    //r = t2radius(t_ms2t(offset));
    //a = t2angle(t_ms2t(offset));
    //a = radians(90f);
    set_slices(_slices);
  }
  
  void set_slices(int n) {
    slices = n;
    float increment = radians(360f / slices);
    for (int i = 0; i < n; i++) {
      float a = increment * i;
      points[i] = new PVector(cos(a), sin(a));
    }
  }
  
  void updt(IEquation radius_eq, IEquation angle_eq) {

    float t = life;
    r = radius_eq.F(t % 2f) * max_r;
    a = angle_eq.F(t);
    
    if (r >= max_r) {
      life = 0;
    }
    else {
      life += DT;
    }
  }
  
  void draw() {
   poly_draw();
   //point_draw();
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
  
  void line_draw() {
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
}