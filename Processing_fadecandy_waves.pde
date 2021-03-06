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
float xFocus;
float yFocus;

// for exit, fade in and fade out
int exitTimer = 0;
int start_ms = 0;
int fadeLevel = 100;
boolean fadeInDone = false;

public void setup() {
  apply_cmdline_args();

  size(720, 480, P2D);

  colorMode(HSB, 360, 100, 100);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;
  xFocus = (boxesAcross * ledsAcross - 1) / 2.0;
  yFocus = (boxesDown * ledsDown - 1) / 2.0;

  final int boxCentre = (int)((ledsAcross - 1) / 2.0 * spacing); // probably using the centre in the ledGrid8x8 method
  int ledCount = 0;
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross + boxCentre, y0 + spacing * y * ledsDown + boxCentre, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }
}

public void draw() {
  fadein(20, 2500);

  fadeout_exit(25, 2500);

  background(0);

  int mSec = millis();
  for (int y = 0; y < boxesDown * ledsDown; y++) {
    for (int x = 0; x < boxesAcross * ledsAcross; x++) {
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
  fill(hue, 75, fadeLevel);
}

void apply_cmdline_args()
{
  if (args == null) {
    return;
  }
  for (String exp: args) {
      String[] comp = exp.split("=");
      switch (comp[0]) {
        case "exit":
          exitTimer = parseInt(comp[1], 10);
          println("exit after " + exitTimer + "s");
          break;
      }
  }
}

void fadein(int fromPercent, int duration_ms) {

  if (exitTimer == 0) { // skip if not run from cmd line
    return;
  }

  if (fadeInDone) { // skip if already set to 100%
    return;
  }

  int m = millis();
  if (start_ms == 0) { // program will have been executing for a while before getting here
    start_ms = m;
  }
  if (m - start_ms < duration_ms) {
    fadeLevel = (int)(100 - (100 - fromPercent) * (float) (duration_ms - m + start_ms) / duration_ms);
  } else {
    fadeLevel = 100;
    fadeInDone = true;
  }
}

void fadeout_exit(int toPercent, int duration_ms) {

  if (exitTimer == 0) { // skip if not run from cmd line
    return;
  }

  int m = millis();
  if (m / 1000 >= exitTimer) {
    exit();
  } else if ((m + duration_ms) / 1000 >= exitTimer) {
    fadeLevel = (int)(100 - (100 - toPercent) * ((float)(m + duration_ms) / 1000 - exitTimer) / ((float)duration_ms / 1000));
  }
}
