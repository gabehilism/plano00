

class Controls {
  int mode;
  int last_mode;
  int page;
  
  PolyTunnel[] tunnels;
  
   Controls(PolyTunnel[] t) {
    tunnels = t;
    mode = MODE_CHOOSING_RADIUS_EQ;
    page = 0;
  }
  
   void updt() {
    for (int i = 0; i < tunnels.length; i++) {
      tunnels[i].draw();
    }
  }
  
   void keyPressed() {
    if (key >= 48 && key <= 57) {
      updt_tunnel(mode, page, Character.getNumericValue(key));
      return;
    }
    
    if (key == 'r') {
      mode = MODE_CHOOSING_RADIUS_EQ;
    }
    else if (key == 'a') {
      mode = MODE_CHOOSING_ANGLE_EQ;
    }
    else if (key == 't') {
      mode = MODE_CHOOSING_TIME_DIV;
    }
    
    // todo: pages
    

  }
  
  void updt_tunnel(int mode, int p, int n) {
    int index = (p*9)+n;
    print(mode + " " + page + " " + n + " " + index);
    
    if (mode == MODE_CHOOSING_TIME_DIV) {
      T_MS_DIV = (int)pow(2, n);
      return;
    }
    
    if (index < 0 || index > eqs.length) {
      return;
    }
    
    IEquation eq = eqs[index-1];
    if (mode == MODE_CHOOSING_RADIUS_EQ) {
      updt_radius(eq);
    }
    else if (mode == MODE_CHOOSING_ANGLE_EQ) {
      updt_angle(eq);
    }
    
  }
  
  void updt_radius(IEquation eq) {
    for (int i = 0; i < tunnels.length; i++) {
      tunnels[i].radius_eq = eq;
    }
  }
  
  void updt_angle(IEquation eq) {
    for (int i = 0; i < tunnels.length; i++) {
      tunnels[i].angle_eq = eq;
    }
  }
  
  IEquation[] eqs = {
    new EqEmpty(),
    new Eq00(),
    new Eq01(),
    new Eq02(),
    new Eq03()
  };
}

int MODE_TYPING = 47;
int MODE_SELECTING_POS = 48;
int MODE_SELECTING_RANGE = 49;
int MODE_CHOOSING_RADIUS_EQ = 50;
int MODE_CHOOSING_ANGLE_EQ = 51;
int MODE_CHOOSING_TIME_DIV = 52;