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

  boolean hasHoverState() {
    if (hover!=null) {
      return true;
    }

    return false;
  }

  boolean isMouseOverButton() {
    if (mouseX > posX - image.width / 2 && mouseX < posX + image.width / 2 &&
      mouseY > posY - image.height / 2 && mouseY < posY + image.height / 2 ) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    image(image, posX, posY); 
    if (isMouseOverButton() && hasHoverState()) {
      image(hover, posX, posY);
    }
  }
}