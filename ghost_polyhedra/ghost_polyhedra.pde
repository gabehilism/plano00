
// Import gifAnimation to export the sketch as gifs
//import gifAnimation.*;
//GifMaker gif;

float L;
float t = 0;

void setup()
{
	size(displayWidth,displayHeight,P3D);
	colorMode(HSB,1,1,1);

	L = 0.75*height;

	// Initialize gif maker
	//gif = new GifMaker(this, "export.gif");
	//gif.setRepeat(0);   // make it an "endless" animation
	//gif.setQuality(20); // set a higher compression quality (the default is 10) to preserve the blocks' colors
	//gif.setDelay(20);
}

void draw()
{
	background(0.1);
	setOrtho();
	translate(0*width,1.2*height,0*height);
	rotateY(t/4);

	noFill();
	stroke(255);

	int N = 20;
	for(int i = 0; i < N; i++)
	{
		stroke(0.2*float(N-i)/N,1,1);
		pushMatrix();
			rotateX(1*cos(t)*float(N-i)/N);
			rotateY(1*sin(t)*float(N-i)/N);
			//Icosahedron ico1 = new Icosahedron(L*float(i)/N);
			//ico1.create();
			box(L*float(i)/N);
		popMatrix();
	}

	//gif.addFrame();

	// Check and increment time counter (the exported gif will contain 50 frames)
  	if(t >= 4*TWO_PI)
  	{
  	  //gif.finish();
  	  //exit();
  	}
  	else
  	{
  	  t += TWO_PI/100;
  	}
}

void setOrtho()
{
  float a = 1;
  ortho(-a*width,a*width,-a*height,a*height);
  rotateX(-PI/5);
  rotateY(PI/3);
}

class Dimension3D{
   float w, h, d;
   
   Dimension3D(float w, float h, float d){
     this.w=w;
     this.h=h;
     this.d=d;
  }
}




abstract class Shape3D{
  float x, y, z;
  float w, h, d;

  Shape3D(){
  }

