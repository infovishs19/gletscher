import java.util.*;

int canvasW = 7680;
int canvasH = 1080;
PGraphics canvas;

PFont fontRegular;
PFont fontBold;

ArrayList<Gletscher> dataGlacierLength;
ArrayList<Temperatur> dataTemperatur;
boolean ready = false;

Map<String, Float> boxHeights;
float marginBottom = 55;
float boxWidth = 0;
int startYear = 1900;
int actualYear = startYear;
int a = 0;
int total = 0;
boolean one = true;
float y = 0;

float timer;
// Processing Standard Functions
void settings() 
{
  //size(1280, 180, P3D);
  size(canvasW/4, canvasH/4, P3D);
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

  boxHeights = new HashMap<String, Float>();

  for (String name : glacierNames) {
    float h = height-marginBottom;
    Float fh = new Float(h);
    boxHeights.put(name, fh);
  }


  // Startwert der Höhe der Temperaturlinie
  y = map(dataTemperatur.get(0).temp, 0, 11, height/2, 0);
  println("y " + y);

  //sort array 
  Collections.sort(dataGlacierLength);

  frameRate(30);

  timer = millis();
  ready = true;
}

void draw() {


  if (!ready) {
    background(0);
    return;
  }

  //change year every 300 millis
  if (millis()-timer>300) {
    timer = millis();
    updateYear();
  }

  float boxX = 0;
  float boxY = 0;
  float screen = (float)width/4.0;

  // Filter aktuelles Jahr
  List<Gletscher> dataYear = filterYear(dataGlacierLength, actualYear);

  // Filter Start Jahr -> um boxWidth zu ermitteln
  List<Gletscher> dataStartYear = filterYear(dataGlacierLength, startYear);

  // Beim ersten Durchlauf der For-Schleife sollen alle Werte der Spalte "absoluteLength" addiert werden
  // Wert brauche ich für die Berechnung der jeweiligen Boxbreite -> mit map() hat es nicht wie gewünscht funktioniert
  if (one == true) {
    for (int z=0; z<dataYear.size(); z++) {
      total = total + dataYear.get(z).absoluteLength;
    }
    one = false;
  }


  canvas.beginDraw();
  canvas.background(0);

  // Skala Text
  canvas.fill(230, 230, 230);
  canvas.noStroke();
  canvas.textFont(fontRegular);
  // textStyle(NORMAL) -> nur nötig, wenn keine Schrift eingebunden;
  canvas.textSize(18);
  canvas.textAlign(RIGHT);
  canvas.text("Gletscherlänge im Jahr 1900 = 100%", canvas.width-20, canvas.height-marginBottom+20);
  // SkalaLine
  canvas.stroke(230, 230, 230);
  canvas.strokeWeight(2);
  canvas.line(canvas.width-270, canvas.height-marginBottom, canvas.width, canvas.height-marginBottom);


  for (int i=0; i<dataYear.size(); i++) {

    // startValueGlacier
    float maxValueGlacier = dataStartYear.get(i).absoluteLength;

    // Breite der Box ausrechnen
    boxWidth = dataStartYear.get(i).absoluteLength;
    boxWidth = (float)canvas.width/total*boxWidth;

    // alle Boxen gleich breit
    float targetBoxHeight = map(dataYear.get(i).absoluteLength, 0, maxValueGlacier, 0, canvas.height-marginBottom);
    String name = dataYear.get(i).name;
    Float floatObject = boxHeights.get(name);
    float easedValue = ease(floatObject.floatValue(), targetBoxHeight);
    boxHeights.put(name, easedValue);

    // Box zeichnen
    canvas.fill(230, 230, 230);
    canvas.stroke(0, 0, 0);
    canvas.strokeWeight(2);
    float h = boxHeights.get(name);
    canvas.rect(boxX, boxY, boxWidth, h);


    // Name Gletscher
    canvas.pushMatrix();
    canvas.fill(0);
    canvas.noStroke();
    canvas.textFont(fontRegular);
    // textStyle(NORMAL); -> nur nötige, wenn keine Schrift eingebunden
    // Schriftgrösse und/oder Position ändern, wenn balken schmäler als 850
    Gletscher current = dataStartYear.get(i);
    float currentHeight = boxHeights.get(name);
    if (current.absoluteLength < 510) {
      canvas.textSize(12);
      canvas.translate(boxX+11.5, currentHeight-9);
    } else if (current.absoluteLength < 850) {
      canvas.textSize(18);
      canvas.translate(boxX+17, currentHeight-9);
    } else {
      canvas.textSize(18);
      canvas.translate(boxX+21, currentHeight-9);
    }
    canvas.rotate(PI / -2.0);
    canvas.textAlign(LEFT);
    canvas.text(dataYear.get(i).name, 0, 0);
    canvas.popMatrix();

    // Change Attributes
    boxX = boxX+boxWidth;
  }

  canvas.endDraw();



  image(canvas, 0, 0, width, height);
}


class Gletscher implements Comparable<Gletscher> {

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


  @Override     
    public int compareTo(Gletscher other) {          
    return (this.breitengrad < other.breitengrad ? -1 : 
      (this.breitengrad == other.breitengrad ? 0 : 1));
  }
}

List<Gletscher> filterYear(ArrayList<Gletscher> arr, int year) {
  List<Gletscher> filterList = new ArrayList<Gletscher>();

  for ( Gletscher g : arr) { 
    // or equalsIgnoreCase or whatever your conditon is
    if (g.year == year) {
      // do something 
      filterList.add(g);
    }
  }
  return filterList;
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

// Easing Funktion
float ease(float n, float target) {
  float easing = 0.05;
  float d = target - n;
  return n + d * easing;
}

void updateYear() { 

  actualYear++;
  a++;

  // Im Jahr 2090 die Animation beenden
  if (actualYear>=2090) {
    actualYear = 2090;
    a = 190;
  }
}
