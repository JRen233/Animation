class Ball{
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float radius = 15;  
  float number =20;
  ArrayList<Particle> a = new ArrayList<Particle>();
  int burn = 0;
  
  Ball(PVector loc, PVector vel, PVector acc, int b) {
    location = loc.copy();
    velocity = vel.copy();
    acceleration = acc.copy();
    burn = b;
  }
  
  void update(float dt) {
    location.add(PVector.mult(velocity,dt));
    
    
  }
  
  void display(float radius) {
    //fill(0,0,0);
    pushMatrix();
    translate(location.x, location.y, location.z);
    sphere(radius);
    popMatrix();
  }
  
  void fire() {
    if (burn == 1) {
    a.add(new Particle(new PVector(location.x, location.y, location.z)));
      for(int i = a.size()-1; i >= 0; i--) {
        Particle temp = a.get(i);
        temp.update();
        temp.show();
        if(temp.isDead()) {
          a.remove(i);
        }
      }
    }
  }
}
