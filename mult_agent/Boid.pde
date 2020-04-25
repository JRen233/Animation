class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    
  float maxspeed; 
  
  Boid(PVector center_position){
    position=center_position.copy();
    velocity=new PVector(0,0);
    acceleration=new PVector(0,0);
    r=10.0;
    maxspeed = 1.52;
    maxforce = 0.2;
  }
  
  void shape() {
    fill(50, 100,40);
    stroke(255);
    circle(position.x, position.y, r);
  }
  
  void applyForce(ArrayList<Boid> bbb){
    PVector sepF = seperation(bbb);
    PVector cohe = cohe(bbb);
    PVector aF = align(bbb);
    
    acceleration.add(aF);
    acceleration.add(cohe);
    acceleration.add(sepF);
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    
    acceleration.mult(0);
  }
  
  PVector seperation(ArrayList<Boid> boids){
    float desiredseparation = 25;
    int count = 0;
    PVector steer = new PVector(0, 0, 0);
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        
        diff.normalize();
        diff.div(d);        // Weight by distance  
        steer.add(diff);
        count++;            // Keep track of how many
      }   
    }
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce+0.25);
    }
    
    return steer;   
 }
 
 PVector align (ArrayList<Boid> boids) {
    float desiredseparation = 25;
    int count = 0;
    PVector steer = new PVector(0, 0, 0);
    for (int i = 0; i< boids.size(); i++) {
      Boid temp= boids.get(i);
      float d = PVector.dist(position, temp.position);
      if ((d > 0) && (d < desiredseparation)) {
        steer.add(temp.velocity);
        count++;            // Keep track of how many
      }   
    }
    if (count > 0) {
      steer.div((float)count);
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;   
 }
 
  PVector cohe (ArrayList<Boid> boids) {
    float desiredseparation = 25;
    int count = 0;
    PVector steer = new PVector(0, 0, 0);
    for (int i = 0; i< boids.size(); i++) {
      Boid temp= boids.get(i);
      float d = PVector.dist(position, temp.position);
      if ((d > 0) && (d < desiredseparation)) {
        steer.add(position);
        count++;            // Keep track of how many
      }   
    }
    if (count > 0) {
      steer.div((float)count);
      steer.sub(position);
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;   
 }
 
  
}
