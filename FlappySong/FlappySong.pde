import netP5.*;
import oscP5.*;

OscP5 oscP5;

float posX, posY; 

boolean down, up, left, right;
float speed;

PImage balloon;

void setup() {

    size(1200,800);

    oscP5 = new OscP5(this, 7348);

    balloon = loadImage("balloon.png");

    posX = width / 2;
    posY = height / 2;

    speed = 5;
}

void draw() {
    background(#4488ff);
    
    //kollar ifall cirkeln är utanför fönstret. Om den är det gör den att cirkeln hamnar i fönstret
    
    if (posY < 0) {
        posY = 0; 
    } else if (posY > height) {
          posY = height; 
      }


    //ritar cirkeln
    // ellipse(posX, posY, 50, 50); 

    // ritar luftballong
    imageMode(CENTER);
    image(balloon, posX, posY, 200, 200);

    update();
}

void update() {
  if (down == true) {
    posY += speed;
  }
  if (up == true) {
    posY -= speed;
  }
  if (left == true) {
    posX -= speed;
  }
  if (right == true) {
    posX += speed;
  }
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case DOWN:
        down = true;
        break;
      case UP:
        up = true;
        break;
      case LEFT:
        left = true;
        break;
      case RIGHT:
        right = true;
        break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
      case DOWN:
        down = false;
        break;
      case UP:
        up = false;
        break;
      case LEFT:
        left = false;
        break;
      case RIGHT:
        right = false;
        break;
    }
  }
}

void oscEvent(OscMessage message) {

    float frequency;

    message.setAddrPattern("/audio/frequency");
    frequency = message.get(0).floatValue();

    // försöker ta bort cirkelrörelse från bakgrundsljud
    // genom att filtrera bort under 200
    if ( frequency > 350.0 ) {
        // Dividerar med 3 för att justera för vissel-frekvenser
        // Subtraherar med 200 för att få den att börja ungefär vid 0
        posY = ( frequency / 3 ) - 200;
    }

    // println(theOscMessage.checkAddrPattern("/audio/frequency"));
    // println(theOscMessage.addrInt());
    
    println(posY);
}