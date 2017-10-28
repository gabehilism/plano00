
import controlP5.*;

ControlP5 cp5;
Slider feed;
Slider kill;

int N,M;
float[][] A;
float[][] B;
float[][] A2;
float[][] B2;

float DA,DB,f,k,dt;

float t1 = 0;
float t2 = 0;
boolean cycle = true;

int current = 0;

void setup()
{	
	size(displayWidth,displayHeight);
	//size(500,500);

	N = 150;
	M = int(width*N/height);

	DA = 1;
	DB = 0.5;
	dt = 1;

	Clear();
	initGUI();
	Coral_Growth();
}

void draw()
{
	feed.setValue(f);
	kill.setValue(k);

	loadPixels();
	for(int i = 0; i < height; i+=1)
	for(int j = 0; j < width; j+=1)
	{
		int x,y;
		x = N*i/height;
		y = M*j/width;

		pixels[i*width+j] = color(255*(1-A[x][y])+255*(B[x][y]));
	}
	updatePixels();

	update(8);

	t1 += TWO_PI/500;
	if( t1 > TWO_PI )
	{
		t1 -= TWO_PI;

		if(cycle)
		{
			switch ((current = (current+1)%10))
			{
				case 0:
					Coral_Growth();
					break;
				case 1:
					Mitosis();
					break;
				case 2:
					Solitions();
					break;
				case 3:
					Pulsating_Solutions();
					break;
				case 4:
					Worms();
					break;
				case 5:
					Mazes();
					break;
				case 6:
					Holes();
					break;
				case 7:
					Moving_Spots();
					break;
				case 8:
					Waves();
					break;
				case 9:
					U_Skate();
					break;
			}
			clear();
		}
	}

	t2 += TWO_PI/40;
	if( t2 > TWO_PI )
	{
		t2 -= TWO_PI;

		for(int p = 0; p < 1; p++)
		{
			int x,y;
			x = (int)random(0,N);
			y = (int)random(0,M);
			
			for(int i = -2; i <= 2; i++)
				for(int j = -2; j <= 2; j++)
					B[(x+i+N)%N][(y+j+M)%M] = 1;
		}
	}
}

void update(int iterations)
{
	for(int it = 0; it < iterations; it++)
	{
		for(int i = 0; i < N; i+=1)
		for(int j = 0; j < M; j+=1)
		{
			float dA = 0;
			float dB = 0;

			for(int x = -1; x <= 1; x++)
			for(int y = -1; y <= 1; y++)
			{
				switch(abs(x)+abs(y))
				{
					case 0:
						dA += -1*A[(i+x+N)%N][(j+y+M)%M];
						dB += -1*B[(i+x+N)%N][(j+y+M)%M];
						break;
					case 1:
						dA += 0.2*A[(i+x+N)%N][(j+y+M)%M];
						dB += 0.2*B[(i+x+N)%N][(j+y+M)%M];
						break;
					case 2:
						dA += 0.05*A[(i+x+N)%N][(j+y+M)%M];
						dB += 0.05*B[(i+x+N)%N][(j+y+M)%M];
						break;
					default:
						println("error");
						break;
				}
			}

			A2[i][j] = A[i][j] + (DA*dA - A[i][j]*B[i][j]*B[i][j] + f*(1-A[i][j]))*dt;
			B2[i][j] = B[i][j] + (DB*dB + A[i][j]*B[i][j]*B[i][j] - (k+f)*B[i][j])*dt;
		}

		for(int i = 0; i < N; i++)
		for(int j = 0; j < M; j++)
		{
			A[i][j] = A2[i][j];
			B[i][j] = B2[i][j];
		}
	}
}

void mouseDragged()
{
	int y = int(M*mouseX/width);
	int x = int(N*mouseY/height);

	for(int i = 0; i <= 0; i++)
	for(int j = 0; j <= 0; j++)
	{
		if(x+i >= 0 && x+i < N && y+j >= 0 && y+j < M)
		{
			if(mouseButton == RIGHT)
			{
				A[x+i][y+j] += 0.1;
				if(A[x+i][y+j] > 1) A[x+i][y+j] -= 1;
			}
			else
			{
				B[x+i][y+j] += 0.5;
				if(B[x+i][y+j] > 1) B[x+i][y+j] -= 1;
			}
		}
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

  cp5.addButton("Clear")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Cycle")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  feed = cp5.addSlider("Feed_Rate")
  .setValue(0.055)
  .setRange(0,0.1)
  .setPosition(0,21*i)
  .setSize(150,20);
  i++;

  kill = cp5.addSlider("Kill_Rate")
  .setValue(0.062)
  .setRange(0,0.1)
  .setPosition(0,21*i)
  .setSize(150,20);
  i++;

  cp5.addButton("Coral_Growth")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Mitosis")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Solitions")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Pulsating_Solutions")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Worms")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Mazes")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Holes")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Moving_Spots")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("Waves")
  .setPosition(0,21*i)
  .setSize(120,20);
  i++;

  cp5.addButton("U_Skate")
  .setPosition(0,21*i)
  .setSize(120,20);
}

void Clear()
{
	A = new float[N][M];
	B = new float[N][M];
	A2 = new float[N][M];
	B2 = new float[N][M];
	for(int i = 0; i < N; i++)
	for(int j = 0; j < M; j++)
	{
		A[i][j] = 1;
		B[i][j] = abs(i-N/2) + abs(j-M/2) < 20 ? 1 : 0;
	}


	for(int p = 0; p < 1; p++)
	{
		int x,y;
		x = (int)random(0,N);
		y = (int)random(0,M);
		
		for(int i = -2; i <= 2; i++)
			for(int j = -2; j <= 2; j++)
				B[(x+i+N)%N][(y+j+M)%M] = 1;
	}
}

void Cycle()
{

	cycle = !cycle;
}

void Feed_Rate(float x)
{

	f = x;
}

void Kill_Rate(float x)
{

	k = x;
}

void Coral_Growth()
{
	f=.0545;
	k=.062;
}

void Mitosis()
{
	f=.0367;
	k=.0649;
}

void Solitions()
{
	f = 0.03;
	k = 0.062;
}

void Pulsating_Solutions()
{
	f = 0.025;
	k = 0.06;
}

void Worms()
{
	f = 0.078;
	k = 0.061;
}

void Mazes()
{
	f = 0.029;
	k = 0.057;
}

void Holes()
{
	f = 0.039;
	k = 0.058;
}

void Moving_Spots()
{
	f = 0.014;
	k = 0.054;
}

void Waves()
{
	f = 0.014;
	k = 0.045;
}

void U_Skate()
{
	f = 0.062;
	k = 0.061;
}