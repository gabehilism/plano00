

interface IEquation {
   float F(float x);
}

class EqEmpty implements IEquation {
  float F(float x) {
    return 0f;
  }
}

class Eq00 implements IEquation {
   float F(float x) {
    return x;
  }
}

 class Eq01 implements IEquation {
   float F(float x) {
    return sqrt(x);
  }
}

 class Eq02 implements IEquation {
   float F(float x) {
    return cos(x * TAU);
  }
 }
  
class Eq03 implements IEquation {
  float F(float x) {
    return sin(x * TAU * 5);
  }
}