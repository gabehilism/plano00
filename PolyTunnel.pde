
class PolyTunnel extends ILayer  {
  Poly[] polys;
  
  int n_polys;
  int slices;
  IEquation radius_eq;
  IEquation angle_eq;
  
  void randomize() {
    radius_eq  = G_GET_RANDOM_EQ();
    angle_eq = G_GET_RANDOM_EQ();
    n_polys = (int)random(10, 50);
    slices = (int)random(3, 20);
    
    polys = new Poly[n_polys];
    for (int i = 0; i < n_polys; i++) {
      float offset = (float(i)/n_polys);
      print(offset + " ");
      Poly p = new Poly(slices, (float(i)/n_polys));
      polys[i] = p;
    }
  }
  
  void updt() {
    for (int i = 0; i < polys.length; i++) {
        Poly p = polys[i];
        p.updt(radius_eq, angle_eq);
    }
  }
  
   void draw() {
    updt();
    
    pushMatrix();
    translate(width/2, height/2);
   
    for (int i = 0; i < n_polys; i++) {
      polys[i].draw();
    }
    
    draw_corners();
 
    
    popMatrix();
  }
  
  void draw_corners() {
    for (int h = 0; h < slices; h++) {
      for (int i = 0; i < n_polys-1; i++) {
          Poly p1 = polys[i];
          Poly p2 = polys[i+1];
          PVector p = p1.points[h];
          p = p.rotate(degrees(p1.a));
          vertex(p.x * p1.r, p.y * p1.r );
      }
      
    }
  }
  
  void create_debug_menu(ControlP5 cp5) {
      G_CREATE_EQUATION_DROPDOWN(cp5, this, "angle_eq", 100, 100).moveTo(get_tab_name());
      G_CREATE_EQUATION_DROPDOWN(cp5, this, "radius_eq", 310, 100).moveTo(get_tab_name());
  }
  
  void angle_eq(int n) {
    angle_eq = G_EQUATIONS[n];
  }
  
  void radius_eq(int n) {
    radius_eq = G_EQUATIONS[n];
  } 
}