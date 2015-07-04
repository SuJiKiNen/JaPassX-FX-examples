import ass.object.*;
import ass.object.*;
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/62215*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
int[][] fire;

// Flame colors
color[] palette;
float angle;
int[] calc1, calc2, calc3, calc4, calc5;

PImage base;

ASS ass = ASSParser.parseFile("G:\\FXWorks\\ALTIMA\\I‘ll believe.ass",29.970);
Line [] lines = ass.getLines(); 

void setup() {
  size(ass.meta.width, ass.meta.height);
  background(255);
  calc1 = new int[width];
  calc3 = new int[width];
  calc4 = new int[width];
  calc2 = new int[height];
  calc5 = new int[height];

  colorMode(HSB);

  fire = new int[width][height];
  palette = new color[255];

  // Generate the palette
  for (int x = 0; x < palette.length; x++) {
    //Hue goes from 0 to 85: red to yellow
    //Saturation is always the maximum: 255
    //Lightness is 0..255 for x=0..128, and 255 for x=128..255
    palette[x] = color(x/3, 255, constrain(x*3, 0, 255));
  }

  // Precalculate which pixel values to add during animation loop
  // this speeds up the effect by 10fps
  for (int x = 0; x < width; x++) {
    calc1[x] = x % width;
    calc3[x] = (x - 1 + width) % width;
    calc4[x] = (x + 1) % width;
  }

  for (int y = 0; y < height; y++) {
    calc2[y] = (y + 1) % height;
    calc5[y] = (y + 2) % height;
  }
  frameRate(ass.meta.frameRate);
  println(lines[9].time.start);
  Time.shift(lines,-lines[0].time.start+1);
}

void draw() {
  background(255);
  boolean hasText = false;
  for(int i=0; i<lines.length; i++) {
    Line line = lines[i];
    int lastSylEndTime = line.syls.get( line.syls.size()-1 ).time.end;
    if(frameCount>=line.time.start && frameCount<min(line.time.end,lastSylEndTime)) {
       if(line.style.equals("main")) {
        String fileName=String.valueOf(frameCount)+".png";
        base= loadImage(fileName);
        hasText = true;
        //println(line.i+" "+line.time.start+" "+line.time.end);
       }
    }
  }
  if(!hasText) {
     base = createImage(width,height,RGB);
  }
  // Randomize the bottom row of the fire buffer

  /*
  for(int x = 0; x < width; x++)
   {
   // fire[x][height-1] = int(random(0,190)) ;
   fire[x][height-1] = int (noise(x,frameCount*0.01)*190);
   }
   */

  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      float t = (int)(brightness(base.get(x, y)));
      // println( brightness(base.get(x, y)) );
      if (t>125) {
        fire[x][y] = (int)(t*noise(x*0.03, frameCount*0.03));
        //println(t);
      }
    }
  }
  //main fx
  loadPixels();

  int counter = 0;
  // Do the fire calculations for every pixel, from top to bottom
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // Add pixel values around current pixel
      counter = y*width + x;
      fire[x][y] =
        ((fire[calc3[x]][calc2[y]]
        + fire[calc1[x]][calc2[y]]
        + fire[calc4[x]][calc2[y]]
        + fire[calc1[x]][calc5[y]]) << 5) / 140;

      // Output everything to screen using our palette colors

        pixels[counter] = palette[fire[x][y]];

    }
  }
  updatePixels();
  if (frameCount<lines[ lines.length-1 ].time.end+200) {
    String name = String.format("results\\%d.png",frameCount);
    saveFrame(name);
  }else{
    exit();
  }
}
