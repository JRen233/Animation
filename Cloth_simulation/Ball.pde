class Ball{
  PVector location;
  PVector velocity;
  PVector acceleration;
  Ball(PVector loc, PVector vel, PVector acc) {
    location = loc.copy();
    velocity = vel.copy();
    acceleration = acc.copy();
  }
  
  void update(float dt) {
    location.add(PVector.mult(PVector.add(velocity, acceleration),dt));
  }
  
  void display(float radius) {
    //fill(0,0,0);
    pushMatrix();
    translate(location.x, location.y, location.z);
    box(radius);
    popMatrix();
  }
}
