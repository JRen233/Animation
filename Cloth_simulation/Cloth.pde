class Cloth {
  Ball[][] cloth;
  PVector[][] vel;
  int rows = 30;
  int cols = 30;
  float between = 10;
  float between1 = 5;
  PVector start = new PVector(100,100,0);
  //PVector top = new PVector(100,50,0);
  float ks = 700;
  float kd = 100;
  float restLen =10;
  float dt = 0.009;
  PVector gravity = new PVector(0,100,0);
  PVector gravitys = new PVector(0,0.7,0);
  PVector zeros = new PVector(0,0,0);
  float mass = 5;
  
  PVector spheres = new PVector(300,400,0);  // sphere postition
  float sRadius = 100;
  
  float radius = 1; 
  
  Cloth() {
    cloth = new Ball[cols][rows];
    vel = new PVector[cols][rows];
    for (int i = 0; i < cols; i++) {
      //cloth[i][0] = new Ball(new PVector(start.x+i*between,start.y,start.z), new PVector(0,0,0), new PVector(0,0,0));
      //println(cloth[i][0].location.x);
      for (int j = 0; j < rows; j++) {
        //cloth[i][j] = new Ball(new PVector(start.x+i*between,start.y+(j*between),start.z), new PVector(0,0,0), new PVector(0,0,0));  // y direction
        //cloth[i][j] = new Ball(new PVector(start.x+i*between,start.y,start.z+(j*between)), new PVector(0,0,0), gravity.copy());  // z direction
        cloth[i][j] = new Ball(new PVector(start.x + i*between,start.y,start.z+(j*between)), new PVector(0,0,0), new PVector(0,0,0));      
        //print(cloth[i][j].location.y+" "); 
        vel[i][j] = zeros.copy();
      } 
      //println();
    }
  }
  
  void update() {
    //for(int i = 0; i< cols; i++) {  // set acc back to zero
    //  for(int j = 0; j<rows; j++) {
    //    cloth[i][j].acceleration = zeros.copy();
    //  }
    //}   
    
    for (int i = 0; i < cols-1; i++) {
      for (int j = 0; j< rows; j++) {
        Ball temp = cloth[i][j];
        Ball tempN = cloth[i+1][j];
        
        PVector e = PVector.sub(tempN.location,temp.location);
        float sLength = e.mag();
        //e = e.div(sLength);  // now e become direction vector
        e.normalize();
        float v1 = e.dot(temp.velocity);
        float v2 = e.dot(tempN.velocity);
        float f = -ks*(restLen-sLength)-kd*(v1-v2);
        //println(sLength+" "+f+ " " + v1+" "+v2 + " " + e);
        //PVector springForce = PVector.mult(e, f);
        //PVector new_Acce = springForce.div(mass);
        //temp.acceleration.x = new_Acce.x/2;
        //temp.acceleration.y = new_Acce.y/2 + gravitys/mass;    
        //temp.acceleration.z = new_Acce.z/2;
        //tempN.acceleration.x = -new_Acce.x/2;
        //tempN.acceleration.y = -new_Acce.y/2 + gravitys/mass;
        //tempN.acceleration.z = -new_Acce.z/2;
          
        //PVector tem1 = PVector.add(gravity,new_Acce);
        //PVector tem2 = PVector.add(gravity,new_Acce);
        //temp.velocity.add(PVector.mult(gravity,dt));
        //tempN.velocity.add(PVector.mult(gravity,dt));
        //temp.velocity.add(PVector.mult(e, f)); 
        //tempN.velocity.sub(PVector.mult(e, f)); 
        
        temp.velocity.add(gravitys);
        tempN.velocity.add(gravitys);
        temp.velocity.add(PVector.mult(PVector.mult(e, f), dt)); 
        tempN.velocity.sub(PVector.mult(PVector.mult(e, f), dt)); 
        
      }
    }
    
     for (int i = 0; i < cols; i++) {
      for (int j = 0; j< rows-1; j++) {
        Ball temp = cloth[i][j];
        Ball tempN = cloth[i][j+1];
        
        PVector e = PVector.sub(tempN.location,temp.location);
        float sLength = e.mag();
        e = e.div(sLength);
        float v1 = e.dot(temp.velocity);
        float v2 = e.dot(tempN.velocity);
        float f = -ks*(restLen-sLength)-kd*(v1-v2);
        
        //PVector springForce = PVector.mult(e, f);
        //PVector new_Acce = springForce.div(mass);        
        //temp.acceleration.x = new_Acce.x/2;
        //temp.acceleration.y = new_Acce.y/2 + gravitys/mass;    
        //temp.acceleration.z = new_Acce.z/2;
        //tempN.acceleration.x = -new_Acce.x/2;
        //tempN.acceleration.y = -new_Acce.y/2 + gravitys/mass;
        //tempN.acceleration.z = -new_Acce.z/2;   
        
        temp.velocity.add(gravitys);
        tempN.velocity.add(gravitys);
        temp.velocity.add(PVector.mult(PVector.mult(e, f),dt)); 
        tempN.velocity.sub(PVector.mult(PVector.mult(e, f), dt)); 
        
      }
    }

    if(mouseButton==LEFT){
      wind();
    }
    if(mouseButton == RIGHT) {
      drag();
    }
    //drag();
    for(int i = 0; i< cols; i++) {  // set top row to 0
      cloth[i][0].velocity = zeros.copy();
    }
    for(int i = 0; i< cols; i++) {  
      for(int j = 0; j<rows; j++) {
        Ball temp = cloth[i][j];
        temp.update(dt);
        float d = PVector.dist(temp.location, spheres);
        if(d < sRadius + 0.01) {
          PVector normal = PVector.sub(temp.location, spheres);
          normal.normalize();
          float x = PVector.dot(temp.velocity, normal);
          PVector bounce = PVector.mult(normal, x);
          bounce = bounce.mult(2);
          temp.velocity.sub(bounce);
          temp.location.add(PVector.mult(normal,1+sRadius-d));
        }
      }
    }  
  }
  
  void wind() {
    for(int i = 0; i< cols; i++) {  
      for(int j = 0; j<rows; j++) {
        cloth[i][j].velocity.add(new PVector(3,0,-3));
      }
    }
  }
  
  void drag() {
     for (int i = 0; i < cols -1; i++) {
      for (int j = 0; j< rows -1; j++) {
        Ball temp = cloth[i][j];
        Ball tempD = cloth[i][j+1];
        Ball tempR = cloth[i+1][j];
        
        float fac = 3;
        PVector v1 = PVector.add(temp.velocity,tempD.velocity);
        PVector v2 = PVector.add(v1, tempR.velocity);
        PVector v = PVector.div(v2,fac);
        
        PVector t1 = PVector.sub(tempD.location, temp.location);
        PVector t2 =  PVector.sub(tempR.location, temp.location);
        PVector r = new PVector(0,0,0);
        PVector n = PVector.cross(t1,t2,r);
        float nLen = n.mag();
        PVector normal = PVector.div(n,nLen);
        float a0 = nLen/2;
        float area = a0 * PVector.dot(v, normal) / v.mag();  // area
        PVector f = PVector.div(PVector.mult(normal,-0.0001 * area * v.magSq()), fac);
        temp.velocity.add(f);
        tempD.velocity.add(f);
        tempR.velocity.add(f);
      }
    }
  }
  
  void display(PImage gopher) {
    noFill();
    noStroke();
    textureMode(NORMAL);
    for(int j = 0; j < rows-1; j++) {
      beginShape(TRIANGLE_STRIP);
      texture(gopher);
      for(int i = 0; i< cols; i++) {
        //cloth[i][j].display(radius);         // so slow
        Ball temp = cloth[i][j];
        Ball tempN = cloth[i][j+1];
        //line(cloth[i][j].location.x,cloth[i][j].location.y,cloth[i][j].location.z,cloth[i+1][j].location.x,cloth[i+1][j].location.y,cloth[i+1][j].location.z);
        //line(cloth[i][j].location.x,cloth[i][j].location.y,cloth[i][j].location.z,cloth[i][j+1].location.x,cloth[i][j+1].location.y,cloth[i][j+1].location.z);
        float x = temp.location.x;
        float y = temp.location.y;
        float z = temp.location.z;
        float u = map(i, 0, cols-1, 0, 1);
        float v = map(j, 0, rows-1, 0, 1);
        vertex(x,y,z,u,v);
        float x1 = tempN.location.x;
        float y1 = tempN.location.y;
        float z1 = tempN.location.z;
        float v1 = map(j+1, 0, rows-1, 0, 1);
        vertex(x1,y1,z1, u, v1);
      }
      endShape();
    }   
  }
}
