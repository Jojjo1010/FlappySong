import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float posX; 
float posY; 

void setup() {
    size(1200,800);
    
    oscP5 = new OscP5(this, "192.168.1.70", 7348);
    
    myRemoteLocation = new NetAddress("192.168.1.70", 7348);
}

void draw() {
    
    ellipse(width / 2, posY, 50, 50); 
    
}

void oscEvent(OscMessage theOscMessage) {
    
    // posY = theOscMessage;
    
    println(theOscMessage);
  }