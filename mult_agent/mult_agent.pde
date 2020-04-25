PVector start;
PVector end;
float standX;
float standY;
float radius;
PVector obstacle;
float obsR;
float cObsR;
float neighborD;  // max neibor distance
int sampleP;  // number of nodes
ArrayList<Node> randSample;
// ArrayList<ArrayList<PVector>> neighbors;
ArrayList<Node> fringe = new ArrayList<Node>();
ArrayList<Node> path = new ArrayList<Node>();
ArrayList<Node> bfs_path = new ArrayList<Node>();  // use to compare
PVector curP;
PVector nextP;
int nextOne;
float maxSpeed;  // use to limit the speed of the boids
int boids_num;

ArrayList<PVector> obs_list = new ArrayList<PVector>();
ArrayList<Node> openSet = new ArrayList<Node>();
ArrayList<Node> closeSet = new ArrayList<Node>();
ArrayList<Boid> boids = new ArrayList<Boid>(); 

void setup() {
  size(800,600, P2D);
  standX = width/20;  // divided to a 20 * 20 canvas
  standY = height/20;
  radius = width/40;  // radius for the robert, which is 0.5m
  obsR = width/10;  // randius for the obstacle, which is 2m
  sampleP = 100;  // number of points we want to sample
  start = new PVector(standX, standY * 19);
  end = new PVector(standX * 19, 0);
  maxSpeed = 1.5;
  obstacle = new PVector(standX * 10, standY * 10);
  boids_num = 20;
  
  obs_list.clear();
  obs_list.add(obstacle);
  randomObstacle(6);
  
  createCspace();  // create the c space
  randSample = new ArrayList<Node>();  // initialize the random sample list
  randSample.add(new Node(start));
  randSample.add(new Node(end));
  randomSample();
  neighborD = width/4;  // set the maxDist of neighor that can be connected
  //neighbors = new ArrayList();
  addNeighbors();  // add neighbor to each node
  //println("xxxxxxxx");

  if(!Astar()) {  // if the roadmap didn't work, try again
    setup();
    println("no path");
  } else {
    BFS();
    Node lastNode = randSample.get(1);  // second node is the end node
    Node bfs_lastNode = randSample.get(1);
    
    bfs_path.add(bfs_lastNode);
    while(bfs_lastNode.bfs_parent != null) {
      bfs_path.add(bfs_lastNode.bfs_parent);
      bfs_lastNode = bfs_lastNode.bfs_parent;
    }
    
    path.add(lastNode);  // creating the path
    while(lastNode.parent != null) {
      path.add(lastNode.parent);
      lastNode = lastNode.parent;
    }
  }

  println("here is the bfs nodes:");  // print the path size
  println(path.size());
  for(int i = 0; i< path.size(); i++) {
    println(path.get(i).location);
  }
  println("here is the size:");  // print the path size
  for(int i = 0; i< bfs_path.size(); i++) {
    println(bfs_path.get(i).location);
  }
  println("==========================");
  
  curP = path.get(path.size()-1).location.copy();  // the start nodes
  nextP =  path.get(path.size()-2).location.copy();  // the next nodes after start nodes
  //println(curP, nextP);
  nextOne = path.size()-2;
  
  // TODO: setup the all the boids
  // add the starting points
  boids.add(new Boid(new PVector(start.x,start.y))); 
  for (int i = 0; i < boids_num; i++) {
    boids.add(new Boid(new PVector(start.x-i*7,start.y+i*7)));
  }
  
}

void draw() {
  background(255);
  fill(127);
  noStroke();
  //circle(start.x,start.y, radius);
  //circle(end.x,end.y, 5);
  for (int i = 0; i< obs_list.size(); i++) {
    PVector obst = obs_list.get(i);
    circle(obst.x, obst.y, obsR);
  }
  

  for (int i = 0; i < randSample.size(); i++) {
    Node temp = randSample.get(i);
    circle(temp.location.x,temp.location.y,2);
  }
  
  // draw the path for whole graph
  stroke(0,0,0);
  for (int i = 0; i < randSample.size(); i++) {
    Node tem = randSample.get(i);
    ArrayList<Node> temp = tem.neighbor;
    if (temp.size() == 0)
      continue;
    for(int j = 0; j < temp.size(); j++) {
      line(tem.location.x,tem.location.y,temp.get(j).location.x,temp.get(j).location.y);
    }
  }
  
  // draw the correct path find by A*
  stroke(255,0,0);
  for (int i = 0; i < path.size()-1; i++) {
    PVector temp1 = path.get(i).location;
    PVector temp2 = path.get(i+1).location;
    line(temp1.x,temp1.y,temp2.x,temp2.y);
  }
  
  // if not reach the end, continue to update
  if (!(curP.x == end.x && curP.y == end.y)) {
    update();
  } else {
    noLoop();
  }
  
  // draw the current should be replace by boids
  // circle(curP.x,curP.y, radius);
  
  // TODO update the boids and draw the boids
  for(int i = 0; i< boids.size(); i++) {
    Boid temp = boids.get(i);
    temp.applyForce(boids);
  }
  
  for(int i = 0; i< boids.size(); i++) {
    Boid temp = boids.get(i);
    
    temp.update();

    for(int j = 0; j<obs_list.size(); j++) {
      float d = PVector.dist(obs_list.get(j), temp.position);
      if(d < (cObsR-30)) {
        PVector diff = PVector.sub(obs_list.get(j), temp.position);
        diff.normalize();
        diff.mult(1.5);
        temp.velocity.sub(diff);
      }
    }
    temp.shape();
  }
  
  // show the bfs path
  stroke(0,0,255);
  for(int i = 0; i< bfs_path.size()-1; i++) {
    Node cur = bfs_path.get(i);
    Node next_n = bfs_path.get(i+1);
    line(cur.location.x,cur.location.y,next_n.location.x,next_n.location.y);
  }
}

