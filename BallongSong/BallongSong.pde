import netP5.*;
import oscP5.*;

OscP5 oscP5;

int state; 

float balloonX, balloonY; 
float noteX, noteY; 
int counter; 

boolean down, up, left, right;
float speed, balloonSpeed;

PImage balloon;
PImage note;
PImage background; 
PImage keys; 
PImage micInfo; 

String title, gameDescription1, gameDescription2;

Button playWithMicButton, playWithKeysButton, exitButton, playAgainButton; 

void setup() {
    
    size(1200,800);
    
    
    oscP5 = new OscP5(this, 7348);

    balloon = loadImage("balloon.png");
    note = loadImage("note.png");
    background = loadImage("sky.png"); 
    keys=loadImage("keys.png"); 
    micInfo=loadImage("micInfo.png"); 
    
    balloonX = width / 2;
    balloonY = height / 2;
    
    setNotePosition(); 
    imageMode(CENTER);
    playWithMicButton = new Button(loadImage("playWithMic.png"),loadImage("playWithMicHover.png"),300,500); 
    playWithKeysButton = new Button (loadImage("playWithKeys.png"),loadImage("playWithKeysHover.png"),900,500); 
    exitButton = new Button(loadImage("exit.png"),loadImage("exitHover.png"),1150,50); 
    playAgainButton = new Button(loadImage("playAgain.png"), loadImage("playAgainHover.png"), width / 2, 500);
    
    speed = 5;
    balloonSpeed=3; 
    
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
        case 3 :
            endScreen();
            break;
    }
}

void startScreen() {
    background(background);

    title = "Ballong-song";
    gameDescription1 = "Whistle to help the balloon gather its notes!"; 
    gameDescription2 = "You can also play with just the keys";

    textAlign(CENTER);
    textSize(60);
    text(title, width / 2, 200);
    textSize(30); 
    text(gameDescription1, width / 2, 250); 
    text(gameDescription2, width / 2, 300); 

    image(balloon, balloonX, balloonY);

    balloonY=balloonY-balloonSpeed; 
    if (balloonY<150||balloonY>600) {
      balloonSpeed=balloonSpeed *-1;
    }

    playWithMicButton.display(); 
    playWithKeysButton.display(); 

}

void playWithMic() {

    loadGame(); 

    image(micInfo,1100,720);

    updateX();
}
  
  void playWithKeys() {
    loadGame(); 

    image(keys,1100,720); 
    textSize(15); 
    fill(#000000); 
    text("Steer the balloon with your arrow keys",1050,770); 

    updateX();
    updateY(); 
}

  void loadGame() {
    background(background);

    // Ritar ut toner med linjer
    stroke(#ffffff);
    fill(#ffffff);
    text("C", 20, 50);
    line(0, 60, width, 60);
    text("B", 20, 95);
    line(0, 105, width, 105);
    text("A", 20, 185);
    line(0, 195, width, 195);
    text("G", 20, 275);
    line(0, 285, width, 285);
    text("F", 20, 365);
    line(0, 375, width, 375);
    text("E", 20, 410);
    line(0, 420, width, 420);
    text("D", 20, 500);
    line(0, 510, width, 510);
    text("C", 20, 590);
    line(0, 600, width, 600);

    imageMode(CENTER);

    exitButton.display();

    // ritar not
    image(note, noteX, noteY, 80, 80);
    
    // ritar luftballong
    image(balloon, balloonX, balloonY);
    
    //ritar counter 
    textSize(42);
    fill(#4488ff);
    text(counter, 60, height - 40);
    
    pointCounter();

}

void endScreen() {
    background(background);
    
    textSize(40);
    fill(#ffffff);
    text("Thank you for playing!", width / 2, 200);
    text("You got " + counter + " points", width / 2, 300);

    balloonY=balloonY-balloonSpeed; 
    if (balloonY<150||balloonY>600) {
      balloonSpeed=balloonSpeed *-1;
    }

    image(balloon, balloonX, balloonY);

    playAgainButton.display();
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
    state = 1; 
  } 

  if(playWithKeysButton.isMouseOverButton()) {
    state = 2; 
  }

  if(exitButton.isMouseOverButton()) {
      state = 3; 
  }

  if(playAgainButton.isMouseOverButton()) {
      state = 0;
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
        // genom att filtrera bort under 350
        if (frequency > 350.0) {
            // Dividerar frekvensen med 2 för att justera för vissling
            // Subtraherar med 600 för att få den att börja ungefär vid 0
            balloonY = (frequency - 600) / 2;
            // inverterar ballongens rörelse
            balloonY = balloonY * -1 + height;
        }
        
        // println(message.checkAddrPattern("/audio/frequency"));
        // println(theOscMessage.addrInt());
        
        // println(balloonY);
    }
}
