import java.lang.*;

ArrayList<Particle> a;
// ArrayList<Smoke> s;
float number =20;
float radius = 15;
PVector p;
void setup() {
  size(400,400, P3D);
  a = new ArrayList<Particle>();
  p = new PVector(width/2,350);
}

void draw() {
  background(255);
  //println(mouseX,mouseY);
  println(frameCount/(millis()/1000), a.size());
  for(int i = 0; i < number; i++) {
    float r = radius*sqrt(random(1));
    float theta = random(2*PI);
    float x = r*sin(theta);
    float y = r*cos(theta);
    if(mouseX == 0 && mouseY == 0){
      a.add(new Particle(new PVector(p.x+x,p.y+y)));
    } else {
      a.add(new Particle(new PVector(mouseX+x,mouseY+y)));
    }
  }
  for(int i = a.size()-1; i >= 0; i--) {
    Particle temp = a.get(i);
    temp.update();
    temp.show();
    if(temp.isDead()) {
      a.remove(i);
    }
  }
}
