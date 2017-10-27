
int N;
int[] tape;
int[] rules;

int code = 0;

void setup()
{
	size(800,800);

	N = 96;
	tape = new int[N];
	rules = new int[int(pow(2,3))];
	new_tape();
	new_rule(code);

	frameRate(2);

	//noLoop();
}

void draw()
{
	if(code >= 255)
	{
		exit();
	}

	new_tape();
	new_rule(code);

	background(255);
	translate(width/2,height/2);
	noStroke();

	int M = 40;
	for(int i = 0; i < M-2; i++)
	{
		float r0 = 0.4*height*float(M-i)/M;
		float r1 = 0.4*height*float(M-i-1)/M;
		for(int j = 0; j < N; j++)
		{
			float a0 = TWO_PI*(j-1+0.5)/N;
			float a1 = TWO_PI*(j+0.5)/N;

			stroke 	(255*(1-tape[j]));
			strokeWeight(2);
			fill 	(255*(1-tape[j]));
			beginShape();
			vertex(r0*cos(a0),r0*sin(a0));
			vertex(r0*cos(a1),r0*sin(a1));
			vertex(r1*cos(a1),r1*sin(a1));
			vertex(r1*cos(a0),r1*sin(a0));
			endShape();
			strokeWeight(1);
		}

		update_tape();
	}

	for(int i = 0; i < 8; i++)
	{
		pushMatrix();
		rotate(TWO_PI*i/8);
				rectMode(CENTER);
				stroke(0);
				fill(255*(1-i/4));
				rect(0.45*height,-20,20,20,5);
				fill(255*(1-(i%4)/2));
				rect(0.45*height,0,20,20,5);
				fill(255*(1-i%2));
				rect(0.45*height,20,20,20,5);
				fill(255*(1-rules[i]));
				rect(0.45*height-20,0,20,20,5);
		popMatrix();
	}

	fill(0);
	textAlign(CENTER,CENTER);
	textSize(25);
	text(code,0,-5);

	//saveFrame(String.format("prints/rule-%d.png",code));
	code++;
}

void update_tape()
{
	int[] new_tape = new int[N];

	for(int i = 0; i < N; i++)
	{
		new_tape[i] = rules[4*(tape[(i-1+N)%N]) + 2*(tape[i]) + 1*(tape[(i+1)%N])];
	}

	tape = new_tape;
}

void new_tape()
{
	for(int i = 0; i < N; i++)
	{
		tape[i] = i%(N/8)==0 ? 1 : 0;
	}
}

void new_rule(int code)
{
	for(int i = 0; i < rules.length; i++)
	{
		rules[i] = code%2;
		code /= 2;
	}
}

void mousePressed()
{
	new_tape();
	new_rule(code++);
	redraw();
}