void createCspace() {
  cObsR = obsR + radius;
}

void randomSample() {
  for (int i = 0; i < sampleP; i++) {
    PVector temp = new PVector(random(600),random(600));
    if (!ifCollision(temp)) {
      Node temp_node = new Node(temp);
      temp_node.h = dist(temp_node.location.x,temp_node.location.y,end.x,end.y);
      randSample.add(temp_node);
    } 
    //randSample.add(new Node(temp));
  }
}

boolean ifCollision(PVector x) {
  if(x == start || x == end) {
    return true;
  }
  for (int i = 0; i< obs_list.size(); i++) {
    PVector obst = obs_list.get(i);
    if(PVector.dist(x, obst) < cObsR) {
      return true;
    }
  }

  return false;
}

void addNeighbors() {  // add neighbor to each node
  for(int i = 0; i < randSample.size(); i++) {
    for(int j = 0; j < randSample.size(); j++) {
      if(i!=j && PVector.dist(randSample.get(i).location,randSample.get(j).location) < neighborD) {
       randSample.get(i).neighbor.add(randSample.get(j));
      }     
    }
  }
}

Boolean BFS () {
  randSample.get(0).visit = true;  // first one is always the start point
  fringe.add(randSample.get(0));
  
  while(fringe.size() > 0) {
    Node currentNode = fringe.get(0);
    fringe.remove(0);
    if(currentNode.location.x == end.x && currentNode.location.y == end.y) {
      println("Goal found!");
      return true;
    }
    //int x = 0;
    //for (int i = 0; i < randSample.size(); i++) {
    //  x++;
    //  if(currentNode == randSample.get(i)) {
    //    break;
    //  }
    //}
    for(int i = 0; i < currentNode.neighbor.size(); i++) {
      Node neighborNode = currentNode.neighbor.get(i);
      if (!neighborNode.visit) {
        neighborNode.visit = true;
        neighborNode.bfs_parent = currentNode;
        fringe.add(neighborNode);
        //println();
        //println("Current Fringe: ");
        for(int j = 0; j < fringe.size(); j++) {
          //print(fringe.get(j).location, " ");
        }
      }
    }
    //println("---------");
  }
  
  return false;
}

void update() {
  if (curP.x == nextP.x && curP.y == nextP.y) {
    if (nextOne > 0) {
      nextP = path.get(nextOne-1).location.copy();
      nextOne--;
    }
    
  }
  PVector direction = PVector.sub(nextP,curP);
  direction.normalize();
  //println(direction, nextP);
  direction.mult(maxSpeed);
  curP.add(direction);
  
  
  if (PVector.dist(curP,nextP) < 3) {
    //println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    curP = nextP.copy();
  }
  //println(curP);
  
  // update boids acceleration
  for (int i = 0; i< boids.size(); i++) {
    PVector dir = PVector.sub(nextP, boids.get(i).position);
    dir.normalize();
    boids.get(i).acceleration.add(dir);
  }
}

Boolean Astar () {
  openSet.add(randSample.get(0));
  
  while (openSet.size() > 0) {
    int Lowest = 0;
    // find the lowest one
    for (int i = 0; i < openSet.size();i++) {
      if (openSet.get(i).f < openSet.get(Lowest).f) {
        Lowest = i;
      }
    }
    Node current = openSet.get(Lowest);  
    // if the goal found
    if(current.location.x == end.x && current.location.y == end.y) {
      println("Goal found!");
      return true;
    }
    // adding current to closeSet 
    closeSet.add(current);
    openSet.remove(current);
    for (int i = 0; i < current.neighbor.size(); i++) {
      Node neighbor = current.neighbor.get(i);
      float tentative_gScore = current.g+dist(current.location.x,current.location.y, neighbor.location.x,neighbor.location.y);
      // if it is first time to explore the neighbor
      if ((!closeSet.contains(neighbor)) && (!openSet.contains(neighbor))) {
        neighbor.g = tentative_gScore;
        neighbor.f = neighbor.g + neighbor.h;
        neighbor.parent = current;
        openSet.add(neighbor);
      }
      // update the g and f
      if(tentative_gScore < neighbor.g) {
        neighbor.g = tentative_gScore;
        neighbor.f = neighbor.g + neighbor.h;
        neighbor.parent = current;
      }
    }
  }
  return false;
}

void randomObstacle(int x) {
  for (int i = 0; i < x; i++) {
    PVector temp = new PVector(random(standX)*20, random(standY)*20);
    if(PVector.dist(temp,start) > cObsR+50 && PVector.dist(temp,end) > cObsR+50){
      obs_list.add(temp);    
    }
  }
}
