class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = random(1,2);
  }
  void applyForce(PVector force) {
    PVector temp = PVector.div(force, mass);
    acceleration.add(temp);
  }
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void edges() {
    //if (location.x > width) location.x = 0;
    //if (location.x < 0) location.x = width;
    //if (location.y > height) location.y = 0;
    //if (location.y < 0) location.y = height;
    if(location.x > width) {
      location.x = width;
      velocity.x *= -1;
    }
    if(location.y >height) {
      location.y = height;
      velocity.y *= -1;
    }
    if(location.x < 0) {
      location.x = 0;
      velocity.x *= -1;
    }
    if(location.y < 0) {
      location.y = 0;
      velocity.y *= -1;
    }
  }
  
  void display() {
    stroke(11);
    fill(126);
    ellipse(location.x,location.y,mass*20,mass*20);
  }
}
