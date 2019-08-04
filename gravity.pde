
final int bgcolor = 128;

void setup() {
  size(1280, 960);
  background(bgcolor);
  textSize(12);
  fill(0);

  ball_x = width/2;
  ball_y = height/4;
}

//Timing stuff
long lastT = 0, currT, deltaT;


//Physics stuff
final float bounce_drag = 0.75;
final float grav = 0.001;//px/ms²

final float mouse_grav = 100;

//Ball stuff
final int ball_radius = 25;
float ball_x, ball_y;
float ball_vx = 0, ball_vy = 0;

void draw() {
  background(bgcolor);

  currT = millis();
  deltaT = currT-lastT;
  //  textAlign(LEFT, TOP);
  //  text(deltaT, 0, 0);

  //Collision detection  
  if (ball_y < ball_radius) {
    ball_y = ball_radius;
    ball_vy = -ball_vy * bounce_drag;
  } else if (ball_y > height-ball_radius) {
    ball_y = height-ball_radius;
    ball_vy = -ball_vy * bounce_drag;
  }
  if (ball_x > width-ball_radius) {
    ball_x = width-ball_radius;
    ball_vx = -ball_vx * bounce_drag;
  } else if (ball_x < ball_radius) {
    ball_x = ball_radius;
    ball_vx = -ball_vx * bounce_drag;
  }

  if (do_gravity) gravity();
  if (do_mouse_gravity) mouse_gravity();

  ball_y += ball_vy*deltaT;
  ball_x += ball_vx*deltaT;

  ellipse((int)ball_x, (int)ball_y, ball_radius*2, ball_radius*2);

  textAlign(LEFT, TOP);
  text(" x = " + ball_x + "\n y = " + ball_y + "\n v_x = " + ball_vx + "\n v_y = " + ball_vy + "\n |v| = " + sqrt(ball_vx*ball_vx + ball_vy*ball_vy), 0, 0);

  textAlign(RIGHT, TOP);
  text("Gravity = " + do_gravity + "\nMouse Gravity = " + do_mouse_gravity, width, 0);

  lastT = currT;

  //  text((int)frameRate,0,0);
  textAlign(RIGHT, BOTTOM);
  text("FPS: " + (int)frameRate, width, height);
}

boolean do_gravity = true;
float gravity_dir_x = 0;
float gravity_dir_y = 1;
void gravity() {
  ball_vx += gravity_dir_x * grav * deltaT;
  ball_vy += gravity_dir_y * grav * deltaT;
}

boolean do_mouse_gravity = false;
float mouse_gravity_dir = 1.0;
void mouse_gravity() {
  float delta_x = mouseX-ball_x;
  float delta_y = mouseY-ball_y;
  float delta_v = mouse_gravity_dir * mouse_grav/(delta_x*delta_x + delta_y*delta_y);
  float delta_vx = delta_v/sqrt(1+(delta_y/delta_x)*(delta_y/delta_x));
  float delta_vy = abs(delta_y/delta_x) * delta_vx;
  ball_vx += sign(delta_x) * delta_vx;
  ball_vy += sign(delta_y) * delta_vy;
  //  print("delta_x=" + delta_x + ",delta_y=" + delta_y + ",delta_v=" + delta_v + ",delta_vx=" + delta_vx + ",delta_vy=" + delta_vy + "\n");
}

void mousePressed() {
  if (mouseButton == LEFT) {
    mouse_gravity_dir = 1;
  } else if (mouseButton == RIGHT) {
    mouse_gravity_dir = -1;
  }
  do_mouse_gravity = true;
}
void mouseReleased() {
  do_mouse_gravity = false;
}


final int key_delta_v = 1;

void keyPressed() {
  if (key == 'q') {
    exit();
  } else if (key == 'g') {
    do_gravity = !do_gravity;
  } else if (keyCode == UP) {
    //    ball_vy-=key_delta_v;
    gravity_dir_x = 0;
    gravity_dir_y = -1;
  } else if (keyCode == DOWN) {
    //    ball_vy+=key_delta_v;
    gravity_dir_x = 0;
    gravity_dir_y = 1;
  } else if (keyCode == LEFT) {
    //    ball_vx-=key_delta_v;
    gravity_dir_x = -1;
    gravity_dir_y = 0;
  } else if (keyCode == RIGHT) {
    //    ball_vx+=key_delta_v;
    gravity_dir_x = 1;
    gravity_dir_y = 0;
  } else if (key == ' ') {
    ball_vx = 0;
    ball_vy = 0;
    ball_x = width/2;
    ball_y = height/2;
  }
}

float sign(float x) {
  if (x > 0) return 1.0;
  else if (x < 0) return -1.0;
  else return 0;
}
