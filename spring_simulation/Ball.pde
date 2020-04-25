class Ball{
  PVector location;
  PVector velocity;
  Ball(PVector loc, PVector vel) {
    location = loc.copy();
    velocity = vel.copy();
  }
}
