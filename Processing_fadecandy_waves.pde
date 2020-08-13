/**
 * Processing_fadecandy_waves.pde
 */

OPC opc;

public void setup() {
  size(720, 480);

  colorMode(HSB, 360, 100, 100);

  background(0);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  float spacing = min(height, width) / 16;

  // Map 4 lots of 8x8 grid of LEDs to the center of the window, scaled to take up most of the space
  opc.ledGrid8x8(0 * 64, width / 2 - spacing * 8 / 2, height / 2 - spacing * 8 / 2, spacing, 0, false, false);
  opc.ledGrid8x8(1 * 64, width / 2 + spacing * 8 / 2, height / 2 - spacing * 8 / 2, spacing, 0, false, false);
  opc.ledGrid8x8(2 * 64, width / 2 - spacing * 8 / 2, height / 2 + spacing * 8 / 2, spacing, 0, false, false);
  opc.ledGrid8x8(3 * 64, width / 2 + spacing * 8 / 2, height / 2 + spacing * 8 / 2, spacing, 0, false, false);

}

public void draw() {
  // Set background color, noStroke and fill color
//  background(0);
//  fill(255, 255, 255);
//  noStroke();
  float spacing = min(height, width) / 16;
  int mSec = millis();

  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
        setColourGraduatedRoll(x, y, mSec);
        circle(width / 2 - spacing * 8 + x * spacing + spacing / 2, height / 2 - spacing * 8 + y * spacing + spacing / 2, spacing / 2);
    }
  }
}

void setColourGraduated(int x, int y) {
//  int col = min(x, y) * 22;
//  int col = (int) (15.0 * sqrt(sq((float)x) + sq((float)y)));
    int col = (int) ((15.0 * sqrt(sq((float)x) + sq((float)y)) + 0.005 * millis()) % 7.0 / 8.0 * 360.0);

//  int col = (int) (20.0 * (float) (y + x) / sqrt(sq((float)x) + sq((float)y)));
//   float ang = (x == 0) ? PI / 2.0 : atan((float)y / (float)x);
//   int col = (int)(14.0 * (float)y / sin(ang));
  fill(col, 90, 50);
}

void setColourGraduatedRoll(int x, int y, int mSec) {
  int hue = (int) ((7.0 / 8.0 * 360.0 + 0.04 * mSec - 15.0 * sqrt(sq((float)x - 7.5) + sq((float)y - 7.5))) % (7.0 / 8.0 * 360.0));
  fill(hue, 60, 60);
}
