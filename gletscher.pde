import java.util.*;

int canvasW = 7680;
int canvasH = 1080;
PGraphics canvas;

PFont fontRegular;
PFont fontBold;

ArrayList<Gletscher> dataGlacierLength;
ArrayList<Temperatur> dataTemperatur;
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

void setup() {
  canvas = createGraphics(canvasW, canvasH, P3D);
  fontRegular = createFont("fonts/Dosis-Medium.ttf", 22);
  fontBold = createFont("fonts/Dosis-ExtraBold.ttf", 22);

  dataGlacierLength =  loadGlacierData("glacier_data.csv");
  dataTemperatur =  loadTemperaturData("temp.csv");

  HashSet<String> glacierNames = new HashSet<String>(); 
  for (Gletscher g : dataGlacierLength) {
    glacierNames.add(g.name);
  }

  Map<String, Float> boxHeights = new HashMap<String, Float>();

  for (String name : glacierNames) {
    float h = height-marginBottom;
    Float fh = new Float(h);
    boxHeights.put(name, fh);
  }


  // Startwert der Höhe der Temperaturlinie
  y = map(dataTemperatur.get(0).temp, 0, 11, height/2, 0);
  println("y " + y);

  frameRate(30);

  ready = true;
}

void draw() {
  canvas.beginDraw();
  canvas.background(0, 0, 255);
  canvas.fill(255, 0, 0);
  canvas.ellipse(550, 500, 100, 100);
  canvas.endDraw();
  image(canvas, 0, 0, width, height);
}


class Gletscher {

  String name;
  int size;
  int year;
  int absoluteLength;
  int breitengrad;
  int laengengrad;

  Gletscher(String name, int size, int year, int absoluteLength, int breitengrad, int laengengrad) {
    this.name = name;
    this.size = size;
    this.year = year;
    this.absoluteLength = absoluteLength;
    this.breitengrad = breitengrad;
    this.laengengrad = laengengrad;
  }

  String toString() {
    return this.name + ", " + this.year + ", " + this.size;
  }
}


class Temperatur {

  int year; 
  float temp;

  Temperatur(int year, float temp) {
    this.year = year;
    this.temp = temp;
  }

  String toString() {
    return this.year + ", " + this.temp;
  }
}
