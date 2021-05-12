import netP5.*;
import oscP5.*;

OscP5 oscP5;

int state; 

float balloonX, balloonY; 
float noteX, noteY; 
int counter; 

boolean down, up, left, right;
float speed;

PImage balloon;
PImage note;
PImage background; 

Button playWithMicButton, playWithKeysButton; 

void setup() {
    
    size(1200,800);
    
    
    oscP5 = new OscP5(this, 7348);
    
    balloon = loadImage("balloon.png");
    note = loadImage("note.png");
    background = loadImage("sky.png"); 
    
    balloonX = width / 2;
    balloonY = height / 2;
    
    setNotePosition(); 

    playWithMicButton = new Button(loadImage("playWithMic.png"),loadImage("playWithMicHover.png"),100,500); 
    playWithKeysButton = new Button (loadImage("playWithKeys.png"),loadImage("playWithKeysHover.png"),700,500); 

    
    speed = 5;
    
    state = 0; 
}

void draw() {
    switch(state) {
        case 0 : 
            startScreen(); 
            break;
        
        case 1 : 
            playWithMic(); 
            break; 
        
        case 2 : 
            playWithKeys(); 
            break; 
    }
}

void startScreen() {
    background(background);

    String title;
    String gameDescription1;
    String gameDescription2;
    title = "GameTitle";
    gameDescription1 = "Whistle to help the balloon gather its notes!"; 
    gameDescription2 = "You can also play with just the keys";

    textAlign(CENTER);
    textSize(60);
    text(title, width / 2, 200);
    textSize(30); 
    text(gameDescription1, width / 2, 300); 
    text(gameDescription2, width / 2, 350); 

    playWithKeysButton.display(); 
    playWithMicButton.display(); 

}

  void playWithMic() {
   loadGame(); 

   updateX();
}
  
  void playWithKeys() {
    loadGame(); 

    updateX();
    updateY(); 
}
  void loadGame() {
    background(background);
    
    imageMode(CENTER);
    
    // ritar not
    image(note, noteX, noteY, 80, 80);
    
    // ritar luftballong
    image(balloon, balloonX, balloonY);
    
    //ritar counter 
    textSize(42);
    text(counter, 40, 80);
    
    pointCounter();
}

void updateX() {
    if (left == true && balloonX > 0 + balloon.width / 2) {
        balloonX -= speed;
    }
    if (right == true && balloonX < width - balloon.width / 2) {
        balloonX += speed;
    }
}

void updateY() {
    if (down == true && balloonY + balloon.height / 2 < height) {
          balloonY += speed;
    }
    if (up == true && balloonY > 0 + balloon.height / 2) {
          balloonY -= speed;
    }
}
  
  void pointCounter() {
    //kollar ifall ballongen är över noten. Ifall den är det så räknas counter upp
    if (isBalloonOverNote()) {
        counter++; 
        setNotePosition();
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

void mousePressed() {
  if(playWithMicButton.isMouseOverButton()) {
    state=1; 
  } 

  if(playWithKeysButton.isMouseOverButton()) {
    state=2; 
  }
}
  
  float randomizeFloat(float min, float max) {
    float pos;
    pos = random(min, max);
    return pos;
}
  
  void setNotePosition() {
    noteX = randomizeFloat(100, width - 100); 
    noteY = randomizeFloat(100, height - 100); 
}
  
  boolean isBalloonOverNote() {
    //if (balloonX > noteX && balloonX < noteX + note.width / 2 && balloonY > noteY && balloonY < noteY + note.height / 2) {
    if (balloonX > noteX - note.width / 2 && balloonX < noteX + note.width / 2 &&
        balloonY > noteY - note.height / 2 && balloonY < noteY + note.height / 2) {
        return true;
    } else {
        return false;
    }
}
  
  
  void oscEvent(OscMessage message) {
    if (state == 1) {
        float frequency;
        
        message.setAddrPattern("/audio/frequency");
        frequency = message.get(0).floatValue();
        
        // försöker ta bort cirkelrörelse från bakgrundsljud
        // genom att filtrera bort under 200
        if (frequency > 350.0) {
            // Dividerar med 3 för att justera för vissel-frekvenser
            // Subtraherar med 200 för att få den att börja ungefär vid 0
            balloonY = (frequency - 600) / 4;
        }
        
        println(message.checkAddrPattern("/audio/frequency"));
        // println(theOscMessage.addrInt());
        
        // println(balloonY);
    }
}
