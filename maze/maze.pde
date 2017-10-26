
import gifAnimation.*;

class Point
{
  float x,y;
  
  Point(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
}

class Edge
{
  int in;
  int out;
  float weight;
  
  Edge(int in, int out, float weight)
  {
    this.in = in;
    this.out = out;
    this.weight = weight;
  }
  
  Edge clone()
  {
    return new Edge(in,out,weight);
  }
}

class Graph
{
  int n;
  ArrayList<Edge>[] neighbors;
  
  Graph(int _n)
  {
    n = _n;
    
    neighbors = (ArrayList<Edge>[]) new ArrayList[n];
    for(int i = 0; i < n; i++)
    {
      neighbors[i] = new ArrayList<Edge>();
    }
  }
  
  boolean edgeExists(int i, int j)
  {
    for(Edge e : neighbors[i])
    {
      if(e.out == j) return true;
    }
    
    return false;
  }
}

Point[] drawing_position;

ArrayList<Edge> edges_in_insertion_order;

Graph G,T;

GifMaker gif;

int millis_offset;

void setup()
{
  size(600,600);
  background(255);
  
  int N = 900;
  
  drawing_position = new Point[N];
  int s = (int)sqrt(N);
  for(int i = 0; i < N; i++)
  {
    float x,y;
    x = (width/s)*(i/s);
    y = (height/s)*(i%s);
    
    drawing_position[i] = new Point(x,y);

  }
  
  G = createGraph(N,1);
  
  T = prim(G);
  
  /*
  frameRate(24);
  gif = new GifMaker(this, "a.gif");
  gif.setRepeat(0); // make it an "endless" animation
  gif.setDelay(1000/24);  //12fps in ms
  */
  
  millis_offset = millis();
}

void draw()
{
  int s = (int)sqrt(G.n);
  translate(width/(2*s),height/(2*s));
  
  int t = (millis()-millis_offset)/5;
  
  for(int k = 0; k < min(t,edges_in_insertion_order.size()); k++)
  {
    Edge ij = edges_in_insertion_order.get(k);
    int i,j;
    i = ij.in;
    j = ij.out;
    
    Point p1 = drawing_position[i];
    Point p2 = drawing_position[j];
    
    line(p1.x,p1.y, p2.x,p2.y);
  }
  
  //gif.addFrame();
}

float dist(Point p1, Point p2)
{
  return sqrt(sq(p1.x-p2.x)+sq(p1.y-p2.y));
}

void randomizeArray(int[] array)
{
  for(int i = 0; i < array.length; i++)
  {
    int j = (int)random(0,array.length);
    
    int aux = array[i];
    array[i] = array[j];
    array[j] = aux;
  }
}

Graph createGraph(int n, float r)
{
  Graph G = new Graph(n);
  
  int[] a1 = new int[n];
  int[] a2 = new int[n];
  
  for(int i = 0; i < n; i++)
  {
    a1[i] = a2[i] = i;
  }
  
  randomizeArray(a1);
  randomizeArray(a2);
  
  for(int I = 0; I < n; I++)
  for(int J = 0; J < n; J++)
  {
    int i,j;
    i = a1[I];
    j = a2[J];
    
    if(i == j) continue;
    
    Point p1 = drawing_position[i];
    Point p2 = drawing_position[j];
    
    int s = (int)sqrt(G.n);
    float d = width/s;
    
    if( /*(abs(p1.x-p2.x) == 0 && abs(p1.y-p2.y) == 0) &&*/ (dist(p1,p2) <= 1*d) && (random(0,1) <= r) )
    {
      float w = random(0.1,1);
      G.neighbors[i].add(new Edge(i,j,w));
    }
  }
  
  return G;
}

Graph prim(Graph G)
{
  /* T: minimum spanning tree */
  Graph T = new Graph(G.n);
  
  /**/
  edges_in_insertion_order = new ArrayList<Edge>();
  
  /* visited: boolean mask of visited nodes */
  boolean[] visited = new boolean[G.n];
  int visited_count = 0;
  for(int i = 0; i < G.n; i++) { visited[i] = false; }
  
  /* randomly choose an initial node 'start' */
  int start = (int)random(0,G.n);
  visited[start] = true;
  visited_count++;
  
  /* while not all nodes are visited */
  while(visited_count < G.n)
  {
    /* m: the minimum-weight edge ij connecting a visited node i with a non-visited node j */
    Edge m = null;
    
    /* for every non-visited node j connected by an edge with a visited node i */
    for(int i = 0; i < G.n; i++)  if(visited[i])
    for(Edge ij : G.neighbors[i]) if(!visited[ij.out])
    {
      if( (m == null) || (ij.weight < m.weight) )
      {
        m = ij;
      }
    }
    
    if(m == null) break;
    
    visited[m.out] = true;
    T.neighbors[m.in].add(m.clone());
    
    edges_in_insertion_order.add(m.clone());
  }
  
  return T;
}