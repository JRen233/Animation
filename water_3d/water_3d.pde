PShape s;
ArrayList<PVector> tran;
ArrayList<PVector> vel;

PVector origin;
PVector velocity;
PVector acceleration;
PVector location;

float start = 30;
float initial = 10;
void setup() {
  size(400,450,P3D);
 
  origin = new PVector(width/2-100,height/2,0);
  acceleration = new PVector(0,0.05,0);
  tran = new ArrayList<PVector>();
  vel = new ArrayList<PVector>();
  s = loadShape("Potion1Full.obj");
}

void draw() {
  background(255);
  println(frameCount/(millis()/1000), tran.size());
  
  if(mouseX == 0 && mouseY == 0) {
    pushMatrix();
    translate(width/2-115,height/2+50,0);
    rotate(3.4);
    s.setFill(color(255,233,0));
    shape(s,0,0,70,70);
    popMatrix();
  } else {
    pushMatrix();
    translate(mouseX,mouseY,0);
    rotate(3.4);
    s.setFill(color(255,233,0));

    shape(s,0,0,70,70);
    popMatrix();
  }
  
  fill(122,122,24);
  beginShape();
  vertex(300,70);
  vertex(100,50);
  vertex(0,450);
  vertex(390,450);
  
  endShape();
  
  for(int i = 0; i < start; i++) {
    if(mouseX == 0 && mouseY == 0) {
      tran.add(new PVector(origin.x+random(-initial,initial),origin.y+random(-initial,initial),origin.z+random(-initial,initial)));
    } else {
      tran.add(new PVector(mouseX+20+random(-initial,initial),mouseY-50+random(-initial,initial),0+random(-initial,initial)));
    }
    
    vel.add(new PVector(random(0.5-0.03,0.5+0.03),random(-2,-2.5),0));
    
    //if(tran.size() > 5000){
    //  tran.remove(0);
    //  vel.remove(0);
    //}
  }
  
  for(int i = tran.size()-1; i > 0; i--) {
    PVector temp = tran.get(i);
    PVector tempV = vel.get(i);
    update(temp, tempV);
    pushMatrix();
    show(temp);
    popMatrix();
    
    if(temp.x > 375 && temp.y > 400) {
      tran.remove(i);
      vel.remove(i);
    }
  }
  //update(tran.get(10),vel.get(10));
  //show(tran.get(10));
}

void update(PVector loc, PVector v) {
  v.add(acceleration);
  loc.add(v);
  
  if(loc.y > 400) {
    v.y = v.y * -0.4;
  }
}

void show(PVector loc) {

  translate(loc.x,loc.y,loc.z);
  noStroke();
  fill(156,200,255);
  //lights();
  //sphere(3);
  box(3);
}
