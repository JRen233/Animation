class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan = 250;
  Particle(PVector loc) {
    acceleration = new PVector(0,-0.02);
    velocity = new PVector(random(-0.1,0.1),random(-0.5,-1.5));
    location = loc;
    
  }
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.2;
  }
  
  boolean isDead(){
    if(lifespan <= 50) {
      if(random(1) > 0.2) { 
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
  
  
  void show() {
    noStroke();
    
    if(random(1) > 0.01) {
      velocity.x = velocity.x + random(-0.02,0.02);
    }
    if (lifespan > 50) {
      fill(200,(250-lifespan),0);
    } else {
      fill(200,200,200);
    }
    pushMatrix();
    translate(location.x,location.y);
    box(3);
    popMatrix();
    
  }
}
