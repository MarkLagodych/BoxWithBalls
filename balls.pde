final int nBalls = 100;
final int maxColor = 255; // Maximum color value
final float mouseDist = 90; // Mouse effect distance
final float minDiameter = 10, maxDiameter = 40, minFriction = 0.01, maxFriction = 0.1;
final float minDefaultSpeed = -5, maxDefaultSpeed = 5;

float bg; // Background color (hue)

float sign(float x) {
  if (x < 0) return -1;
  if (x == 0) return 0;
  else return 1;
}

boolean useFriction = false;

String[] bgStrings = {
  "Press Space to enable friction",
  "Press Space to disable friction"
};

class Ball {
  float x, y, speedX, speedY, diameter, radius;
  color c;
  float friction;
  
  Ball() {
    x = random(radius, width-radius);
    y = random(radius, height-radius);
    speedX = random(minDefaultSpeed, maxDefaultSpeed);
    speedY = random(minDefaultSpeed, maxDefaultSpeed);
    diameter = random(minDiameter, maxDiameter);
    radius = diameter/2;
    friction = map(diameter, minDiameter, maxDiameter, minFriction, maxFriction);
    c = color(random(maxColor), random(maxColor/2, maxColor), maxColor);
  }
  
  void move() {
    float newX, newY;
    newX = x + speedX;
    newY = y + speedY;
    
    if (newX+radius > width) {
      newX = width - radius;
      speedX = -speedX;
    }
    
    if (newX-radius < 0) {
      newX = radius;
      speedX = -speedX;
    }
      
    if (newY+radius > height) {
      newY = height - radius;
      speedY = -speedY;
    }
    
    if (newY-radius < 0) {
      newY = radius;
      speedY = -speedY;
    }
    
    if (mousePressed)
      if (dist(newX, newY, mouseX, mouseY) < mouseDist) {
        float distX = newX - mouseX;
        float distY = newY - mouseY;
        speedX += (mouseDist * sign(distX) - distX) / mouseDist;
        speedY += (mouseDist * sign(distY) - distY) / mouseDist;
      }
    
    if (useFriction) {
      float newSpeedX = speedX - sign(speedX) * friction;
      float newSpeedY = speedY - sign(speedY) * friction;
      if (sign(newSpeedX) != sign(speedX))
        speedX = 0;
      else
        speedX = newSpeedX;
      
      if (sign(newSpeedY) != sign(speedY))
        speedY = 0;
      else
        speedY = newSpeedY;
    }
    
    x = newX;
    y = newY;
    
  }
  
  void draw() {
    fill(c);
    circle(x, y, diameter);
  }
}

Ball[] balls = new Ball[nBalls];

void setup() {
  size(800, 600);
  noStroke();
  colorMode(HSB, maxColor);
  textAlign(CENTER);
  textSize(36);
  
  for (int i=0; i<balls.length; i++)
    balls[i] = new Ball();
}

void draw() {
  background(bg, maxColor, maxColor / 4);
  bg = (bg+1) % maxColor;
  
  fill(0, 0, maxColor);
  text(bgStrings[useFriction ? 1 : 0], width/2, height/2);
  
  for (int i=0; i<balls.length; i++) {
    balls[i].move();
    balls[i].draw();
  }
}

void keyPressed() {
  useFriction = !useFriction;
}
