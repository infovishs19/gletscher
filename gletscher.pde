int canvasW = 7680;
int canvasH = 1080;
PGraphics canvas;


float [] dataGlacierLength;
float [] dataTemperatur;
boolean ready = false;

float [] boxHeights;
float marginBottom = 55;
float boxWidth = 0;
int startYear = 1900;
int actualYear = startYear;
int a = 0;
int total = 0;
boolean one = true;
float y = 0;


// Processing Standard Functions
void settings() 
{
  size(1280, 180, P3D);
  PJOGL.profile=1;
}

void setup(){
 canvas = createGraphics(canvasW, canvasH, P3D);
}

void draw(){
canvas.beginDraw();
canvas.background(0,0,255);
canvas.fill(255,0,0);
canvas.ellipse(550,500,100,100);
canvas.endDraw();
image(canvas,0,0,width,height);
}
