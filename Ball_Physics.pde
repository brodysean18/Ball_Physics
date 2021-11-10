import java.util.Random;

final float GRAV = 2;               // IN PIXELS PER FRAME PER FRAME. SET TO 0 FOR NO GRAVITY AND POSITIVE VALUES FOR DOWNWARD GRAVITY. 1.1 IS A GOOD VALUE
final float DAMP = 0.1;             // IN PIXELS PER FRAME LOST PER COLLISON. SET TO 0 FOR NO DAMPING AND 1 FOR MAX DAMPING. 0.15 IS A GOOD VALUE
final float FRIC = 0.01;            // IN PIXELS PER FRAME LOST PER COLLISON. SET TO 0 FOR NO FRICTION AND 1 FOR MAX FRICTION. 0.03 IS A GOOD VALUE
final float MIN_INIT_SPEED = 2;     // IN PIXELS PER FRAME
final float MAX_INIT_SPEED = 40;    // IN PIXELS PER FRAME
final float MAX_DIAMETER = 10;      // IN PIXELS
final float MIN_DIAMETER = 150;     // IN PIXELS
final int MAX_NUM_BALLS = 20;
final int BACKGROUND = 0;           // HEXADECIMAL COLOR (CAN USE TOOLS -> COLOR SELECTOR)

class Ball {
  float x;
  float y;
  float dx;
  float dy;
  float d;
  float fr;
  float da;
  color c;
  
  Ball(float x, float y, float dx, float dy, float d, float fr, float da, color c) {
    this.x  = x;
    this.y  = y;
    this.dx = dx;
    this.dy = dy;
    this.d  = d;
    this.fr = fr;
    this.da = da;
    this.c  = c;
  }
  
  void drawBall() {
    fill(this.c);
    ellipse(this.x, this.y, this.d, this.d);
  }
  
  void moveBall() {
    this.x += this.dx;
    this.y += this.dy;
    
    if(this.x >= (float)width - this.d/2 || this.x <= this.d/2) {
      if(this.x > this.d/2) this.x = width - this.d/2;
      else this.x = this.d/2;
      this.dx *= -1;    
      if(dx != 0) this.dx -= Math.abs(this.dx)/(1/((this.da + DAMP)/2)) * (this.dx/Math.abs(this.dx));
      if(dy != 0) this.dy -= Math.abs(this.dy)/(1/((this.fr + FRIC)/2)) * (this.dy/Math.abs(this.dy));
    }
    
    if(this.y >= height - this.d/2 || this.y <= this.d/2) {
      if(this.y > this.d/2) this.y = height - this.d/2;
      else this.y = this.d/2;
      this.dy *= -1;    
      if(dy != 0) this.dy -= Math.abs(this.dy)/(1/((this.da + DAMP)/2)) * (this.dy/Math.abs(this.dy));
      if(dx != 0) this.dx -= Math.abs(this.dx)/(1/((this.fr + FRIC)/2)) * (this.dx/Math.abs(this.dx));
    }
    
    dy += GRAV;
  }
  
  void printValues() {
    println("  x: " + x);
    println("  y: " + y);
    println("  dx: " + dx);
    println("  dy: " + dy);
  }
}

int num_balls = MAX_NUM_BALLS;
Ball[] balls = new Ball[num_balls];
PImage img;
boolean settings = false;
int dim = 0;

void setup() {
  //fullScreen();
  size(960, 995);
  surface.setTitle("Ball Simulator");
  surface.setResizable(true);
  surface.setLocation(0, 0);
  
  background(BACKGROUND);
  noStroke();
  rectMode(CORNER);
  img = loadImage("Settings.png");
  
  initBalls();
}

void draw() {  
  background(BACKGROUND);
  
  drawBalls();
  //drawSettings();
}

void drawBalls() {
  for(int i = 0; i < num_balls; ++i) {
    balls[i].drawBall();
    if(!settings) balls[i].moveBall();
  }
}

void drawSettings() {
  if(settings) {
    fill(0, dim);
    rect(0, 0, width, height);
    
    if(dim < 150) dim += 5;
    else {
      textAlign(CENTER, CENTER);
      textSize(75);
      fill(255);
      text("SETTINGS", width/2, height/20);
    }
  }
  else {
    if(dim > 0) dim -= 5;
    fill(0, dim);
    rect(0, 0, width, height);
  }
  
  fill(255, 120);
  rect(20, 20, 32, 32, 5);
  image(img, 20, 20, img.width/20, img.height/20);
}

void initBalls() {
  Random rand = new Random();
  
  for(int i = 0; i < num_balls; ++i) {
    float d  = (rand.nextFloat() * (MAX_DIAMETER - MIN_DIAMETER)) + MIN_DIAMETER;
    float x  = rand.nextFloat() * (width - d) + d/2;
    float y  = rand.nextFloat() * (height - d) + d/2;
    float fr = rand.nextFloat();
    float da = rand.nextFloat();
    
    float dx = rand.nextFloat() - 0.5;
    dx *= MAX_INIT_SPEED*2 - MIN_INIT_SPEED*2;
    if(dx != 0) dx += (MIN_INIT_SPEED * (dx/Math.abs(dx)));
    else {
      int n = rand.nextInt(2);
      n = (n == 0) ? 1 : -1;
      dx += MIN_INIT_SPEED * n;
    }
    
    float dy = rand.nextFloat() - 0.5;
    dy *= MAX_INIT_SPEED*2 - MIN_INIT_SPEED*2;
    if(dy != 0) dy += (MIN_INIT_SPEED * (dy/Math.abs(dy)));
    else {
      int n = rand.nextInt(2);
      n = (n == 0) ? 1 : -1;
      dy += MIN_INIT_SPEED * n;
    }
    
    color c = color(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
    
    balls[i] = new Ball(x, y, dx, dy, d, fr, da, c);
  }
}

void mousePressed() { 
  //if(mouseX <= 70 && mouseY <= 70) {
    //settings = !settings;
    //println("Settings");
  //}
  //else 
  initBalls();
}

void keyPressed() {
  switch(keyCode) {
    case DOWN:
      if(num_balls > 0) num_balls--;
      break;
    case UP:
      if(num_balls < MAX_NUM_BALLS) num_balls++;
      break;
  }
}
