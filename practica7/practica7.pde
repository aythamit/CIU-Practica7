import processing.sound.*;
SoundFile file;
FFT fft;
final int MONTANIA = 0;
final int CARRETERA = 1;
String activoS = "MONTANIA";
int modo;
float vol;
float num;
float[][] temp;
int cols, rows;
int bands = 128;
int size = 14;
int w = 1024;
int h = 600;

int y = 1;
int x = 1;


float[][] terrain;
float[] spectrum = new float[bands];

void setup() {
  size(1024, 600, P3D);
  modo = MONTANIA;
  background(0);
 
 cols = w / size;
 rows = h / size;
 
 terrain = new float [cols][rows];
 temp = new float [cols][rows]; 
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "malam.mp3");
  file.loop();
    // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  fft.input(file);

}      

void draw() {
  background(0);
  noFill();
  colorMode(HSB, 100);
  fft.analyze(spectrum);
  
  text("s - Modo Montania" ,w/4, 20);
  text("a - Modo Carretera" ,w/4, 40);
  
  text("Modo Activo :" ,w/2 + w/4, 20);
  text(activoS,w/2 + w/4, 40);
  translate( width/2, height/2);
  rotateX(PI/3);
  translate( -width/2, -height/2);

  //generamos mapeado de datos 
  for (int y = rows-1; y > 0 ; y--) {
    for (int x = 0; x < cols; x++) {
     terrain[x][y] = terrain[x][y-1];
    }
  }
   fft.analyze(spectrum);
   
    // Modo Carretera
    if(modo == CARRETERA){
      for (int x = 0; x < cols/2+1; x++) {
        num = map(spectrum[x], 0, 1, 0, 500);
        terrain[x][0] = num;
        terrain[cols-(x+1)][0] = num;
      }
    }
    
    // Modo montaña
     if(modo == MONTANIA){
      for (int x = cols/2+1; x >= 0; x-- ) {
         num = map(spectrum[cols/2+1-x], 0, 1, 0, 250);
         terrain[x][0] = num;
        terrain[cols-(x+1)][0] = num;
      }
    }
  // dibujamos terreno generado
  for (int y = 0; y < rows; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      stroke(50-(terrain[x][y]/2),100,100);
      vertex(x*size, y*size,  terrain[x][y]);
      vertex(x*size, (y+1)*size, terrain[x][y]);
    }
    endShape();
  }
}

void keyPressed() {
  if(key == 'a'){
    modo = CARRETERA;
    activoS = "CARRETERA";
   background(0);
  }else if (key == 's'){
    modo = MONTANIA;
    activoS = "MONTANIA";
   background(0);
  }
}
