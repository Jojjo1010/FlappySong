import netP5.*;
import oscP5.*;

OscP5 oscP5;

float posY; 

void setup() {
    size(1200,800);
    
    oscP5 = new OscP5(this, 7348);
    
}

void draw() {
    background(#aaaaaa);
    
    //kollar ifall cirkeln är utanför fönstret. Om den är det för den att dirkeln hamnar i fönstret
    if (posY < 0) {
        posY = 0; 
    } else if (posY > height) {
          posY = height; 
      }
    
    //ritar cirkeln
    ellipse(width / 2, posY, 50, 50); 
    
    
}



void oscEvent(OscMessage theOscMessage) {
    
    theOscMessage.setAddrPattern("/audio/frequency");
    
    posY = theOscMessage.get(0).floatValue();
    
    // println(theOscMessage.checkAddrPattern("/audio/frequency"));
    // println(theOscMessage.addrInt());
    
    println(posY);
}