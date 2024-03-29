import processing.serial.*;

Serial serialPort;

int NUM_LEDS = 60;                   // How many LEDs in your strip?
color[] leds = new color[NUM_LEDS];  // array of one color for each pixel

void setup() {
  size(900, 600);
  frameRate(30);

  printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "/dev/tty.usbmodem1101", 115200);
}

void draw() {
  background(0);

  // doing some drawing to the screen here
  fill(255);
  noStroke();
  ellipse(mouseX, mouseY, 100, 100);

  // this samples colors from a pixel on the canvas for each LED in the strip
  for (int i=0; i < NUM_LEDS; i++) {
    int x = floor(width/2);
    int y = floor(height/NUM_LEDS * i);
    int col = get(x, y);
    stroke(255, 0, 0);
    noFill();
    rect(x-1, y-1, 3, 3);
    // and stores the color in the array
    leds[i] = col;
  }

  sendColors();                        // send the array of colors to Arduino
}



// the helper function below sends the colors
// in the "strip" array to a connected Arduino
// running the "neopixel_binary_arduino" sketch

void sendColors() {
  byte[] out = new byte[NUM_LEDS*3];
  for (int i=0; i < NUM_LEDS; i++) {
    out[i*3]   = (byte)(floor(red(leds[i])) >> 1);
    if (i == 0) {
      out[0] |= 1 << 7;
    }
    out[i*3+1] = (byte)(floor(green(leds[i])) >> 1);
    out[i*3+2] = (byte)(floor(blue(leds[i])) >> 1);
  }
  serialPort.write(out);
}
