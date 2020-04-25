ArrayList<Ball> bList;
ArrayList<PVector> springForce1;
int number = 3;

ArrayList<Ball> bList2;
ArrayList<PVector> springForce2;
int number2 = 4;

void setup() {
  size(600, 500, P3D);
  bList = new ArrayList<Ball>();
  springForce1 = new ArrayList<PVector>();
  for(int i = 0; i< number;i++) {
    bList.add(new Ball(new PVector(200, 200+i*50, 0), new PVector(0,0,0)));
  }
  bList2 = new ArrayList<Ball>();
  springForce2 = new ArrayList<PVector>();
  for(int i = 0; i< number2;i++) {
    bList2.add(new Ball(new PVector(450, 200+i*50, 0), new PVector(0,0,0)));
  }
}
// Simulation parameters
float floor = 500;
float gravity = 10;
float radius = 10;
float stringTop = 50;
float stringX = 200;
PVector stringIni = new PVector(200, 50, 0);
PVector stringIni2 = new PVector(450, 50, 0);
float restLen = 40;
float mass = 30;
float k = 20;
float kv = 20;
int initial = 0;
int initial2 = 0;

void update(float dt) {
  
  for(int i = 0; i< number;i++) {
    Ball temp = bList.get(i);
    PVector s;
    if(i == 0) {
      s = PVector.sub(temp.location, stringIni);
    } else {
      Ball pre = bList.get(i-1);
      //temp.location.sub(pre.location);
      s = PVector.sub(temp.location, pre.location);
    }
    float stringLen = s.mag();
    float stringF = -k*(stringLen - restLen);
    PVector dir = s.div(stringLen);
    float projVel = temp.velocity.dot(dir);
    float dampF = -kv*(projVel - 0);
    PVector springForce = PVector.mult(dir,(stringF+dampF));
    
    //springForce1.add(springForce);     
    
    //Ball temp = bList.get(i);
    //float sx;
    //float sy;
    //if(i == 0) {
    //  sx = temp.location.x - stringX;
    //  sy = temp.location.y - stringTop;
    //} else {
    //  Ball previous = bList.get(i-1);
    //  sx = temp.location.x - previous.location.x;
    //  sy = temp.location.y - previous.location.y;
    //}
    //float stringLen = sqrt(sx*sx + sy*sy);

    //float stringF = -k*(stringLen - restLen);
    //float dirX = sx/stringLen;
    //float dirY = sy/stringLen;
    //float projVel = temp.velocity.x*dirX + temp.velocity.y*dirY;

    //float dampF = -kv*(projVel - 0);
    //float springForceX = (stringF+dampF)*dirX;
    //float springForceY = (stringF+dampF)*dirY;
    //if(i == 0) {
    //  println(stringLen, stringF, dirX, dirY, dampF, springForceY);
    //}
    if(initial < number){
      springForce1.add(springForce);
      initial += 1;
    } else {
      springForce1.get(i).x = springForce.x;
      springForce1.get(i).y = springForce.y;
      springForce1.get(i).z = springForce.z;
    }
    
  }
  
  for(int i = 0; i< number2;i++) {
    Ball temp = bList2.get(i);
    PVector s;
    if(i == 0) {
      s = PVector.sub(temp.location, stringIni2);
    } else {
      Ball pre = bList2.get(i-1);
      //temp.location.sub(pre.location);
      s = PVector.sub(temp.location, pre.location);
    }
    float stringLen = s.mag();
    float stringF = -k*(stringLen - restLen);
    PVector dir = s.div(stringLen);
    float projVel = temp.velocity.dot(dir);
    float dampF = -kv*(projVel - 0);
    PVector springForce = PVector.mult(dir,(stringF+dampF));

    if(initial2 < number2){
      springForce2.add(springForce);
      initial2 += 1;
    } else {
      springForce2.get(i).x = springForce.x;
      springForce2.get(i).y = springForce.y;
      springForce2.get(i).z = springForce.z;
    }
  }
   
  for(int i = 0; i< number;i++) {
    float accx;
    float accy;
    if(i != number-1){
      //accx = 0.5 * (springForce1.get(i).x/mass) - 0.5 * (springForce1.get(i+1).x/mass);
      //accy = gravity + 0.5 * (springForce1.get(i).y/mass) - 0.5 * (springForce1.get(i+1).y/mass);  
      accx = .5 * springForce1.get(i).x/mass - .5*springForce1.get(i+1).x/mass;
      accy = gravity + .5*springForce1.get(i).y/mass - .5*springForce1.get(i+1).y/mass;
    } else {
      //accx = 0.5 * (springForce1.get(i).x/mass);
      //accy = gravity + 0.5 * (springForce1.get(i).y/mass);
      accx = .5*springForce1.get(i).x/mass;
      accy = gravity + .5*springForce1.get(i).y/mass;
    }
    
    bList.get(i).velocity.x += accx*dt;
    bList.get(i).velocity.y += accy*dt;
    bList.get(i).location.x += bList.get(i).velocity.x*dt;
    bList.get(i).location.y += bList.get(i).velocity.y*dt;
    
    if (bList.get(i).location.y+radius > floor){
      bList.get(i).velocity.y *= -.9;
      bList.get(i).location.y = floor - radius;
    }
  }
  
    for(int i = 0; i< number2;i++) {
    float accx;
    float accy;
    if(i != number2-1){
      //accx = 0.5 * (springForce1.get(i).x/mass) - 0.5 * (springForce1.get(i+1).x/mass);
      //accy = gravity + 0.5 * (springForce1.get(i).y/mass) - 0.5 * (springForce1.get(i+1).y/mass);  
      accx = .5 * springForce2.get(i).x/mass - .5*springForce2.get(i+1).x/mass;
      accy = gravity + .5*springForce2.get(i).y/mass - .5*springForce2.get(i+1).y/mass;
    } else {
      //accx = 0.5 * (springForce1.get(i).x/mass);
      //accy = gravity + 0.5 * (springForce1.get(i).y/mass);
      accx = .5*springForce2.get(i).x/mass;
      accy = gravity + .5*springForce2.get(i).y/mass;
    }
    
    bList2.get(i).velocity.x += accx*dt;
    bList2.get(i).velocity.y += accy*dt;
    bList2.get(i).location.x += bList2.get(i).velocity.x*dt;
    bList2.get(i).location.y += bList2.get(i).velocity.y*dt;
    
    if (bList2.get(i).location.y+radius > floor){
      bList2.get(i).velocity.y *= -.9;
      bList2.get(i).location.y = floor - radius;
    }
  }
}


