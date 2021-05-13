import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import netP5.*; 
import oscP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FlappySong extends PApplet {




OscP5 oscP5;

int state; 

float balloonX, balloonY; 
float noteX, noteY; 
int counter; 

boolean down, up, left, right;
float speed,balloonSpeed;

PImage balloon;
PImage note;
PImage background; 
PImage keys; 
PImage micInfo; 

Button playWithMicButton, playWithKeysButton; 

public void setup() {
    
    
    
    
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

    speed = 5;
    balloonSpeed=3; 
    
    state = 0; 
}

public void draw() {
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

public void startScreen() {
    background(background);

    image(balloon, balloonX, balloonY);

    balloonY=balloonY-balloonSpeed; 
    if (balloonY<150||balloonY>600) {
      balloonSpeed=balloonSpeed *-1;
    }


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

  public void playWithMic() {
   loadGame(); 

   image(micInfo,1100,720);

   updateX();
}
  
  public void playWithKeys() {
    loadGame(); 

    image(keys,1100,720); 
    textSize(15); 
    fill(0xff000000); 
    text("Steer the balloon with your arrow keys",1050,770); 

    updateX();
    updateY(); 
}
  public void loadGame() {
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

public void updateX() {
    if (left == true && balloonX > 0 + balloon.width / 2) {
        balloonX -= speed;
    }
    if (right == true && balloonX < width - balloon.width / 2) {
        balloonX += speed;
    }
}

public void updateY() {
    if (down == true && balloonY + balloon.height / 2 < height) {
          balloonY += speed;
    }
    if (up == true && balloonY > 0 + balloon.height / 2) {
          balloonY -= speed;
    }
}
  
  public void pointCounter() {
    //kollar ifall ballongen är över noten. Ifall den är det så räknas counter upp
    if (isBalloonOverNote()) {
        counter++; 
        setNotePosition();
    } 
}
  
  public void keyPressed() {
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
  
  public void keyReleased() {
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

public void mousePressed() {
  if(playWithMicButton.isMouseOverButton()) {
    state=1; 
  } 

  if(playWithKeysButton.isMouseOverButton()) {
    state=2; 
  }
}
  
  public float randomizeFloat(float min, float max) {
    float pos;
    pos = random(min, max);
    return pos;
}
  
  public void setNotePosition() {
    noteX = randomizeFloat(100, width - 100); 
    noteY = randomizeFloat(100, height - 100); 
}
  
  public boolean isBalloonOverNote() {
    //if (balloonX > noteX && balloonX < noteX + note.width / 2 && balloonY > noteY && balloonY < noteY + note.height / 2) {
    if (balloonX > noteX - note.width / 2 && balloonX < noteX + note.width / 2 &&
        balloonY > noteY - note.height / 2 && balloonY < noteY + note.height / 2) {
        return true;
    } else {
        return false;
    }
}
  
  
  public void oscEvent(OscMessage message) {
    if (state == 1) {
        float frequency;
        
        message.setAddrPattern("/audio/frequency");
        frequency = message.get(0).floatValue();
        
        // försöker ta bort cirkelrörelse från bakgrundsljud
        // genom att filtrera bort under 200
        if (frequency > 350.0f) {
            // Dividerar med 3 för att justera för vissel-frekvenser
            // Subtraherar med 200 för att få den att börja ungefär vid 0
            balloonY = (frequency - 600) / 4;
        }
        
        println(message.checkAddrPattern("/audio/frequency"));
        // println(theOscMessage.addrInt());
        
        // println(balloonY);
    }
}
class Button {
  PImage image, hover; 
  int posX, posY; 

  Button(PImage image, int posX, int posY) {
    this.image = image; 
    this.posX = posX;
    this.posY = posY;
  }

  Button(PImage noHover, PImage hover, int posX, int posY) {
    this.image = noHover; 
    this.hover = hover; 
    this.posX = posX;
    this.posY = posY;
  }

  public boolean hasHoverState() {
    if (hover!=null) {
      return true;
    }

    return false;
  }

  public boolean isMouseOverButton() {
    if (mouseX > posX - image.width / 2 && mouseX < posX + image.width / 2 &&
      mouseY > posY - image.height / 2 && mouseY < posY + image.height / 2 ) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {
    image(image, posX, posY); 
    if (isMouseOverButton() && hasHoverState()) {
      image(hover, posX, posY);
    }
  }
}
  public void settings() {  size(1200,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FlappySong" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
