
import controlP5.*;

PGraphics mini_canvas;

ControlP5 cp5;

int N,M,IT,S;
int[] tape;
int[] rules;

int code;

float t 			= 0;
float t2 			= 0;
boolean descending 	;
int blur_level 		;
int posterize_level ;
boolean hsb 		;

void setup()
{
	size(displayWidth,displayHeight);

	mini_canvas = createGraphics(500,500);

	tape = new int[N];
	rules = new int[int(pow(S,3))];
	random_rule();
	clear();

	background(255);

	initGUI();
}

void draw()
{
	background(0);

	for(int i = 0; i < 1; i++)
	{
		t++;
		draw_flower();
	}

	if(t >= M)
	{
		t = 0;
		random_rule();
		descending = !descending;
		clear();
	}

	if(blur_level > 0 && random(0,1) < 1.0/IT)
		mini_canvas.filter(BLUR,blur_level);
	
	mini_canvas.filter(POSTERIZE,posterize_level);
	image(mini_canvas,(width-mini_canvas.width)/2,(height-mini_canvas.height)/2);

}

void draw_flower()
{
	mini_canvas.beginDraw();

	mini_canvas.pushMatrix();
	mini_canvas.translate(mini_canvas.width/2,mini_canvas.height/2);
	int i = int(t);
	//for(int i = 0; i < t; i++)
	//for(int i = 0; i < M; i++)
	{
		float r0,r1;

		if(descending)
		{
			r0 = 0.4*mini_canvas.height*float(M-i)/M;
			r1 = 0.4*mini_canvas.height*float(M-i-1)/M;
		}
		else
		{
			r0 = 0.4*mini_canvas.height*float(i)/M;
			r1 = 0.4*mini_canvas.height*float(i+1)/M;
		}
		
		for(int j = 0; j < N; j++)
		{
			float a0 = TWO_PI*(j-1+0.5)/N;
			float a1 = TWO_PI*(j+0.5)/N;

			if(hsb)
			{
				mini_canvas.stroke 	( 255*(S-1-tape[j])/(S), 200, 200);
				mini_canvas.fill 	( 255*(S-1-tape[j])/(S), 200, 200);
			}
			else
			{
				mini_canvas.stroke 	( 255*(S-1-tape[j])/(S-1));
				mini_canvas.fill 	( 255*(S-1-tape[j])/(S-1));
			}
			
			strokeWeight(2);
			
			mini_canvas.beginShape();
				mini_canvas.vertex(r0*cos(a0),r0*sin(a0));
				mini_canvas.vertex(r0*cos(a1),r0*sin(a1));
				mini_canvas.vertex(r1*cos(a1),r1*sin(a1));
				mini_canvas.vertex(r1*cos(a0),r1*sin(a0));
			mini_canvas.endShape();
		}

		update_tape();
	}
	mini_canvas.popMatrix();
	mini_canvas.endDraw();
}

void clear()
{
	for(int i = 0; i < N; i++)
	{
		tape[(i+int(0.5*t))%N] = i%(N/8)==0 ? 1 : 0;
	}
}

void update_tape()
{
	int[] new_tape = new int[N];
	for(int i = 0; i < N; i++)
		new_tape[i] = rules[S*S*(tape[(i-1+N)%N]) + S*(tape[i]) + 1*(tape[(i+1)%N])];
	tape = new_tape;
}

int encode()
{
	int code = 0;
	for(int i = 0; i < rules.length; i++)
	{
		code += 2*code + rules[rules.length-i-1];
	}
	return code;
}

void decode(int code)
{
	for(int i = 0; i < rules.length; i++)
	{
		rules[i] = code%S;
		code /= S;
	}
}

void random_rule()
{
	for(int i = 0; i < rules.length; i++)
	{
		rules[i] = int(random(0,S));
	}
}

void keyPressed()
{
	if(cp5.isVisible())
	{
		cp5.hide();
	}
	else
	{
		cp5.show();
	}
}

void initGUI()
{
	cp5 = new ControlP5(this);
	cp5.hide();

	int i = 0;

	cp5.addSlider("Size")
  	.setValue(15)
  	.setRange(1,20)
  	.setPosition(0,21*(i++))
  	.setSize(120,20);

  	cp5.addSlider("Iterations")
  	.setValue(30)
  	.setRange(1,100)
  	.setPosition(0,21*(i++))
  	.setSize(120,20);

  	cp5.addSlider("Udate_Speed")
  	.setValue(1)
  	.setRange(1,10)
  	.setPosition(0,21*(i++))
  	.setSize(120,20);

  	cp5.addSlider("Symbols")
  	.setValue(10)
  	.setRange(2,10)
  	.setPosition(0,21*(i++))
  	.setSize(120,20);

	cp5.addSlider("Blur_Level")
  	.setValue(2)
  	.setRange(0,5)
  	.setPosition(0,21*(i++))
  	.setSize(120,20);

  	cp5.addSlider("Posterize_Level")
  	.setValue(3)
  	.setRange(2,5)
  	.setPosition(0,21*(i++))
  	.setSize(120,20);

  	cp5.addButton("HSB")
  	.setPosition(0,21*(i++))
  	.setSize(120,20);
}

void Size(int x)
{
	N = 8*x;
	tape = new int[N];
	clear();
}

void Iterations(int x)
{

	M = x;
}

void Udate_Speed(int x)
{
	IT = x;
}

void Symbols(int x)
{
	S = x;
	rules = new int[int(pow(S,3))];
	random_rule();
	clear();
}

void Blur_Level(int x)
{

	blur_level = x;
}

void Posterize_Level(int x)
{

	posterize_level = x;
}

void HSB()
{
	hsb = !hsb;
	if(hsb) mini_canvas.colorMode(HSB);
	else 	mini_canvas.colorMode(RGB);
}