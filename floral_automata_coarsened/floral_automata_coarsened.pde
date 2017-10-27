
int N,M,S;
int[] tape;
int[] rules;

int code;

float t = 0;
int t2 = 0;
boolean descending = true;

void setup()
{
	size(displayWidth,displayHeight);

	N = 8*12;
	M = 20;
	S = 3;
	tape = new int[N];
	rules = new int[int(pow(S,3))];
	random_rule();
	clear();

	background(255);
}

void draw()
{
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

	filter(BLUR,2);
	filter(POSTERIZE,3);
}

void draw_flower()
{
	pushMatrix();
	translate(width/2,height/2);
	int i = int(t);
	//for(int i = 0; i < t; i++)
	//for(int i = 0; i < M; i++)
	{
		float r0,r1;

		if(descending)
		{
			r0 = 0.4*height*float(M-i)/M;
			r1 = 0.4*height*float(M-i-1)/M;
		}
		else
		{
			r0 = 0.4*height*float(i)/M;
			r1 = 0.4*height*float(i+1)/M;
		}
		
		for(int j = 0; j < N; j++)
		{
			float a0 = TWO_PI*(j-1+0.5)/N;
			float a1 = TWO_PI*(j+0.5)/N;

			stroke 	( 255*(S-1-tape[j])/(S-1), 255);
			fill 	( 255*(S-1-tape[j])/(S-1), 255);
			strokeWeight(2);
			
			beginShape();
				vertex(r0*cos(a0),r0*sin(a0));
				vertex(r0*cos(a1),r0*sin(a1));
				vertex(r1*cos(a1),r1*sin(a1));
				vertex(r1*cos(a0),r1*sin(a0));
			endShape();
		}

		update_tape();
	}
	popMatrix();
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
	{
		new_tape[i] = rules[S*S*(tape[(i-1+N)%N]) + S*(tape[i]) + 1*(tape[(i+1)%N])];
	}

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

	//rules[int(random(0,rules.length))] = 0;
	//rules[int(random(0,rules.length))] = 1;
}