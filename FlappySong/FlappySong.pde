import netP5.*;
import oscP5.*;

OscP5 oscP5;

float balloonX, balloonY; 
float noteX, noteY; 
int counter; 

boolean down, up, left, right;
float speed;

PImage balloon;
PImage note;
PImage background; 

void setup() {

    size(1200,800);
    

    oscP5 = new OscP5(this, 7348);

    balloon = loadImage("balloon.png");
    note = loadImage("note.png");
    background= loadImage("sky.png"); 

    balloonX = width / 2;
    balloonY = height / 2;

    setNotePosition(); 

    speed = 5;
}

void draw() {
    background(background);
    
    //kollar ifall ballongen är utanför fönstret. Om den är det gör den att hallongen hamnar i fönstret
    
    // funkar denna korrekt?

    //balloonInsideWindow();
    //ritar cirkeln
    // ellipse(balloonX, balloonY, 50, 50); 

    imageMode(CENTER);

    // ritar not
    image(note, noteX, noteY, 80, 80);
    
    // ritar luftballong
    image(balloon, balloonX, balloonY, 200, 200);

    if(isBalloonOverNote()) {
      counter++; 
      setNotePosition();
    } 

    textSize(42);
    text(counter, 40, 80);

    update();
}

void update() {
  if (down == true) {
    balloonY += speed;
  }
  if (up == true) {
    balloonY -= speed;
  }
  if (left == true) {
    balloonX -= speed;
  }
  if (right == true) {
    balloonX += speed;
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

float randomizeFloat(float min, float max) {
  float pos;
  pos = random(min, max);
  return pos;
}

void setNotePosition() {
  noteX = randomizeFloat(0, width); 
  noteY = randomizeFloat(0, height); 
}

boolean isBalloonOverNote() {
  // if (balloonX > noteX && balloonX < noteX + note.width / 2 && balloonY > noteY && balloonY < noteY + note.height / 2) {
    if (balloonX > noteX - note.width / 2 && balloonX < noteX + note.width / 2 &&
      balloonY > noteY - note.height / 2 && balloonY < noteY + note.height / 2) {
      return true;
    } else {
      return false;
    }
}

void balloonInsideWindow() {
  if (balloonY < 0+balloon.height) {
        balloonY = 0+balloon.height; 
    } else if (balloonY > height-balloon.height) {
          balloonY = height-balloon.height; 
      } else if (balloonX < 0+balloon.width) {
          balloonX= 0+balloon.width; 
      } else if (balloonX > width-balloon.width){
           balloonX= width-balloon.width; 
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
        balloonY = ( frequency - 600 ) / 3;
    }

    // println(theOscMessage.checkAddrPattern("/audio/frequency"));
    // println(theOscMessage.addrInt());
    
    // println(balloonY);
}