
IEquation[] G_EQUATIONS = {
    new EqEmpty(),
    new EqBeat(),
    new Eq00(),
    new Eq01()
};

ScrollableList G_CREATE_EQUATION_DROPDOWN(ControlP5 cp5, Object p, String n, int x, int y) {
     String[] n_eqs = new String[G_EQUATIONS.length];
     for (int i = 0; i < G_EQUATIONS.length; i++) {
       n_eqs[i] = G_EQUATIONS[i].get_expression(); 
     }
     
     return cp5.addScrollableList(n)
      .setPosition(x, y)
      .setSize(200, 100)
      .setBarHeight(20)
      .setItemHeight(20)
      .addItems(n_eqs)
      .plugTo(p);
}

IEquation G_GET_RANDOM_EQ() {
  return G_EQUATIONS[(int)random(0, G_EQUATIONS.length)];
}

interface IEquation {
   float F(float x);
   String get_expression();
}

class EqEmpty implements IEquation {
  float F(float x) {
    return 0f;
  }
  
  String get_expression() {
    return "0f";
  }
}

class EqBeat implements IEquation {
  float F(float x) {
    return max(T_HAT, max(T_KICK, T_SNARE));
  }
  
  String get_expression() {
    return "beat";
  }
}

class Eq00 implements IEquation {
   float F(float x) {
    return x;
  }
  
  String get_expression() {
    return "x";
  }
}

 class Eq01 implements IEquation {
   float F(float x) {
    return sqrt(x);
  }
  
  String get_expression() {
    return "sqrt(x)";
  }
}