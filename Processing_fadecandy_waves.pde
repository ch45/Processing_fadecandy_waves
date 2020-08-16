/**
 * Processing_fadecandy_waves.pde
 */

OPC opc;

final int boxesAcross = 2;
final int boxesDown = 2;
final int ledsAcross = 8;
final int ledsDown = 8;
// initialized in setup()
float spacing;
int x0;
int y0;
int xFocus;
int yFocus;

public void setup() {
  size(720, 480);

  colorMode(HSB, 360, 100, 100);

  background(0);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;
  xFocus = (boxesAcross * ledsAcross - 1) / 2;
  yFocus = (boxesDown * ledsDown - 1) / 2;

  int ledCount = 0;
  for (int x = 0; x < boxesAcross; x++) {
    for (int y = 0; y < boxesDown; y++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross, y0 + spacing * y * ledsDown, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }
}

public void draw() {
  int mSec = millis();

  for (int x = 0; x < boxesAcross * ledsAcross; x++) {
    for (int y = 0; y < boxesDown * ledsDown; y++) {
        setColourGraduatedRoll(x, y, mSec);
        circle(x0 + spacing * x, y0 + spacing * y, spacing / 2);
    }
  }
}

void setColourGraduated(int x, int y) {
  int col = (int) ((2 * sqrt(sq((float)x - xFocus) + sq((float)y - yFocus)) + 0.005 * millis()) % 7.0 / 8.0 * 360.0);
  fill(col, 90, 50);
}

void setColourGraduatedRoll(int x, int y, int mSec) {
  int hue = (int) ((7.0 / 8.0 * 360.0 + 0.04 * mSec - 15.0 * sqrt(sq((float)x - xFocus) + sq((float)y - yFocus))) % (7.0 / 8.0 * 360.0));
  fill(hue, 60, 60);
}