  Shape3D(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Shape3D(PVector p){
    x = p.x;
    y = p.y;
    z = p.z;
  }


  Shape3D(Dimension3D dim){
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  Shape3D(float x, float y, float z, float w, float h, float d){
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.h = h;
    this.d = d;
  }

  Shape3D(float x, float y, float z, Dimension3D dim){
    this.x = x;
    this.y = y;
    this.z = z;
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  Shape3D(PVector p, Dimension3D dim){
    x = p.x;
    y = p.y;
    z = p.z;
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  void setLoc(PVector p){
    x=p.x;
    y=p.y;
    z=p.z;
  }

  void setLoc(float x, float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }


  // override if you need these
  void rotX(float theta){
  }

  void rotY(float theta){
  }

  void rotZ(float theta){
  }


  // must be implemented in subclasses
  abstract void init();
  abstract void create();
}




class Icosahedron extends Shape3D{

  // icosahedron
  PVector topPoint;
  PVector[] topPent = new PVector[5];
  PVector bottomPoint;
  PVector[] bottomPent = new PVector[5];
  float angle = 0, radius = 150;
  float triDist;
  float triHt;
  float a, b, c;

  // constructor
  Icosahedron(float radius){
    this.radius = radius;
    init();
  }

  Icosahedron(PVector v, float radius){
    super(v);
    this.radius = radius;
    init();
  }

  // calculate geometry
  void init(){
    c = dist(cos(0)*radius, sin(0)*radius, cos(radians(72))*radius,  sin(radians(72))*radius);
    b = radius;
    a = (float)(Math.sqrt(((c*c)-(b*b))));

    triHt = (float)(Math.sqrt((c*c)-((c/2)*(c/2))));

    for (int i=0; i<topPent.length; i++){
      topPent[i] = new PVector(cos(angle)*radius, sin(angle)*radius, triHt/2.0f);
      angle+=radians(72);
    }
    topPoint = new PVector(0, 0, triHt/2.0f+a);
    angle = 72.0f/2.0f;
    for (int i=0; i<topPent.length; i++){
      bottomPent[i] = new PVector(cos(angle)*radius, sin(angle)*radius, -triHt/2.0f);
      angle+=radians(72);
    }
    bottomPoint = new PVector(0, 0, -(triHt/2.0f+a));
  }

  // draws icosahedron 
  void create(){
    for (int i=0; i<topPent.length; i++){
      // icosahedron top
      beginShape();
      if (i<topPent.length-1){
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+topPoint.x, y+topPoint.y, z+topPoint.z);
        vertex(x+topPent[i+1].x, y+topPent[i+1].y, z+topPent[i+1].z);
      } 
      else {
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+topPoint.x, y+topPoint.y, z+topPoint.z);
        vertex(x+topPent[0].x, y+topPent[0].y, z+topPent[0].z);
      }
      endShape(CLOSE);

      // icosahedron bottom
      beginShape();
      if (i<bottomPent.length-1){
        vertex(x+bottomPent[i].x, y+bottomPent[i].y, z+bottomPent[i].z);
        vertex(x+bottomPoint.x, y+bottomPoint.y, z+bottomPoint.z);
        vertex(x+bottomPent[i+1].x, y+bottomPent[i+1].y, z+bottomPent[i+1].z);
      } 
      else {
        vertex(x+bottomPent[i].x, y+bottomPent[i].y, z+bottomPent[i].z);
        vertex(x+bottomPoint.x, y+bottomPoint.y, z+bottomPoint.z);
        vertex(x+bottomPent[0].x, y+bottomPent[0].y, z+bottomPent[0].z);
      }
      endShape(CLOSE);
    }

    // icosahedron body
    for (int i=0; i<topPent.length; i++){
      if (i<topPent.length-2){
        beginShape();
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+bottomPent[i+1].x, y+bottomPent[i+1].y, z+bottomPent[i+1].z);
        vertex(x+bottomPent[i+2].x, y+bottomPent[i+2].y, z+bottomPent[i+2].z);
        endShape(CLOSE);

        beginShape();
        vertex(x+bottomPent[i+2].x, y+bottomPent[i+2].y, z+bottomPent[i+2].z);
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+topPent[i+1].x, y+topPent[i+1].y, z+topPent[i+1].z);
        endShape(CLOSE);
      } 
      else if (i==topPent.length-2){
        beginShape();
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+bottomPent[i+1].x, y+bottomPent[i+1].y, z+bottomPent[i+1].z);
        vertex(x+bottomPent[0].x, y+bottomPent[0].y, z+bottomPent[0].z);
        endShape(CLOSE);

        beginShape();
        vertex(x+bottomPent[0].x, y+bottomPent[0].y, z+bottomPent[0].z);
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+topPent[i+1].x, y+topPent[i+1].y, z+topPent[i+1].z);
        endShape(CLOSE);
      }
      else if (i==topPent.length-1){
        beginShape();
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+bottomPent[0].x, y+bottomPent[0].y, z+bottomPent[0].z);
        vertex(x+bottomPent[1].x, y+bottomPent[1].y, z+bottomPent[1].z);
        endShape(CLOSE);

        beginShape();
        vertex(x+bottomPent[1].x, y+bottomPent[1].y, z+bottomPent[1].z);
        vertex(x+topPent[i].x, y+topPent[i].y, z+topPent[i].z);
        vertex(x+topPent[0].x, y+topPent[0].y, z+topPent[0].z);
        endShape(CLOSE);
      }
    }
  }

  // overrided methods fom Shape3D
  void rotZ(float theta){
    float tx=0, ty=0, tz=0;
    // top point
    tx = cos(theta)*topPoint.x+sin(theta)*topPoint.y;
    ty = sin(theta)*topPoint.x-cos(theta)*topPoint.y;
    topPoint.x = tx;
    topPoint.y = ty;

    // bottom point
    tx = cos(theta)*bottomPoint.x+sin(theta)*bottomPoint.y;
    ty = sin(theta)*bottomPoint.x-cos(theta)*bottomPoint.y;
    bottomPoint.x = tx;
    bottomPoint.y = ty;

    // top and bottom pentagons
    for (int i=0; i<topPent.length; i++){
      tx = cos(theta)*topPent[i].x+sin(theta)*topPent[i].y;
      ty = sin(theta)*topPent[i].x-cos(theta)*topPent[i].y;
      topPent[i].x = tx;
      topPent[i].y = ty;

      tx = cos(theta)*bottomPent[i].x+sin(theta)*bottomPent[i].y;
      ty = sin(theta)*bottomPent[i].x-cos(theta)*bottomPent[i].y;
      bottomPent[i].x = tx;
      bottomPent[i].y = ty;
    }
  }

  void rotX(float theta){
  }

  void rotY(float theta){
  }


}

