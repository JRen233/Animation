Cloth cloth;
Camera camera;
PImage gopher;
void setup() {
  size(600,600,P3D);
  cloth = new Cloth();
  camera = new Camera();
  gopher = loadImage("1.PNG");
}

void draw() {
  background(255,255,255);
  for (int i = 0; i < 3; i++) {
    cloth.update(); 
  }
  camera.Update( 1.0/frameRate );

  cloth.display(gopher);
  println(frameCount/(millis()/1000));  // print the benchmark
  
  //noStroke();
  //fill( 100, 150, 17);
  //lights();
  //pushMatrix();
  //translate(300,400,0);
  //sphere(100);
  //popMatrix();
  
}

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
