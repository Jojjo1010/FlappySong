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

float posX, posY; 

boolean down, up, left, right;
float speed;

PImage balloon;

public void setup() {

    

    oscP5 = new OscP5(this, 7348);

    balloon = loadImage("balloon.png");

    posX = width / 2;
    posY = height / 2;

    speed = 5;
}

public void draw() {
    background(0xff4488ff);
    
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

public void update() {
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

public void oscEvent(OscMessage message) {

    float frequency;

    message.setAddrPattern("/audio/frequency");
    frequency = message.get(0).floatValue();

    // försöker ta bort cirkelrörelse från bakgrundsljud
    // genom att filtrera bort under 200
    if ( frequency > 350.0f ) {
        // Dividerar med 3 för att justera för vissel-frekvenser
        // Subtraherar med 200 för att få den att börja ungefär vid 0
        posY = ( frequency / 3 ) - 200;
    }

    // println(theOscMessage.checkAddrPattern("/audio/frequency"));
    // println(theOscMessage.addrInt());
    
    println(posY);
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
