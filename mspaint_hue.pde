/*
  Poor man's MS Paint
*/

int hue = 0; 
int areWeDrawing = 1;
int brushSize = 10;

int menuHeight = 40;
int outlineWeight = 1;

int hueLastFrame;
int brushSizeLastFrame;
int xPositionLastFrame;
int yPositionLastFrame;

boolean isCommandPressed = false;
  
void setup() {
  size(1100, 600);
  background(255);
  
  // set color mode to Hue/Saturation/Brightness instead of RGB
  colorMode(HSB, 100);
}

void draw() {

  // set our colors
  // much like Drake, HSB color mode is on a 0-100 scale, rather than RGB's 0-255
  stroke(hue, 100, 100);
  fill(hue, 100, 100);

  drawBrush();
  
  // create the bottom menu (a rainbow color selector)
  drawColorMenu();
  
  drawPlusAndMinus();
}

void drawBrush() { 
  if(areWeDrawing == 1) {
    // erase old outline
    eraseOldOutline();
  }
  
   // draw outline
    stroke(0);
    strokeWeight(outlineWeight);

  // draw at our current mouse position
  if(areWeDrawing == 1) {
    rect(mouseX, mouseY, brushSize, brushSize);
  } 
  
  // record last outline
  hueLastFrame = hue;
  brushSizeLastFrame = brushSize;
  xPositionLastFrame = mouseX;
  yPositionLastFrame = mouseY;
}

void eraseOldOutline() {
  stroke(hueLastFrame, 100, 100);
  strokeWeight(outlineWeight);
  fill(hueLastFrame, 100, 100);
  
  rect(xPositionLastFrame, yPositionLastFrame, brushSizeLastFrame, brushSizeLastFrame);
}

void drawPlusAndMinus() {
  strokeWeight(10);
  stroke(0,0,0);
  
  // draw plus
  line(50, 50, 100, 50);
  line(75, 25, 75, 75);
 
  // draw minus
  line(50, 150, 100, 150); 
}

void keyPressed() {
    // pressing space turns off drawing
  if(key ==  ' ') {
    if(areWeDrawing == 1) {
      areWeDrawing = 0;
      eraseOldOutline();
    } else {
      areWeDrawing = 1;
    }
  }
  
  if(key == CODED && keyCode == 157) {
      isCommandPressed = true;
      println("pressed");
  }
  
  if(isCommandPressed && key == 's') {
    save("saveddrawing.tiff");
    println("saved");
  }
}

void keyReleased () {
    if(key == CODED && keyCode == 157) {
      isCommandPressed = false;
      println("released");
  }
}


void mousePressed() {
  // if we are within the bottom menu, set the color (hue)
  // to the correct color for our X mouse position
  if (mouseY > height-menuHeight && mouseY < height) {
    hue = hueForXPosition(mouseX);
  }
  
  // if we are within the + button, increase our drawing size
  if (mouseX > 50 && mouseX < 100 && mouseY > 25 && mouseY < 75) {
    brushSize += 5;
  }  
  
  // if we are within the - button, decrease our drawing size
  if (mouseX > 50 && mouseX < 100 && mouseY > 125 && mouseY < 175) {
    brushSize -= 5;
  }
}

void drawColorMenu() {
  // for each x position, from the left (0) until the right (width, currently 800),
  // draw a 20-pixel-high line in the right color for that position
  // this will make a rainbow effect
  for(int i = 0; i < width; i++) {
    int hue = hueForXPosition(i);
    stroke(hue, 100, 100);    // HSB format, not RGB
    line(i, height-menuHeight, i, height);
  }
}

int hueForXPosition(int x) {
  // we need to map an x position, which can be anywhere from 0 to width
  // to a 0-100 scale, representing a hue
  float scalingFactor = 100.0/width;
  float hue = x * scalingFactor;
  
  // convert hue to an int when we return it
  return int(hue);
}