void draw() {
  background(255,255,255);
  update(0.1);
  fill(0,0,0);
  
  pushMatrix();
  line(stringIni.x, stringIni.y, stringIni.z, bList.get(0).location.x, bList.get(0).location.y, bList.get(0).location.z);
  translate(bList.get(0).location.x,bList.get(0).location.y, bList.get(0).location.z);
  sphere(radius);
  popMatrix();
  for(int i = 1; i< number; i++) {
    Ball temp = bList.get(i);
    Ball pre = bList.get(i-1);
    pushMatrix();
    line(pre.location.x,pre.location.y, pre.location.z,temp.location.x,temp.location.y, temp.location.z);
    translate(temp.location.x, temp.location.y, temp.location.z);
    sphere(radius);
    popMatrix();
  }
  
  pushMatrix();
  line(stringIni2.x, stringIni2.y, stringIni2.z, bList2.get(0).location.x, bList2.get(0).location.y, bList2.get(0).location.z);
  translate(bList2.get(0).location.x,bList2.get(0).location.y, bList2.get(0).location.z);
  sphere(radius);
  popMatrix();
  for(int i = 1; i< number2; i++) {
    Ball temp = bList2.get(i);
    Ball pre = bList2.get(i-1);
    pushMatrix();
    line(pre.location.x,pre.location.y, pre.location.z,temp.location.x,temp.location.y, temp.location.z);
    translate(temp.location.x, temp.location.y, temp.location.z);
    sphere(radius);
    popMatrix();
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    bList.get(number-1).velocity.x += 20;
    bList2.get(number2-1).velocity.x +=20;
  }
  if (keyCode == LEFT) {
    bList.get(number-1).velocity.x -= 20;
    bList2.get(number2-1).velocity.x -= 20;
  }
}
