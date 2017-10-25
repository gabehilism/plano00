
class PolyTunnel extends ILayer  {
  Poly[] polys;
  
  int slices;
  IEquation radius_eq;
  IEquation angle_eq;
  
   PolyTunnel(int _n_polys,
              int _n_slices,
              IEquation _angle_eq,
              IEquation _radius_eq) {
    radius_eq = _radius_eq;
    angle_eq = _angle_eq;
    slices = _n_slices;
    
    polys = new Poly[_n_polys];
    for (int i = 0; i < _n_polys; i++) {
      float t = float(i) / _n_polys;
      int ms = t_t2ms(1f - t);
      Poly p = new Poly(_n_slices, ms);
      polys[i] = p;
    }
  }
  
  void updt() {
    int ms = t_ms();
    for (int i = 0; i < polys.length; i++) {
        Poly p = polys[i];
        p.updt(ms, radius_eq, angle_eq);
    }
  }
  
   void draw() {
    updt();
    
    pushMatrix();
    translate(width/2, height/2);
   
    for (int i = 0; i < N_POLIS; i++) {
      polys[i].draw();
    }
    
    //draw_corners();
 
    
    popMatrix();
  }
  
  void draw_corners() {
    for (int h = 0; h < slices; h++) {
  
      float total_a = 0;
      
      beginShape();
        for (int i = 0; i < N_POLIS; i++) {
          Poly poly = polys[i];
          PVector p = poly.points[h];
          p = p.rotate(degrees(poly.a));
          vertex(p.x * poly.r, p.y * poly.r );
        }
      endShape();
    }
  }
}