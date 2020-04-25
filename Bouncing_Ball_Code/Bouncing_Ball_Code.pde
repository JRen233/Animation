float position = 200; float velocity = 0;  // y coordinate
float radius = 40; float floor = 600;
float position2=0; float velocity2 = 40;  // x coordinate
void setup() {
  size(600,600,P3D);
}

void computePhysics(float dt) {
  float acceleration = 9.8;
  velocity = velocity + acceleration * dt;
  position = position + velocity * dt;
  
  //float acceleration2 = 20.3;
  //velocity2 = velocity2 + acceleration2 * dt;
  position2 = position2 + velocity2 * dt;
  
  // check the boundary
  if (position2 + radius > 600) {
    position2 = 600 - radius;
    velocity2 *=-1;
  }
  if (position2 - radius < 0) {
    position2 = radius;
    velocity2 *= -1;
  }
  if (position + radius > floor) {
    position = floor - radius;
    velocity *=-0.95;
  }
  if (position - radius < 0) {
    position = radius;
    velocity *=-1;
  }
}

void draw() {
  background(255,255,255);
  computePhysics(0.15);
  fill(0,200,10);
  noStroke();
  lights();
  //translate(300,position);
  translate(position2,position);
  sphere(radius);
}
