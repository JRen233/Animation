class Node {
  Boolean visit;
  ArrayList<Node> neighbor;
  Node parent;
  Node bfs_parent;
  PVector location;
  float f;
  float g;
  float h;
  Node(PVector loc) {
    f = 0;
    g = 0;
    h = 0;
    location = loc.copy();
    parent = null;
    bfs_parent = null;
    neighbor = new ArrayList<Node>();
    visit = false;
  }
  
}
